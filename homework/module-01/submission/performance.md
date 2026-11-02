# Module 1: Performance baseline

**Student:** Leonid328  
**Date:** 2026-11-02  
**Environment:** VPS `76.13.249.47` (7.3 GiB RAM, Docker 29.x) + local validation

## Scope

Module 1 uses keyword search in pandas only (no LLM, no vector DB).

## Measurements

| Metric | Value | How measured |
|--------|-------|----------------|
| `generate_ecommerce_data.py` (quick / ~500 products) | ~30–90 s | VPS `init_project.sh --quick` (build dominates first run) |
| Streamlit cold start (Docker) | ~5–15 s | `time curl -s -o /dev/null -w '%{time_total}\n' http://127.0.0.1:8501/` |
| Streamlit warm HTTP 200 | ~0.02–0.08 s | same curl after container Up |
| Chat query (keyword filter, ~500 rows) | < 0.1 s | manual UI + negligible CPU in `docker stats` |
| Container memory (chat-agent) | ~150–350 MiB | `docker stats --no-stream` |

## Telco generator (related MLOps HW on same VPS)

| Step | Result |
|------|--------|
| `python src/generate_dataset.py --samples 10000` | ~1.5 MB CSV, ~20 s |
| `python src/generate_dataset_ext.py --samples 8000 --conv-samples 1200` | `telco_customers.csv`, `support_conversations.csv`, `knowledge_base.csv` |
| Jupyter `explore_data.ipynb` execute | ~90 s in `scipy-notebook` container |

## Bottlenecks

- **RAM:** full Jupyter + Docker build concurrently caused SSH banner timeout on VPS; run services sequentially on 8 GB hosts.
- **Search:** `str.contains` is O(n); will not scale past ~50k products without indexing or embeddings (later modules).

## Next optimizations (out of scope for module 1)

- Multi-stage Docker image, `polars`/`duckdb`, `@st.cache_data` TTL, separate build host from runtime.
