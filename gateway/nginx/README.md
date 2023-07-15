## how to use it 

### nginx with otel

1. use otel/download-nginx.sh to download the latest version of `otel_ngx_module.so`.
2. use otel/otel-nginx.toml to configure otel target service.
3. use otel/nginx.conf as nginx sample config (configure your own backends and services).
4. optionally, you can simply add those configs below to `nginx.conf` (alos it's the main difference in `otel/nginx.conf`)

```nginx
# add otel module at the beginning
load_module /usr/local/openresty/nginx/modules/otel_ngx_module.so;

# add this at http block/server block
# add otel module
opentelemetry_config /usr/local/openresty/nginx/conf/otel_nginx.toml;
opentelemetry_attribute "env" "production";
opentelemetry_operation_name $request_uri;
opentelemetry_propagate;
opentelemetry_capture_headers on;
```

5. build images, noticed that there are some specific file path in `Dockerfile`

```bash
docker build --build-args OTEL_VERSION=debian-10.11-mainline -f otel/Dockerfile.otel -t $IMAGE_NAME .
```

- any extra configs can be found in [otel-README](https://github.com/open-telemetry/opentelemetry-cpp-contrib/blob/main/instrumentation/nginx/README.md)

### nginx with datadog

1. use datadog/dd-trace.json as datadog backend service config.
2. use my-service.conf as nginx sample config (configure your own backends and services).
3. add those `COPY` below into `your-own-frontend-service` Dockerfile.

```Dockerfile
COPY ${your_datadog_config_json_file} /etc/nginx/trace/dd-trace.json
COPY ${your_nginx_conf} /etc/nginx/conf.d/${your_nginx.conf}.conf
```

4. build images

```bash
docker build -t datadog/Dockerfile.datadog -t $IMAGE_NAME .
```
