local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node

return {
  s({
    trig = "uv-django-compose",
    dscr = "Dockerfile for Django with uv and entrypoint",
  }, {
    t({
      "# Use an official Python runtime as a base image",
      "FROM python:3.12-slim",
      "",
      "# Install uv and system dependencies",
      "COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv",
      "RUN apt-get update && apt-get install -y \\",
      "\tlibpq-dev \\",
      "\tgcc \\",
      "\t&& rm -rf /var/lib/apt/lists/*",
      "",
      "# Set environment variables",
      "ENV UV_PROJECT_ENVIRONMENT=/venv",
      "ENV UV_LINK_MODE=copy",
      "ENV PYTHONUNBUFFERED=1",
      "ENV PATH=\"/venv/bin:$PATH\"",
      "",
      "# Set working directory",
      "WORKDIR /app",
      "",
      "# Copy only dependency files",
      "COPY pyproject.toml uv.lock* ./",
      "",
      "# Install dependencies to a separate directory",
      "RUN uv sync --frozen --no-dev",
      "",
      "# Use an entrypoint script",
      "COPY ./entrypoint.sh /app/entrypoint.sh",
      "RUN chmod +x /app/entrypoint.sh",
      "ENTRYPOINT [\"sh\", \"/app/entrypoint.sh\"]",
      "",
      "# Default command (will be overridden in docker-compose)",
      "CMD [\"uv\", \"run\", \"python\", \"manage.py\", \"runserver\", \"0.0.0.0:8000\"]",
    }),
  }),
}

