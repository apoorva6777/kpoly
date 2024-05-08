#  Overview

## Pre-requisite

#### Dynamic Group Creation
   - Ensure you have created a dynamic group in your compartment with the name `autoscaler-dynamic-group` and policy statement `ALL {instance.compartment.id = '<compartment-ocid>'}`. This dynamic group is required for enabling the cluster autoscaler as a standalone program.

#### Update Image Namespace in Deployment Files

   - Modify the namespace values for images in the deployment files, specifically in deployment-ping and deployment-status, to align with your unique namespace. Currently, the namespace placeholder 'idmaquoys' is used. Refer to the provided link in the reference section to obtain your namespace information.

#### Update Variables in deploy.sh

   - In the deploy.sh script, ensure to update the variables $storagenamespace, $emailid, and $password with your specific values. Currently, these placeholders are assigned empty strings. Replace them with your actual credentials for Docker login. You can obtain your storage namespace information by referring to the provided link in the reference section.

## Project Execution

To deploy the resources, execute the deploy.sh script in the deploy folder:

```bash
bash deploy/deploy.sh
``````

To destroy the deployed resources, execute the destroy.sh script in the deploy folder:

```bash
bash deploy/destroy.sh
``````

## Project Folder Structure

| Folder   | Description                                          |
|----------|------------------------------------------------------|
| deploy   | Contains deployment scripts for deploying and destroying resources. |
| infra    | Contains Terraform scripts for infrastructure provisioning.         |
| scripts  | Contains YAML scripts for various Kubernetes deployments.            |
| springapp  | Contains the SpringBoot application code and Dockerfile.                   |


## Outputs

| Name | Description |
| ------ | ------ |
| Load Balancer Public IP and paths specified for /ping ms | Public IP of Load Balancer |
| Load Balancer Public IP and paths specified for /status ms | Public IP of Load Balancer |

## Resources Created 

Following resources will be created:
- oci_core_vcn
- oci_core_subnet
- oci_core_default_dhcp_options
- oci_core_route_table
- oci_core_default_route_table
- oci_core_service_gateway
- oci_core_nat_gateway
- oci_core_internet_gateway
- oci_core_security_list
- oci_core_default_security_list
- oci_containerengine_cluster
- oci_containerengine_node_pool
- oci_artifacts_container_repository

## Kubernetes Configuration

The Kubernetes cluster is configured as follows:

- The Kubernetes cluster is configured to run version __1.27.2__. Although the latest version is 1.28, the autoscaler integration requires 1.27.2.
- The cluster type is BASIC_CLUSTER.
- The initial node pool is configured with __2__ nodes.
- There is a lifecycle block to ignore changes to node_config_details.size because autoscaler will manage the size. Without this, Terraform would overwrite any auto scaling changes.
```hcl
lifecycle {
  ignore_changes = [
    node_config_details[0].size
  ]
}
```
## Manifest Files Overview

| S.No | Name                          | Purpose                                                                                                  |
|------|-------------------------------|----------------------------------------------------------------------------------------------------------|
| 1    | deployment-ping.yaml               | Deploys the SpringBoot application with necessary configuration like image, replicas, resource limits, etc. for endpoint '/ping'  |
| 2    | deployment-status.yaml               | Deploys the SpringBoot application with necessary configuration like image, replicas, resource limits, etc. for endpoint '/status'  |
| 3    | service-ping.yaml                  | Creates a ClusterIP type Kubernetes service to expose the SpringBoot deployment-ping                             |
| 4    | service-status.yaml                  | Creates a ClusterIP type Kubernetes service to expose the SpringBoot deployment-status                             |
| 5    | ingress-ping.yaml                  | Creates an ingress resource using Nginx ingress controller ('nginx') to route traffic to the SpringBoot ping service         |
| 6    | ingress-status.yaml                  | Creates an ingress resource using Nginx ingress controller ('nginx2') to route traffic to the SpringBoot status service         |
| 7    | nginx1.yaml | Deploys the Nginx ingress controller named 'nginx' on a Kubernetes cluster. Creates necessary resources for full functionality |
| 8    | nginx2.yaml | Deploys the Nginx ingress controller named 'nginx2' on a Kubernetes cluster. Creates necessary resources for full functionality |
| 9    | autoscaler.yaml               | Deploys the Cluster Autoscaler on an OCI Kubernetes cluster. Creates necessary resources for autoscaling  |
| 10    | metric-server.yaml            | Installs the metrics-server on a Kubernetes cluster to provide resource usage metrics APIs                 |
| 11   | horizontal-pod-autoscaler-ping.yaml| Creates HorizontalPodAutoscaler resource to automatically scale '/ping' SpringBoot Deployments based on CPU utilization metrics |
| 12    | horizontal-pod-autoscaler-status.yaml| Creates HorizontalPodAutoscaler resource to automatically scale '/status' SpringBoot Deployments based on CPU utilization metrics |
| 13   | horizontal-pod-autoscaler-nginx.yaml       | Creates HorizontalPodAutoscaler resource to automatically scale nginx-ingress-controller deployment for 'nginx' ingress controller based on CPU utilization metrics              |
| 14   | horizontal-pod-autoscaler-nginx2.yaml       | Creates HorizontalPodAutoscaler resource to automatically scale nginx-ingress-controller deployment for 'nginx2' ingress controller based on CPU utilization metrics              |
| 15   | namespace-ping.yaml.yaml        | Creates namespace named 'app2'               |
| 16   | namespace-status.yaml.yaml        | Creates namespace named 'app1'               |

