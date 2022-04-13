
#
# Custom Network Services Definitions (not pre-defined in NSX-T)
#

resource "nsxt_policy_service" "rdp_sandbox" {
  description 			= "HOST-MVP RDP Sandbox TCP 3310"
  display_name 			= "HOST-MVP RDP TCP 3310"
  l4_port_set_entry {
    display_name	= "TCP 3310"
    protocol 		= "TCP"
    destination_ports	= ["3310"]
  }
}

resource "nsxt_policy_service" "winrm" {
  description 			= "WINRM TCP 5985"
  display_name 			= "WINRM TCP 5985"
  l4_port_set_entry {
    display_name	= "TCP 5985"
    protocol 		= "TCP"
    destination_ports	= ["5985"]
  }
}

resource "nsxt_policy_service" "cip_portal_spark" {
  description                   = "cip portal spark TCP 8443"
  display_name                  = "TCP 8443"
  l4_port_set_entry {
    display_name        = "TCP 8443"
    protocol            = "TCP"
    destination_ports   = ["8443"]
  }
}


#
# DNAT RULES
#


# following two rules are for testing purpose, remove later
resource "nsxt_policy_nat_rule" "dnat_ssh_host" {
  for_each                      = var.instance_count
  display_name                  = "DNAT SSH Host-MVP"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.host-mvp]
  translated_ports              = "23"
  firewall_match		= var.nat_fw_match
  service                       = data.nsxt_policy_service.ssh_service.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_ssh_cip" {
  for_each                      = var.instance_count
  display_name                  = "DNAT SSH CIP"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.CIP]
  translated_ports              = "22"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.ssh_service.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}



resource "nsxt_policy_nat_rule" "dnat_rdp" {
  for_each			= var.instance_count
  display_name			= "DNAT RDP"
  action			= "DNAT"
  destination_networks		= ["${each.value}"]
  translated_networks		= [var.host-mvp]
  translated_ports		= "3389"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.rdp_service.path
  gateway_path	 		= nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_rdp_sandbox" {
  for_each			= var.instance_count
  display_name			= "DNAT HOST-MVP RDP"
  action			= "DNAT"
  destination_networks		= ["${each.value}"]
  translated_networks		= [var.host-mvp]
  translated_ports		= "3310"
  firewall_match                = var.nat_fw_match
  service                       = nsxt_policy_service.rdp_sandbox.path
  gateway_path	 		= nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_winrm" {
  for_each			= var.instance_count
  display_name			= "DNAT WINRM CIP"
  action			= "DNAT"
  destination_networks		= ["${each.value}"]
  translated_networks		= [var.CIP]
  translated_ports		= "5985"
  firewall_match                = var.nat_fw_match
  service                       = nsxt_policy_service.winrm.path
  gateway_path	 		= nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_smb_tcp_137" {
  for_each                      = var.instance_count
  display_name                  = "DNAT TCP 137 HOST-MVP SMB"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.host-mvp]
  translated_ports		= "137"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.smb_tcp_137.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_smb_tcp_138" {
  for_each                      = var.instance_count
  display_name                  = "DNAT TCP 138 HOST-MVP SMB"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.host-mvp]
  translated_ports              = "138"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.smb_tcp_138.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_smb_tcp_139" {
  for_each                      = var.instance_count
  display_name                  = "DNAT TCP 139 HOST-MVP SMB"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.host-mvp]
  translated_ports              = "139"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.smb_tcp_139.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_smb_tcp_445" {
  for_each                      = var.instance_count
  display_name                  = "DNAT TCP 445 HOST-MVP SMB"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.host-mvp]
  translated_ports              = "445"
  firewall_match                = var.nat_fw_match
  service                       = data.nsxt_policy_service.smb_tcp_445.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

resource "nsxt_policy_nat_rule" "dnat_cip_portal_spark_tcp_8443" {
  for_each                      = var.instance_count
  display_name                  = "DNAT TCP 8443 CIP Portal Spark"
  action                        = "DNAT"
  destination_networks          = ["${each.value}"]
  translated_networks           = [var.CIP]
  translated_ports              = "8443"
  firewall_match                = var.nat_fw_match
  service                       = nsxt_policy_service.cip_portal_spark.path
  gateway_path                  = nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}





#
# Firewall Policy & Rules
#

resource "nsxt_policy_gateway_policy" "t1pol" {
  for_each	= var.instance_count
  display_name	= "FW_POLICY_DEVELOPMENT"
  description	= "Terraform genereated Policy"
  category	= "LocalGatewayRules"
  locked	= false
  stateful	= true
  tcp_strict	= false
  
  rule {
    #useless rule as default policy is allow. for testing only
    display_name	= "SSH"
    source_groups 	= []
 #   destination_groups 	= [ nsxt_policy_group.sg_automation[each.key].path ]
    destination_groups	= [ "${each.value}" ] 
    services		= [data.nsxt_policy_service.ssh_service.path]
    action 		= "ALLOW"
    scope		= [nsxt_policy_tier1_gateway.tier1_gw[each.key].path]
  }

  rule {
    display_name	= "DefaultAllow"
    source_groups	= [] 
    destination_groups	= []
    action		= "ALLOW"
    scope               = [nsxt_policy_tier1_gateway.tier1_gw[each.key].path]
  }

}






