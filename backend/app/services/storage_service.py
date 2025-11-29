"""
Enterprise Storage Service
Handles file storage with easy migration path to S3
"""
import os
import uuid
import shutil
from pathlib import Path
from typing import Optional, BinaryIO
from datetime import datetime
import mimetypes

class StorageService:
    """
    Abstraction layer for file storage.
    Currently uses local filesystem, designed for easy S3 migration.
    """

    def __init__(self, base_path: str = None):
        """
        Initialize storage service.

        Args:
            base_path: Base directory for file storage (defaults to backend/buckets)
        """
        if base_path is None:
            # Get the backend directory (parent of app directory)
            backend_dir = Path(__file__).parent.parent.parent
            base_path = backend_dir / "buckets"

        self.base_path = Path(base_path)
        self.base_path.mkdir(parents=True, exist_ok=True)

        # Define bucket categories
        self.buckets = {
            'profile_images': self.base_path / 'profile_images',
            'product_images': self.base_path / 'product_images',
            'venue_images': self.base_path / 'venue_images',
            'reels': self.base_path / 'reels',
            'documents': self.base_path / 'documents',
        }

        # Create all bucket directories
        for bucket_path in self.buckets.values():
            bucket_path.mkdir(parents=True, exist_ok=True)

    def _generate_filename(self, original_filename: str, prefix: str = "") -> str:
        """
        Generate a unique filename to prevent collisions.

        Args:
            original_filename: Original filename with extension
            prefix: Optional prefix for organization

        Returns:
            Unique filename in format: prefix_timestamp_uuid_original.ext
        """
        timestamp = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
        unique_id = str(uuid.uuid4())[:8]

        # Sanitize original filename
        name, ext = os.path.splitext(original_filename)
        sanitized_name = "".join(c for c in name if c.isalnum() or c in "._- ")[:50]

        if prefix:
            return f"{prefix}_{timestamp}_{unique_id}_{sanitized_name}{ext}"
        return f"{timestamp}_{unique_id}_{sanitized_name}{ext}"

    def _validate_file(self, file_content: bytes, allowed_types: list = None, max_size_mb: int = 10) -> tuple[bool, Optional[str]]:
        """
        Validate file content and type.

        Args:
            file_content: File content as bytes
            allowed_types: List of allowed MIME types (None = allow all)
            max_size_mb: Maximum file size in MB

        Returns:
            Tuple of (is_valid, error_message)
        """
        # Check file size
        size_mb = len(file_content) / (1024 * 1024)
        if size_mb > max_size_mb:
            return False, f"File size ({size_mb:.2f}MB) exceeds maximum allowed size ({max_size_mb}MB)"

        # Check file type if specified
        if allowed_types:
            # This is a basic check - in production, use python-magic for better detection
            # For now, we'll skip strict MIME checking
            pass

        return True, None

    def upload_file(
        self,
        file_content: bytes,
        filename: str,
        bucket: str,
        prefix: str = "",
        allowed_types: list = None,
        max_size_mb: int = 10
    ) -> dict:
        """
        Upload a file to storage.

        Args:
            file_content: File content as bytes
            filename: Original filename
            bucket: Bucket category (profile_images, product_images, etc.)
            prefix: Optional prefix for organization
            allowed_types: List of allowed MIME types
            max_size_mb: Maximum file size in MB

        Returns:
            Dictionary with file info: {
                'success': bool,
                'file_path': str,  # Relative path for DB storage
                'file_url': str,   # URL for accessing the file
                'filename': str,   # Generated unique filename
                'error': str       # Error message if failed
            }
        """
        try:
            # Validate bucket
            if bucket not in self.buckets:
                return {
                    'success': False,
                    'error': f"Invalid bucket '{bucket}'. Available: {list(self.buckets.keys())}"
                }

            # Validate file
            is_valid, error = self._validate_file(file_content, allowed_types, max_size_mb)
            if not is_valid:
                return {'success': False, 'error': error}

            # Generate unique filename
            unique_filename = self._generate_filename(filename, prefix)

            # Get bucket path
            bucket_path = self.buckets[bucket]
            file_path = bucket_path / unique_filename

            # Write file
            with open(file_path, 'wb') as f:
                f.write(file_content)

            # Generate relative path for DB storage (easy S3 migration)
            relative_path = f"{bucket}/{unique_filename}"

            # Generate URL (will be replaced with S3 URL later)
            file_url = f"/api/v1/files/{relative_path}"

            return {
                'success': True,
                'file_path': relative_path,  # Store this in DB
                'file_url': file_url,
                'filename': unique_filename,
                'size_bytes': len(file_content)
            }

        except Exception as e:
            return {
                'success': False,
                'error': f"Failed to upload file: {str(e)}"
            }

    def get_file(self, file_path: str) -> Optional[bytes]:
        """
        Retrieve a file from storage.

        Args:
            file_path: Relative file path (e.g., 'profile_images/file.jpg')

        Returns:
            File content as bytes, or None if not found
        """
        try:
            full_path = self.base_path / file_path

            if not full_path.exists():
                return None

            with open(full_path, 'rb') as f:
                return f.read()

        except Exception:
            return None

    def delete_file(self, file_path: str) -> bool:
        """
        Delete a file from storage.

        Args:
            file_path: Relative file path (e.g., 'profile_images/file.jpg')

        Returns:
            True if deleted successfully, False otherwise
        """
        try:
            full_path = self.base_path / file_path

            if full_path.exists():
                os.remove(full_path)
                return True

            return False

        except Exception:
            return False

    def get_file_url(self, file_path: Optional[str]) -> Optional[str]:
        """
        Generate URL for a file.

        Args:
            file_path: Relative file path stored in DB

        Returns:
            Full URL for accessing the file
        """
        if not file_path:
            return None

        # For local storage
        return f"/api/v1/files/{file_path}"

        # For S3 migration, replace with:
        # return f"https://{bucket_name}.s3.{region}.amazonaws.com/{file_path}"

    def migrate_to_s3(self, aws_bucket: str, aws_region: str = "us-east-1"):
        """
        Placeholder for S3 migration logic.

        When ready to migrate:
        1. Initialize boto3 S3 client
        2. Upload all files from local buckets to S3
        3. Update database file_path references
        4. Switch upload_file to use S3 instead of local

        Args:
            aws_bucket: S3 bucket name
            aws_region: AWS region
        """
        raise NotImplementedError(
            "S3 migration not implemented. "
            "Install boto3 and implement S3 upload logic here."
        )


# Singleton instance
storage_service = StorageService()
