locals {
  replica_group_by           = join(", ", var.replica_group_by)
  available_replica_group_by = join(", ", var.available_replica_group_by)
}