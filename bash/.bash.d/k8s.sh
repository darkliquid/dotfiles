#!/bin/bash

if command -v kubectl &> /dev/null; then
  source <(kubectl completion bash)
fi

if command -v kubecolor &>/dev/null; then
  alias kubectl="kubecolor"
  complete -o default -F __start_kubectl kubecolor
fi

kr() {
    kubectl --field-manager=flux-client-side-apply rollout restart $@
}
