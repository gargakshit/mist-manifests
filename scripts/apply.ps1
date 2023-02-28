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
  helm upgrade -i --values charts/gitea/values.yaml gitea gitea-charts/gitea

  kubectl apply -f manifests/gitea-ingress.yaml
}

function install_kabootar() {
  echo "Installing kabootar"

  echo "Rendering secret/kabootar-toml from 1password"
  op inject -i manifests/kabootar-toml.yaml | kubectl apply -f -

  echo "Rendering deployment/kabootar from 1password"
  op inject -i manifests/kabootar.yaml | kubectl apply -f -

  echo "Rendering service/kabootar from 1password"
  op inject -i manifests/kabootar-service.yaml | kubectl apply -f -

  echo "Rendering ingress/kabootar from 1password"
  op inject -i manifests/kabootar-ingress.yaml | kubectl apply -f -
}

function install() {
  install_gitea
  install_kabootar
}

add_charts
apply_config_manifests
install
