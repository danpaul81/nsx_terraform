terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}


provider "nsxt" {
  host			= var.nsx_mgr
  username 		= var.nsx_user
  password 		= var.nsx_password
  allow_unverified_ssl 	= true
  max_retries           = 10
  retry_min_delay       = 500
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}

#
# Network Infrastructure
#

resource "nsxt_policy_tier1_gateway" "tier1_gw" {
  for_each 			= var.instance_count
  description			= "T1_INSYS_${each.key}"
  display_name			= "T1_INSYS_${each.key}"
  tier0_path    		= data.nsxt_policy_tier0_gateway.T0.path
  enable_firewall 		= "true"
  edge_cluster_path		= data.nsxt_policy_edge_cluster.EdgeCluster.path
  route_advertisement_types 	= ["TIER1_NAT"]
}

#
# SNAT RULES
#

resource "nsxt_policy_nat_rule" "snat_automationnet" {
  for_each			= var.instance_count
  display_name			= "SNAT_AUTOMATIONNET"
  action			= "SNAT"
  translated_networks		= ["${each.value}"]
  source_networks		= ["172.16.250.0/24"]
  firewall_match		= "MATCH_INTERNAL_ADDRESS"
  gateway_path			= nsxt_policy_tier1_gateway.tier1_gw[each.key].path
}

#
# Network Segements
#

resource "nsxt_policy_segment" "seg_automation" {
  for_each              = var.instance_count
  display_name          = "INSYS_${each.key}_AutomationNet"
  description           = "INSYS_${each.key}_AutomationNet"
  transport_zone_path   = data.nsxt_policy_transport_zone.overlay_tz.path
  connectivity_path     = nsxt_policy_tier1_gateway.tier1_gw[each.key].path

  subnet {
    cidr        = "172.16.250.254/24"
  }

  tag {
    scope 	= "networkid"
    tag		= "automation"
  }
  
  tag {
    scope 	= "instanceid"
    tag		= each.key
 }
}

resource "nsxt_policy_segment" "seg_field" {
  for_each              = var.instance_count
  display_name          = "INSYS_${each.key}_FieldNet"
  description           = "INSYS_${each.key}_FieldNet"
  transport_zone_path   = data.nsxt_policy_transport_zone.overlay_tz.path
  connectivity_path     = nsxt_policy_tier1_gateway.tier1_gw[each.key].path

  subnet {
    cidr        = "10.20.60.254/24"
  }
 
 
    tag {  
      scope	= "networkid"
      tag	= "field"
    }
    tag {	
      scope 	= "instanceid"
      tag	= each.key
    }
  
}


#
# Security Groups
#


resource "nsxt_policy_group" "sg_automation" {
  for_each		= var.instance_count
  display_name		= "SG_automation_${each.key}"
  description		= "SG_automation_${each.key}"

  criteria {
    condition {
      key		= "Tag" 
      member_type	= "Segment"
      operator 		= "EQUALS"
      value 		= "networkid|automation"
    }
  }
  conjunction {
    operator 		= "AND"
  } 
  criteria {
    condition {
      key		= "Tag"
      member_type  	= "Segment"
      operator   	= "EQUALS"
      value		= "instanceid|${each.key}"
    }
  }
}


resource "nsxt_policy_group" "sg_field" {
  for_each              = var.instance_count
  display_name          = "SG_field_${each.key}"
  description           = "SG_field_${each.key}"

  criteria {
    condition {
      key               = "Tag"
      member_type       = "Segment"
      operator          = "EQUALS"
      value             = "networkid|field"
    }
  }
  conjunction {
    operator            = "AND"
  }
  criteria {
    condition {
      key               = "Tag"
      member_type       = "Segment"
      operator          = "EQUALS"
      value             = "instanceid|${each.key}"
    }
  }
}
