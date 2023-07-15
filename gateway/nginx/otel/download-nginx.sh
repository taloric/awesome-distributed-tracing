get_workflow_id() {
curl -s https://api.github.com/repos/$1/actions/workflows | jq '.workflows | .[] | select (.name == "nginx instrumentation CI") | .id'
}

get_lastesrun_id() {
curl -s "https://api.github.com/repos/$1/actions/workflows/$2/runs?branch=main&status=success&per_page=1&page=1" | jq '.workflow_runs | .[] .id'
}

get_artifacts_list() {
    curl -s https://api.github.com/repos/$1/actions/runs/$2/artifacts | jq -r '.artifacts | .[] .name '
}

get_nightly_download() {
    wget -q https://nightly.link/$1/workflows/nginx/main/$2.zip -O $2
}

REPO_NAME='open-telemetry/opentelemetry-cpp-contrib'
WORKFLOW_ID="$(get_workflow_id $REPO_NAME)"
RUN_ID="$(get_lastesrun_id $REPO_NAME $WORKFLOW_ID)"
ARTIFACTS_LIST="$(get_artifacts_list $REPO_NAME $RUN_ID)"

for art in $ARTIFACTS_LIST
do
echo $art
get_nightly_download $REPO_NAME $art
unzip $art
mv otel_ngx_module.so $art
done

# 2022.5.27: There are no Official Release Version for nginx compile with Opentelemetry now. So we use `github actions api` to get the latest `.so` file and add it as a nginx module.
