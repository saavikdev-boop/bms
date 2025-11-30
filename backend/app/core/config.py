from pydantic_settings import BaseSettings
from typing import List, Optional, Union
import os


class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://owlturf_user:SaaVik%40dev@localhost:5432/owlturf"

    # API
    API_V1_STR: str = "/api/v1"
    PROJECT_NAME: str = "BMS API"

    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # CORS - Can be either a string or list
    BACKEND_CORS_ORIGINS: Union[str, List[str]] = ["*"]

    # Server
    HOST: str = "0.0.0.0"
    PORT: int = 8000

    # File Storage
    FILE_STORAGE_PATH: str = "buckets"
    MAX_FILE_SIZE_MB: int = 50

    # Environment
    ENVIRONMENT: str = "development"
    DEBUG: bool = True

    class Config:
        case_sensitive = True
        env_file = ".env"
        env_file_encoding = "utf-8"

    @property
    def cors_origins(self) -> List[str]:
        """Get CORS origins as a list"""
        if isinstance(self.BACKEND_CORS_ORIGINS, str):
            # Handle single value like "*" or comma-separated values
            if "," in self.BACKEND_CORS_ORIGINS:
                return [origin.strip() for origin in self.BACKEND_CORS_ORIGINS.split(",")]
            else:
                return [self.BACKEND_CORS_ORIGINS]
        return self.BACKEND_CORS_ORIGINS


settings = Settings()
