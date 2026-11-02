# Troubleshooting — Module 1 (Leonid328)

## 1. `FileNotFoundError: data/products.csv`

**Symptom:** Streamlit shows “No data found”.

**Fix:**

```bash
python3 scripts/data/generate_ecommerce_data.py --products 500 --output data
docker compose up -d --build
```

Ensure `docker-compose.yml` mounts `./data:/app/data`.

## 2. `docker compose up` fails / port in use

```bash
ss -tlnp | grep 8501
docker compose down
docker compose up -d --build
```

## 3. VPS SSH timeout or host “hangs” during homework

**Cause observed:** parallel heavy jobs (Jupyter scipy image + `init_project.sh --build` + 50k-row telco generation) on ~7 GiB RAM.

**Fix:**

1. Run one heavy job at a time.
2. `docker system prune -f` to reclaim space (reclaimed **~1.24 GB** on 2026-11-02).
3. Stop Jupyter when building ecommerce: `cd /opt/mlops-hw/telco-churn-synthetic && docker compose stop jupyter`.

## 4. Jupyter notebook permission error on execute

If `nbconvert` fails writing to `/home/jovyan/work/` (volume owned by root):

```bash
docker compose exec -T -u jovyan jupyter jupyter nbconvert \
  --execute /home/jovyan/work/explore_data.ipynb \
  --output /tmp/explore_data_executed.ipynb
```

## 5. Generator missing Python deps on host

```bash
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
```

## 6. Streamlit returns non-200

Check logs: `docker compose logs -f chat-agent`. Rebuild after code changes: `docker compose up -d --build`.
