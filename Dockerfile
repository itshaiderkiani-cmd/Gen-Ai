FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps (kept minimal)
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy app source code
COPY app.py .
COPY templates/ ./templates/
COPY static/ ./static/

EXPOSE 5000

# Run with Gunicorn for production-like server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
