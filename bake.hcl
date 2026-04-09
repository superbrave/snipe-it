variable "REGISTRY" {
  default = "ghcr.io/superbrave/snipe-it"
}

variable "TAG" {}
variable "HOME" {}
variable "COMPOSER_AUTH_JSON" {}
variable "COMPOSER_INSTALL_ARGS" {}

group "default" {
  targets = ["production"]
}

target "production" {
  dockerfile = "Dockerfile"
  platforms = ["linux/arm64"]
  tags = ["${REGISTRY}:${TAG}"]
  args = {
    PHP_VERSION = "8.4"
  }
}