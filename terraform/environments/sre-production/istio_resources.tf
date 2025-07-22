# Istio Gateway 배포
resource "kubernetes_manifest" "istio_gateway_my_app" {
  manifest = yamldecode(file("../../kubernetes-addons/istio/istio-gateway.yaml"))
  depends_on = [
    module.eks # EKS 클러스터가 완전히 배포된 후에 적용
  ]
}

# Istio DestinationRule 배포
resource "kubernetes_manifest" "istio_destination_rule_my_app" {
  manifest = yamldecode(file("../../kubernetes-addons/istio/istio-destinationrule.yaml"))
  depends_on = [
    kubernetes_manifest.istio_gateway_my_app # Gateway 이후에 규칙 적용
  ]
}

# Istio VirtualService 배포 (카나리 예시)
resource "kubernetes_manifest" "istio_virtual_service_canary_my_app" {
  manifest = yamldecode(file("../../kubernetes-addons/istio/istio-virtualservice-canary.yaml"))
  depends_on = [
    kubernetes_manifest.istio_destination_rule_my_app # DestinationRule 이후에 가상 서비스 적용
  ]
}
