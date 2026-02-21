#!/bin/bash
# Batch import script for network resources
# Run from: environments/dev/us-east-1/00-network/

set -e

echo "Starting network import..."
echo ""

# Subnets
echo "==> Importing subnets..."
terraform import aws_subnet.private_1a subnet-0fac8d4d2fc72e201
terraform import aws_subnet.private_1b subnet-02b0d9a848b011401
terraform import aws_subnet.public_1a subnet-0c99cfa7162ce31ab
terraform import aws_subnet.public_1b subnet-0b1d5bc999554e07d

# Internet Gateway
echo ""
echo "==> Importing Internet Gateway..."
terraform import aws_internet_gateway.existing igw-0424ecaae2465df9b

# Elastic IP
echo ""
echo "==> Importing Elastic IP..."
terraform import aws_eip.nat eipalloc-0e22c26798c47893a

# NAT Gateway
echo ""
echo "==> Importing NAT Gateway..."
terraform import aws_nat_gateway.existing nat-12aa817a4d50f437d

echo ""
echo "✅ Import complete! Run 'terraform plan' to check for additional resources."