## Manifest for SpringBoot App

## deployment-ping.yaml

This YAML configuration defines a Kubernetes Deployment named `spring-app` for a SpringBoot application with the following settings:

- **Replicas:** Configures the deployment with 2 replicas of the SpringBoot Docker image.
- **Readiness Probe:** The probe performs an HTTP GET request on the path `/ping` at port 8080.
- **Resource Limits and Requests:** Specifies resource limits and requests for each pod:
  - **CPU:** Limits and requests are both set to "256m" Core.
  - **Memory:** Limits and requests are both set to "512Mi".

## deployment-status.yaml

This YAML configuration defines a Kubernetes Deployment named `spring-app-two` for a SpringBoot application with the following settings:

- **Replicas:** Configures the deployment with 2 replicas of the SpringBoot Docker image.
- **Readiness Probe:** The probe performs an HTTP GET request on the path `/status` at port 8081.
- **Resource Limits and Requests:** Specifies resource limits and requests for each pod:
  - **CPU:** Limits and requests are both set to "256m" Core.
  - **Memory:** Limits and requests are both set to "512Mi".

## service-ping.yaml

This YAML configuration defines a Kubernetes Service named `spring-app-svc` for the SpringBoot application with the following configs:

- **Service Type:** Configures the service as a ClusterIP type, allowing internal communication within the cluster.
- **Selectors:** Associates the service with pods labeled with `app: app`.
- **Ports Configuration:**
  - **Port:** Exposes port 80 on the service.
  - **TargetPort:** Routes traffic to port 3000 on the pods labeled with `app: app`.

## service-status.yaml

This YAML configuration defines a Kubernetes Service named `spring-app-two-svc` for the SpringBoot application with the following configs:

- **Service Type:** Configures the service as a ClusterIP type, allowing internal communication within the cluster.
- **Selectors:** Associates the service with pods labeled with `app: app-new`.
- **Ports Configuration:**
  - **Port:** Exposes port 80 on the service.
  - **TargetPort:** Routes traffic to port 3000 on the pods labeled with `app: app-new`.

## ingress-ping.yaml

This YAML configuration defines a Kubernetes Ingress named `spring-app-ing` for the SpringBoot application with the following configs:

- **Ingress Class:** Specifies the Ingress class as "nginx" using the annotation `kubernetes.io/ingress.class`.
- **TLS Configuration:** Enforces secure communication by specifying a TLS secret named `tls-secret`.
- **Rules Configuration:** Defines routing rules for incoming traffic.
  - **Path:** Routes requests with the path "/" to the SpringBoot service.
  - **Path Type:** Specifies the path type as "Prefix."
  - **Backend Configuration:** Directs traffic to the `spring-app-svc` service on port 80.

## ingress-status.yaml

This YAML configuration defines a Kubernetes Ingress named `spring-app-two-ing` for the SpringBoot application with the following configs:

- **Ingress Class:** Specifies the Ingress class as "nginx2" using the annotation `kubernetes.io/ingress.class`.
- **TLS Configuration:** Enforces secure communication by specifying a TLS secret named `tls-secret`.
- **Rules Configuration:** Defines routing rules for incoming traffic.
  - **Path:** Routes requests with the path "/" to the SpringBoot service.
  - **Path Type:** Specifies the path type as "Prefix."
  - **Backend Configuration:** Directs traffic to the `spring-app-two-svc` service on port 80.


## Points to Note
We are setting up two distinct NGINX controllers, namely 'nginx' and 'nginx2.' In addition, we will establish dedicated configurations such as ClusterRoleBinding, ValidatingWebhookConfiguration etc. for each controller. This ensures that both NGINX load balancers operate independently, avoiding any interference or impact on each other's functionality
## 1. nginx1.yaml

The content of this manifest is obtained from [official repository](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/cloud/deploy.yaml). As of January 2024, the version being used is 1.9.5.

### Modifications:

1. **External Traffic Policy Change:**
    - The `externalTrafficPolicy`, which is by default set to `Local`, is changed to `Cluster`. This modification allows node-to-node communication. Without this change, the Ingress Controller won't be able to access deployments on nodes other than the one where the Ingress Controller resides, marking other nodes as unreachable.
