locals {
  name = "${var.client}${var.region_short}"

  common_tags = {
    region = var.region_short
    
  }  
}