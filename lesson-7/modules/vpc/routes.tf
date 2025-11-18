resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.vpc_name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  for_each = { for k, v in aws_subnet.public : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}