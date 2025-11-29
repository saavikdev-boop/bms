"""
File Upload and Management Router
Handles file uploads, downloads, and deletions
"""
from fastapi import APIRouter, UploadFile, File, HTTPException, Response
from fastapi.responses import FileResponse
from typing import Optional
import os

from app.services.storage_service import storage_service

router = APIRouter(prefix="/files", tags=["files"])


@router.post("/upload")
async def upload_file(
    file: UploadFile = File(...),
    bucket: str = "documents",
    prefix: str = ""
):
    """
    Upload a file to storage.

    Args:
        file: File to upload
        bucket: Storage bucket (profile_images, product_images, venue_images, reels, documents)
        prefix: Optional prefix for organization

    Returns:
        File upload result with file_path and file_url
    """
    try:
        # Read file content
        file_content = await file.read()

        # Determine max size based on bucket
        max_size_mb = 10
        if bucket == 'reels':
            max_size_mb = 100  # Allow larger videos
        elif bucket == 'profile_images' or bucket == 'product_images':
            max_size_mb = 5  # Smaller limit for images

        # Upload file
        result = storage_service.upload_file(
            file_content=file_content,
            filename=file.filename,
            bucket=bucket,
            prefix=prefix,
            max_size_mb=max_size_mb
        )

        if not result['success']:
            raise HTTPException(status_code=400, detail=result['error'])

        return {
            "message": "File uploaded successfully",
            "file_path": result['file_path'],  # Store this in database
            "file_url": result['file_url'],    # Use this for display
            "filename": result['filename'],
            "size_bytes": result['size_bytes']
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to upload file: {str(e)}")


@router.get("/{file_path:path}")
async def get_file(file_path: str):
    """
    Download/retrieve a file from storage.

    Args:
        file_path: Relative file path (e.g., 'profile_images/file.jpg')

    Returns:
        File content with appropriate content type
    """
    file_content = storage_service.get_file(file_path)

    if file_content is None:
        raise HTTPException(status_code=404, detail="File not found")

    # Determine content type
    import mimetypes
    content_type, _ = mimetypes.guess_type(file_path)
    if content_type is None:
        content_type = "application/octet-stream"

    return Response(content=file_content, media_type=content_type)


@router.delete("/{file_path:path}")
async def delete_file(file_path: str):
    """
    Delete a file from storage.

    Args:
        file_path: Relative file path (e.g., 'profile_images/file.jpg')

    Returns:
        Success message
    """
    success = storage_service.delete_file(file_path)

    if not success:
        raise HTTPException(status_code=404, detail="File not found or already deleted")

    return {"message": "File deleted successfully", "file_path": file_path}
