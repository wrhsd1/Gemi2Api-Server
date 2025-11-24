FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install dependencies
COPY pyproject.toml .
RUN uv sync

# Copy patched upstream client and main application code
COPY client.py ./patched_gemini_client.py
# Copy application code
COPY main.py .

# Override the installed gemini_webapi client with our patched version
RUN uv run python - <<'PY'
from pathlib import Path
import shutil
import gemini_webapi

patched = Path("patched_gemini_client.py").resolve()
target = Path(gemini_webapi.__file__).resolve().parent / "client.py"
shutil.copy(patched, target)
print(f"Patched gemini_webapi client at {target}")
PY

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uv", "run", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