2. **Load Balancer Shape Annotations:**
    - Added the following annotations:
        ```yaml
        service.beta.kubernetes.io/oci-load-balancer-shape: "flexible"
        service.beta.kubernetes.io/oci-load-balancer-shape-flex-min: "10"
        service.beta.kubernetes.io/oci-load-balancer-shape-flex-max: "100"
        ```
        By default, Nginx creates a Load Balancer of type fixed with a maximum shape of 100 Mbps. However, Oracle will discontinue fixed-type load balancers from May 2024. To address this, the load balancer is made flexible, and these annotations include the minimum and maximum shape configurations.

## 2. nginx2.yaml

The content of this manifest is obtained from [official repository](https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/cloud/deploy.yaml). As of January 2024, the version being used is 1.9.5.

### Modifications:

1. **Changing Namespace Name:**
   - Created a new namespace, 'ingress-nginx-2,' to isolate resources, and all configurations are updated to use this new namespace.
   ```yaml
   kind: Namespace
    metadata:
    name: ingress-nginx-2
   ```

2. **Change ClusterRole Names:**
   - Modified both ClusterRole names to 'ingress-nginx-2' and 'ingress-nginx-admission-2' to establish separate ClusterRoles for enhanced resource isolation.
   ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
    name: ingress-nginx-2
   ```
   and
   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
    name: ingress-nginx-admission-2
   ```

3. **Change ClusterRoleBinding RoleRef:**
   - Replaced ClusterRoles in two ClusterRoleBindings with the new names 'ingress-nginx-2' and 'ingress-nginx-admission-2' to ensure proper association and update names for ClusterRoles
   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    name: `ingress-nginx-2``
    roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: `ingress-nginx-2`
   ```
   and
   ```yaml
   apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
    name: `ingress-nginx-admission-2``
    roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: `ingress-nginx-admission-2``
   ```

4. **Changes in Deployments:**
   - Updated the Deployment configuration spec->containers->args, changing the ingress-class name to 'nginx2' for clear identification.
   ```yaml
   apiVersion: apps/v1
    kind: Deployment
            - --ingress-class=``nginx2``
   ```

5. **Changes in Job Resource:**
   - Modified the webhook-name in the job resource to 'ingress-nginx-admission-2' to align with the updated configurations.
   ```yaml
   apiVersion: batch/v1
    kind: Job
        spec:
        containers:
        - args:
            - patch
            - --webhook-name=ingress-nginx-admission-2
            env:
   ```

6. **Ingress Class Name:**
   - Changed the IngressClass name to 'nginx2,' representing the new ingress controller for resource clarity.
   ```yaml
   apiVersion: networking.k8s.io/v1
    kind: IngressClass
    metadata:
    name: ``nginx2``
   ```

7. **Changes in ValidatingWebhookConfiguration Resource:**
   - Updated the name of ValidatingWebhookConfiguration to 'ingress-nginx-admission-2' to enforce resource isolation for enhanced security and management.
   ```yaml
   apiVersion: admissionregistration.k8s.io/v1
    kind: ValidatingWebhookConfiguration
    metadata:
    name: ``ingress-nginx-admission-2``
   ```

8. **External Traffic Policy Change:**
    - The `externalTrafficPolicy`, which is by default set to `Local`, is changed to `Cluster`. This modification allows node-to-node communication. Without this change, the Ingress Controller won't be able to access deployments on nodes other than the one where the Ingress Controller resides, marking other nodes as unreachable.

9. **Load Balancer Shape Annotations:**
    - Added the following annotations:
        ```yaml
        service.beta.kubernetes.io/oci-load-balancer-shape: "flexible"
        service.beta.kubernetes.io/oci-load-balancer-shape-flex-min: "10"
        service.beta.kubernetes.io/oci-load-balancer-shape-flex-max: "100"
        ```
        By default, Nginx creates a Load Balancer of type fixed with a maximum shape of 100 Mbps. However, Oracle will discontinue fixed-type load balancers from May 2024. To address this, the load balancer is made flexible, and these annotations include the minimum and maximum shape configurations.


## 3. autoscaler.yaml

1. **Dynamic Value for Node Pool ID:**
   - When the node pool is provisioned, the value for `<REPLACE_WITH_DYNAMIC_VALUE>` will be replaced with the OCID of the configured node pool.
   - Additionally, a new file `cluster-autoscaler.yaml` will be created with these changes and executed. The `autoscaler.yaml` serves as a placeholder file.

2. **Node Pool Capacity Configuration**
   - The current configuration sets the minimum and maximum capacity to 2 and 5, respectively, in the specified file.

3. **Autoscaler Image Source:**
    - The image for the autoscaler is pulled from the Oracle Cloud Infrastructure Registry (OCIR) of the region Ashburn (IAD).


