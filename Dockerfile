# Use slim Python base image to reduce size
FROM python:3.10-slim

# Install essential system dependencies only
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    poppler-utils \
    libgl1-mesa-glx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app files
COPY . .

# Environment settings
ENV FLASK_ENV=production
ENV PYTHONUNBUFFERED=1

# Expose Railway port
EXPOSE 8000

# Start app
CMD ["gunicorn", "-b", "0.0.0.0:8000", "wsgi:app"]
