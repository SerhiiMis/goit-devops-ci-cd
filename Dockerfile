# 1. Use a Python 3.12 image (or 3.9+)
FROM python:3.12-slim

# Set environment variables for better Django performance
ENV PYTHONUNBUFFERED 1
ENV DJANGO_SETTINGS_MODULE my_project.settings

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy dependency file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire Django project directory
# Assuming your Django project files are in a folder named 'project_app'
COPY project_app /usr/src/app/

# Expose port 8000 (Gunicorn/Django port)
EXPOSE 8000

# Run collectstatic and database migrations before starting the server
# (These steps are typical for Django deployment)
RUN python manage.py collectstatic --noinput

# 2. Run the Django server using Gunicorn (production WSGI server)
# Use '0.0.0.0' to listen on all interfaces inside the container
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "my_project.wsgi:application"]