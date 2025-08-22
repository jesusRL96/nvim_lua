-- ~/.config/nvim/lua/snippets/docker.lua
return {
  s({
    trig = "uv-django-prod",
    dscr = "Dockerfile template for Django projects using uv",
  }, {
    t({"# Use an official Python runtime as a base image", "FROM python:"}),
    i(1, "3.12-slim"),
    t({"", "", "# Install uv and system dependencies", "COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv", "RUN apt-get update && apt-get install -y \\",
    "    libpq-dev \\", "    gcc \\", "    && rm -rf /var/lib/apt/lists/*", "", ""}),
    t({"# Set environment variables", "ENV UV_PROJECT_ENVIRONMENT=/app/.venv", "ENV UV_LINK_MODE=copy", "ENV PYTHONUNBUFFERED=1", "ENV DJANGO_SETTINGS_MODULE="}),
    i(2, "project.settings"),
    t({"", "", "# Set working directory", "WORKDIR /app", "", ""}),
    t({"# Copy dependency files", "COPY pyproject.toml uv.lock* ./", "", ""}),
    t({"# Install dependencies", "RUN uv sync --frozen --no-dev", "", ""}),
    t({"# Copy application code", "COPY . .", "", ""}),
    t({"# Collect static files", "RUN uv run python manage.py collectstatic --noinput", "", ""}),
    t({"# Expose port", "EXPOSE "}),
    i(3, "8000"),
    t({"", "", "# Run application", "CMD [\"uv\", \"run\", \"gunicorn\", "}),
    i(4, "\"project.wsgi"),
    t({":application\", \"--bind\", \"0.0.0.0:"}),
    i(5, "8000"),
    t({"\"]", ""}),
  }),
}
