resource "terraform_data" "renamed" {
  input = "Lab 03"
}

moved {
  from = terraform_data.example
  to   = terraform_data.renamed
}