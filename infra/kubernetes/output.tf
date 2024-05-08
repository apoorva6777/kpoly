output "k8s-node-pool-id" {
  value = oci_containerengine_node_pool.export_pool1.id
}

output "k8s-cluster-id" {
  value = oci_containerengine_cluster.kj-test-cluster.id
}