## 4. metric-server.yaml

This YAML file is used to deploy the Kubernetes Metrics Server on a cluster using kubectl. The content is taken from [GitHub](https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.6.4/components.yaml), where version 0.6.4 is the latest as of Jan 2024.

## 5. deployment-ping.yaml and deployment-status.yaml

Configures a deployment with the following parameters:

- Request and limit parameters are set to `cpu:"256m"` and `memory:"512Mi"`.
- Each pod can request and get 256m Core and 512Mi of memory.

## 6. hpa-ping.yaml and hpa-status.yaml

These YAML manifests create HorizontalPodAutoscaler resources with the following configurations:

- Min and max replicas are set to 2 and 5, respectively.
- CPU Utilization to be checked by the metric server is set to 60.
- Memory Utilization to be checked by the metric server is set to 70.

## 7. hpa-nginx.yaml and hpa-nginx2.yaml

These YAML manifests create HorizontalPodAutoscaler resources for nginx-ingress-controller resource with the following configurations:

- Min and max replicas are set to 1 and 10, respectively.
- CPU Utilization to be checked by the metric server is set to 80.

## 8. TLS Secret

In this template, a TLS secret named 'tls-secret' has been created using OpenSSL. This secret has been  integrated into the ingress resources. Presently, the ingress is configured to serve on port 80. Adjustments can be made to both the ingress and services' ports to enable traffic on port 443 (https) as needed.

## 9. preemptible_node_config in Kubernetes OCI Container Engine Node Pool Resource

Within the Terraform resource configuration for `oci_containerengine_node_pool`, the `preemptible_node_config` block is currently commented out. This configuration option is responsible for creating nodes in the node pool that are of type preemptible, introducing a taint to the nodes, and making deployments uncertain on these nodes.

It's important to note that there is currently no requirement for preemptible nodes in our configurations. If this requirement changes in the future, please uncomment the relevant code block to enable the `preemptible_node_config`. This will allow the inclusion of preemptible nodes in the node pool as needed.

## 10. Dynamic Key_Details Block in Terraform Configuration for OCI Container Engine Cluster

Within the Terraform resource configuration for `oci_containerengine_cluster`, the `key_details` block has been designed to be dynamic. This flexibility is aligned with our current requirements, where there's no necessity for externally adding a Key Management Service (KMS) key.

When the `configure_key_details` variable is set to false, Oracle Cloud Infrastructure (OCI) will automatically manage a self-generated and self-rotated key for the Oracle Kubernetes Engine (OKE) cluster. This simplifies the process, eliminating the need for manual intervention.

In the event that requirements change and there is a need to configure a specific KMS key, the `configure_key_details` variable can be set to true. Subsequently, the necessary KMS key OCID (Oracle Cloud Identifier) can be provided to ensure proper configuration based on the updated requirements.


## 11. Configuring `oci_core_security_list` ICMP_Options, UDP_Options, and TCP_Options

In the Terraform resource configuration for `oci_core_security_list`, it is noteworthy that when configuring a security rule specifically for TCP options, the parameters `udp_options` and `icmp_options` are intentionally commented out. This is done in recognition of the absence of any current requirement for these options, and including them would result in invalid Terraform configurations.

Conversely, a similar approach is adopted when configuring rules for UDP options and ICMP options. In each case, only the relevant options are included to maintain clarity and compliance with the specific requirements. It is advised to review and uncomment the appropriate sections based on the specific needs of the security rules being defined.


# Reference Links:

## OCI CLI:
Official documentation for installing OCI CLI:
- [OCI CLI Installation Guide](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/cliinstall.htm)

## Cluster Autoscaler:
Learn how to work with the Cluster Autoscaler in Oracle Cloud Infrastructure:
- [Cluster Autoscaler Guide](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusingclusterautoscaler_topic-Working_with_the_Cluster_Autoscaler.htm)

## Horizontal Pod Autoscaler:
Explore the usage of the Horizontal Pod Autoscaler in Oracle Cloud Infrastructure:
- [Horizontal Pod Autoscaler Guide](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengusinghorizontalpodautoscaler.htm)

## Nginx Ingress Controller Setup:
Detailed instructions for setting up the Nginx Ingress Controller in Oracle Cloud Infrastructure:
- [Nginx Ingress Controller Setup Guide](https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengsettingupingresscontroller.htm)

## OCIR setup:
Learn how to log in to the OCIR registry using auth key credentials:
- [Logging In the OCIR docker registry](https://docs.oracle.com/en-us/iaas/Content/Functions/Tasks/functionslogintoocir.htm)

## OCIR namespace:
Learn how to get namespace for Object Storage:
- [Getting namespace of for OCIR](https://docs.oracle.com/en-us/iaas/Content/Object/Tasks/understandingnamespaces.htm)


