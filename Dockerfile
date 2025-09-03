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

# Ensure lock file is in sync
RUN if [ -f poetry.lock ]; then \
        poetry lock --no-update; \
    fi

# Install dependencies
RUN poetry install --no-root --no-interaction --no-ansi

# Copy the rest of your project
COPY . .

# Default command (update if you have a different entrypoint)
CMD ["poetry", "run", "python", "main.py"]
