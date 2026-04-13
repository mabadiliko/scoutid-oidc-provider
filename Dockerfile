FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /app
ENV TZ="Europe/Stockholm"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

COPY pyproject.toml uv.lock ./
# Install only runtime dependencies for this production container image.
RUN uv sync --frozen --no-dev

ENV PATH="/app/.venv/bin:$PATH"

# Expect `main.py`, `static/`, and `templates/` to exist in the build context.
COPY main.py ./
COPY static/ ./static/
COPY templates/ ./templates/

CMD [ "python", "./main.py" ]
