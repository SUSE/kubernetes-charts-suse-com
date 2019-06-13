#!/usr/bin/env bats

load test_helper

setup() {
  if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
    echo '# Install rsyslog server'
    pushd $BATS_TEST_DIRNAME/helpers/rsyslog-server
    kubectl create --filename="rsyslog-server-configmap.yaml","rsyslog-server-secret.yaml","rsyslog-server-deployment.yaml","rsyslog-server-service.yaml" 
    popd

    echo '# Install rsyslog logging agent'
    pushd $BATS_TEST_DIRNAME/..
    helm install . \
        --set server.protocol=tcp \
        --set logs.osSystem.enabled=false \
        --set logs.kubernetesSystem.enabled=false \
        --set logs.kubernetesControlPlane.enabled=true \
        --set logs.kubernetesUserNamespaces.enabled=false \
        --wait
    popd
  fi
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/kube-apiserver" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/kube-apiserver' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/kube-controller-manager" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/kube-controller-manager' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/kube-scheduler" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/kube-scheduler' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/kube-proxy" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/kube-proxy' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/etcd" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/etcd' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/cilium-operator" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/cilium-operator' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/cilium-agent" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
	do
    	kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/cilium-agent' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s control plane log - k8s.pod/kube-system/.*/coredns" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q 'k8s\.pod\/kube-system\/.*\/coredns' /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

teardown() {
  if [[ "${#BATS_TEST_NAMES[@]}" -eq "$BATS_TEST_NUMBER" ]]; then
    echo '# Delete rsyslog logging agent'
    local releaseName=`helm list | grep log-agent-rsyslog | awk '{print $1}'`
    helm delete --purge $releaseName

    echo '# Delete rsyslog server'
    kubectl delete --namespace=default service rsyslog-server
    kubectl delete --namespace=default deployment rsyslog-server
    kubectl delete --namespace=default secret rsyslog-server
    kubectl delete --namespace=default configmap rsyslog-server
  fi
}
