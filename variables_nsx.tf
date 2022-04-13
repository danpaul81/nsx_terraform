
variable "instance_count" {
	description = "instance number / NAT IP"
	type = map
	default = {
		1	= "10.0.10.11"
    		2	= "10.0.10.12"
		3	= "10.0.10.13"
		4	= "10.0.10.14"
	}
}

data "nsxt_policy_service" "ssh_service" {
  display_name = "SSH"
}

data "nsxt_policy_service" "rdp_service" {
  display_name = "RDP"
}

data "nsxt_policy_service" "smb_tcp_137" {
  display_name = "NetBios Name Service (TCP)"
}

data "nsxt_policy_service" "smb_tcp_138" {
  display_name = "NetBios Datagram (TCP)"
}

data "nsxt_policy_service" "smb_tcp_139" {
  display_name = "NetBios Session Service (TCP)"
}

data "nsxt_policy_service" "smb_tcp_445" {
  display_name = "SMB"
}


variable "host-mvp" {
  type = string
  default = "10.20.60.10"
}

variable "CIP" {
  type = string
  default = "172.16.250.10"
}

variable "nat_fw_match" {
  type = string
  default = "MATCH_EXTERNAL_ADDRESS"
}
