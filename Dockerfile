# Stage 1: Build Django
FROM python:3.8 AS django-builder

WORKDIR /app

COPY django/requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

COPY django /app/
RUN python manage.py collectstatic --noinput

# Stage 2: Build Nginx
FROM nginx:latest AS nginx-builder

COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Stage 3: Final Image
FROM postgres:latest

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=server_001
ENV POSTGRES_USER=server_001
ENV POSTGRES_PASSWORD=server_001

# Copy Django project
COPY --from=django-builder /app /app

# Copy Nginx configuration
COPY --from=nginx-builder /etc/nginx/nginx.conf /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80
EXPOSE 5432
EXPOSE 8000

# Start services
CMD ["nginx", "-g", "daemon off;"]
