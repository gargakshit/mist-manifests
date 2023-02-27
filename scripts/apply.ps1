function add_charts() {
  echo "Adding repo gitea-charts to helm"
  helm repo add gitea-charts https://dl.gitea.io/charts/
}

function apply_config_manifests() {
  echo "Rendering secret/gitea-admin from 1password"
  op inject -i manifests/gitea-admin.yaml | kubectl apply -f -

  echo "Rendering helmchartconfig.helm.cattle.io/traefik from 1password"
  op inject -i manifests/traefik-config.yaml | kubectl apply -f -

  kubectl apply -f manifests/traefik-https.yaml
}

function install_gitea() {
  echo "Installing gitea"
  helm install --values charts/gitea/values.yaml gitea gitea-charts/gitea
}

function install() {
  install_gitea
}

function apply_ingress() {
  kubectl apply -f manifests/gitea-ingress.yaml
}

add_charts
apply_config_manifests
install
apply_ingress
