# 1. Use a Python 3.12 image (or 3.9+)
FROM python:3.12-slim

# Set environment variables
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE my_project.settings
# Sets the Python Path to include the current directory
ENV PYTHONPATH /usr/src/app:$PYTHONPATH

# Set the working directory inside the container
WORKDIR /usr/src/app

# Install PostgreSQL client tools (needed for pg_isready and psycopg2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    postgresql-client \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire Django project code
COPY project_app /usr/src/app/

# Expose port 8000
EXPOSE 8000