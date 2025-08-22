-- ~/.config/nvim/lua/snippets/docker.lua
return {
  s({
    trig = "uv-django-dev",
    dscr = "Dockerfile template for Django development with uv",
  }, {
    t({"# Use an official Python runtime as a base image", "FROM python:"}),
    i(1, "3.12-slim"),
    t({"", "", "# Install uv and system dependencies", "COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv", "RUN apt-get update && apt-get install -y \\", 
    "\tlibpq-dev \\", "\tgcc \\", "\t&& rm -rf /var/lib/apt/lists/*", "", ""}),
    t({"# Set environment variables", "ENV UV_PROJECT_ENVIRONMENT=/app/.venv", "ENV UV_LINK_MODE=copy", "ENV PYTHONUNBUFFERED=1", "", ""}),
    t({"# Set working directory", "WORKDIR /app", "", ""}),
    t({"# Copy dependency files", "COPY pyproject.toml uv.lock* ./", "", ""}),
    t({"# Install dependencies (including dev)", "RUN uv sync --frozen", "", ""}),
    t({"# Copy application code", "COPY . .", "", ""}),
    t({"# Expose port", "EXPOSE "}),
    i(2, "8000"),
    t({"", "", "# Run development server", "CMD [\"uv\", \"run\", \"python\", \"manage.py\", \"runserver\", \"0.0.0.0:"}),
    f(function(args) return args[1] end, {2}),
    t({"\"]", ""}),
  }),
}
