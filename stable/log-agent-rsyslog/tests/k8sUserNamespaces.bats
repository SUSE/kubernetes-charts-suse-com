#!/usr/bin/env bats

load test_helper

setup() {
  if [[ "$BATS_TEST_NUMBER" -eq 1 ]]; then
    echo '# Install chatter pod to namespace test-ns1'
    echo '# Install chatter pod to namespace test-ns2'
    pushd $BATS_TEST_DIRNAME/helpers/chatter
    kubectl create namespace test-ns1
    kubectl create namespace test-ns2
    kubectl create -f chatter-pod.yaml --namespace=test-ns1
    kubectl create -f chatter-pod.yaml --namespace=test-ns2
    popd

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
        --set logs.kubernetesControlPlane.enabled=false \
        --set logs.kubernetesUserNamespaces.enabled=true \
        --wait
    popd
  fi
}

@test "Test k8s user namespaces log - k8s.pod/test-ns1/chatter/chatter" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q -F "k8s.pod/test-ns1/chatter/chatter" /var/log/messages-tcp-rfc5424 && break
        count=$[$count+1]
        sleep $sleep
    done

    [[ $count -lt $maxRetry ]]
}

@test "Test k8s user namespaces log - k8s.pod/test-ns2/chatter/chatter" {
    local podName=`kubectl get pods --namespace=default -lapp=rsyslog-server -o jsonpath='{.items[0].metadata.name}'`
    local count=0

    until [[ $count -ge $maxRetry ]]
    do
        kubectl exec -it $podName --namespace=default -- grep -q -F "k8s.pod/test-ns2/chatter/chatter" /var/log/messages-tcp-rfc5424 && break
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

    echo '# Delete chatter pod from namespace test-ns1'
    echo '# Delete chatter pod from namespace test-ns2'
    kubectl delete --namespace=default pod chatter --namespace=test-ns1
    kubectl delete --namespace=default pod chatter --namespace=test-ns2
    kubectl delete --namespace=default namespace test-ns1
    kubectl delete --namespace=default namespace test-ns2
  fi
}
