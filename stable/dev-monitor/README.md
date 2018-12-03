# Caasp-dev-Monitor
CaaSP-dev-monitor provides a Helm chart for deploying Prometheus, Grafana, and Caasp Dashboards.  
It deploys both of Prometheus and Grafana without persistVolumes and configures Caasp Dashboards (https://github.com/kubic-project/monitoring). Promemeus and Grafana's NodePorts are fixed relatively to 31313 and 31314.

#### 1. Create a new namespace for monitoring  
```kubectl create namespace monitoring```
#### 2. Add suse repo  
```helm repo add suse https://kubernetes-charts.suse.com```  
#### 3. Install CaaSP-dev-monitor  
```helm install  suse/caasp-dev-monitor --namespace monitoring --name monitor```  
#### 4. Check if Prometheus and Grafana are deployed well. It can take up to 10 min. 
```kubectl -n monitoring get po | grep prometheus```    
```kubectl -n monitoring get po | grep grafana```  
#### 5. you can try queries in Prometheus web: 10.17.2.0:31313 (optional).  
#### 6. Login to Grafana web: 10.17.2.0:31314  
   * Login to grafana web with admin/admin (default username/password), enter new password.   
#### 7. All the configured dashboards will be shown in Grafana  
