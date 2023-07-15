## how to use it 

### openresty with otel

1. due to such issues, we need to compile `openresty` and `otel_module` by ourselves. (2022/5/17)
  1. openresty images which base on `debian` and `ubuntu` doesn't contains `--withcompat/--with-pcre/--with-pcre-jit` parameters.
  2. openresty running with `otel_ngx_module.so` instrument in [otel_official_module](github.com/open-telemetry/opentelemetry-cpp-contrib) get a runtime error: `undefined symbol: ngx_regex_exec`.

#### usage

1. use `otel/download-nginx.sh` to download the latest version of `otel_ngx_module.so`.
2. use `otel/otel-nginx.toml` to configure otel target service.
3. use `otel/nginx.conf` as nginx sample config (configure your own backends and services).
4. optionally, you can simply add those config below in `nginx.conf`.

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

5. build images under [Makefile](./Makefile): `make bulid`.
  1. `Dockerfile.phrase1`: build an `openresty` base image with `--withcompat/--with-pcre/--with-pcre-jit` parameters.
  2. `Dockerfile.phrase2`: install `otel_ngx_module.so` with `gprc/open-telemetry-cpp/open-telemetry-cpp-contrib` inside the `phrase1` image. Then add `your own frontend service` into images (e.g.: `COPY ./dist /var/www/public/`).
  3. optionally, you can detach `COPY ./dist ...` from `Dockerfile.phrase2`, and use `Dockerfile.phrase2` image as a base image for all frontend service.
