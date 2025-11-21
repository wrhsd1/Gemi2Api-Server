FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install dependencies
COPY pyproject.toml .
RUN uv sync

# Copy full application after deps to avoid cache busting on every edit
COPY . .

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uv", "run", "python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
