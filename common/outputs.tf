output "public_instances" {
  value = module.cluster_config.*.public_instances
}

output "public_ip" {
  value = var.config_mgmt == "puppet" ? [for key, values in module.cluster_config.0.public_instances: values["public_ip"] if values["public_ip"] != ""] : []
}

output "cluster_name" {
  value = lower(var.cluster_name)
}

output "domain" {
  value = lower(var.domain)
}

output "accounts" {
  value = var.config_mgmt == "puppet" ? {
    guests = {
      usernames =   var.nb_users != 0 ? (
        "user[${format(format("%%0%dd", length(tostring(var.nb_users))), 1)}-${var.nb_users}]"
      ) : (
        "You have chosen to create user accounts yourself (`nb_users = 0`), please read the documentation on how to manage this at https://github.com/ComputeCanada/magic_castle/blob/main/docs/README.md#103-add-a-user-account"
      ),
      password = module.cluster_config.0.guest_passwd
    }
    freeipa_admin = {
      username = "admin"
      password = module.cluster_config.0.freeipa_passwd
    }
    sudoer = {
      username = var.sudoer_username
      password = "N/A (public ssh-key auth)"
    }
  } : {}
}

output "ssh_private_key" {
  value     = var.config_mgmt == "puppet" ? module.instance_config.0.private_key : ""
  sensitive = true
}