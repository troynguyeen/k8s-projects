## Upgrade Prometheus Adapter to use custom rules by Helm Chart

```console
helm upgrade -f prometheus-adapter/values-custom.yaml prometheus-adapter prometheus-community/prometheus-adapter -n monitoring
```