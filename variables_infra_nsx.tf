variable "nsx_mgr" {
	description		= "NSX Manager"
	type			= string
	default			= "nsxapp-01a.corp.local"
}

variable "nsx_user" {
	description		= "NSX Manager User"
	type			= string
	default			= "admin"
}

variable "nsx_password" {
	description		= "NSX Manager User Password"
	type			= string
	default			= "VMware1!VMware1!"
}


data "nsxt_policy_transport_zone" "overlay_tz" {
	display_name = "nsx-overlay-transportzone"
}

data "nsxt_policy_tier0_gateway" "T0" {
  display_name = "T0-Default"
}

data "nsxt_policy_edge_cluster" "EdgeCluster" {
  display_name = "Edge-Cluster1"
}
