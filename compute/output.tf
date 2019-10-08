output "k8s_controller_instances" {
  value = "${aws_instance.k8s_controllers.*.id}"
}
output "k8s_worker_instances" {
  value = "${aws_instance.k8s_workers.*.id}"
}
