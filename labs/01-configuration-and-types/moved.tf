moved {
  from = aws_subnet.lab_a
  to   = aws_subnet.lab["a"]
}

moved {
  from = aws_subnet.lab_b
  to   = aws_subnet.lab["b"]
}

moved {
  from = aws_route_table_association.lab_a
  to   = aws_route_table_association.lab["a"]
}

moved {
  from = aws_route_table_association.lab_b
  to   = aws_route_table_association.lab["b"]
}
