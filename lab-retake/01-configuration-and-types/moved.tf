moved {
  from = terraform_data.gateway
  to   = terraform_data.component["gateway"]
}

moved {
  from = terraform_data.component["scheduler"]
  to   = terraform_data.component["dispatcher"]
}
