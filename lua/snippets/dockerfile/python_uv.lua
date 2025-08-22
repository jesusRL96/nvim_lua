return {
  s({
    trig = "uv-python",
    dscr = "Dockerfile template for Python projects using uv",
  }, {
    t({"# Use an official Python runtime as a base image", "FROM python:"}),
    i(1, "3.12-slim"),
    t({"", "", "# Install uv", "COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv", ""}),
    t({"# Set environment variables", "ENV UV_PROJECT_ENVIRONMENT=/app/.venv", "ENV UV_LINK_MODE=copy", "", ""}),
    t({"# Set working directory", "WORKDIR /app", "", ""}),
    t({"# Copy dependency files", "COPY pyproject.toml uv.lock* ./", "", ""}),
    t({"# Install dependencies", "RUN uv sync --frozen --no-dev", "", ""}),
    t({"# Copy application code", "COPY . .", "", ""}),
    t({"# Expose port", "EXPOSE "}),
    i(2, "8000"),
    t({"", "", "# Run application", "CMD [\"uv\", \"run\","}),
    i(3, "your_main_script.py"),
    t({"]", ""}),
  }),
}
