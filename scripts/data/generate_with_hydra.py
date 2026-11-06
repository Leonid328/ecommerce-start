"""Generate the e-commerce dataset with Hydra overrides."""

import sys
from pathlib import Path

import hydra
from omegaconf import DictConfig

sys.path.insert(0, str(Path(__file__).resolve().parent))
from generate_ecommerce_data import generate_all_data


@hydra.main(version_base=None, config_path="../../conf", config_name="data")
def main(cfg: DictConfig) -> None:
    generate_all_data(
        n_products=int(cfg.products),
        n_customers=int(cfg.customers),
        n_orders=int(cfg.orders),
        n_conversations=int(cfg.conversations),
        output_dir=str(cfg.output),
    )


if __name__ == "__main__":
    main()
