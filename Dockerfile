FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -
ENV PATH="/root/.local/bin:$PATH"

WORKDIR /app

# Copy dependency files first
COPY pyproject.toml poetry.lock* ./

# Make sure lock file exists and is valid
RUN if [ -f poetry.lock ]; then \
        poetry lock; \
    else \
        poetry lock; \
    fi

# Install dependencies
RUN poetry install --no-root --no-interaction --no-ansi

# Copy the rest of your project
EXPOSE 8000

CMD ["poetry", "run", "uvicorn", "main:app","--reload", "--host", "0.0.0.0", "--port", "8000"]
