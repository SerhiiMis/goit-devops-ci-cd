DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'postgres',      # Default name for Postgres container
        'USER': 'postgres',      # Default user for Postgres container
        'PASSWORD': 'supersecretpassword', # Match the password in docker-compose.yml
        'HOST': 'db',            # This MUST match the service name in docker-compose.yml
        'PORT': '5432',
    }
}