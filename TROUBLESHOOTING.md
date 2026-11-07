# Troubleshooting Guide

## Module 01 (homework) — low-memory VPS

If SSH stops responding while Jupyter and `docker compose build` run together, stop Jupyter first, run `docker system prune -f`, then `./scripts/setup/init_project.sh --quick`. See also `homework/module-01/submission/troubleshooting.md`.

## Common Issues

### Services Won't Start

**Problem:** `docker-compose up -d` fails

**Solutions:**
```bash
# Check Docker is running
docker info

# Check ports are free
lsof -i :8001,8002,8003,5000

# View detailed errors
docker-compose logs
```

### Model File Not Found

**Problem:** ML service can't load model

**Solution:**
```bash
# Pull models from DVC
dvc pull

# Or regenerate dummy model
python scripts/setup/init_project.sh
```

... (more issues)