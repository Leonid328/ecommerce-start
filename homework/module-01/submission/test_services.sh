#!/usr/bin/env bash
# Module 01 — service and data smoke tests (Leonid328)

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
cd "$ROOT"

HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8501}"
BASE="http://${HOST}:${PORT}"

echo "=== Module 01 service tests (repo root: $ROOT) ==="

fail() { echo "[FAIL] $*"; exit 1; }
ok()   { echo "[OK] $*"; }

echo "--- Data files ---"
for file in data/products.csv data/reviews.csv data/user_queries.csv data/interactions.csv; do
  [[ -f "$file" ]] || fail "$file missing (run scripts/data/generate_ecommerce_data.py)"
  lines=$(wc -l < "$file" | tr -d ' ')
  [[ "$lines" -gt 1 ]] || fail "$file is empty"
  ok "$file ($lines lines)"
done

echo "--- Docker (optional) ---"
if command -v docker >/dev/null 2>&1 && docker compose ps >/dev/null 2>&1; then
  if docker compose ps --status running 2>/dev/null | grep -q chat-agent; then
    ok "chat-agent container running"
  else
    echo "[WARN] chat-agent not running — start: docker compose up -d --build"
  fi
fi

echo "--- HTTP Streamlit ---"
code=$(curl -s -o /dev/null -w "%{http_code}" "$BASE/" || true)
if [[ "$code" == "200" ]]; then
  ok "Streamlit HTTP $code at $BASE/"
else
  fail "Streamlit not reachable at $BASE/ (got HTTP ${code:-none})"
fi

echo "--- Generator sanity ---"
# 10 products is too small: support generator samples by category and can hit empty slices.
rm -rf data-test
python3 scripts/data/generate_ecommerce_data.py \
  --products 80 --customers 40 --orders 60 --conversations 15 --output data-test
[[ -f data-test/products.csv ]] || fail "generator did not create data-test/products.csv"
ok "generator wrote data-test/products.csv"

echo "=== All checks passed ==="
