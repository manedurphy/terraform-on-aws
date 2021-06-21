output "elb-info" {
  value = {
    id       = module.elb.elb_id
    name     = module.elb.elb_name
    dns_name = module.elb.elb_dns_name
  }
}
