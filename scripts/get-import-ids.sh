#!/bin/bash
# Script to retrieve AWS network resource IDs for Terraform import

set -e

# VPC ID - Update this with your actual VPC ID
VPC_ID="vpc-0ee0d1b8a2c83120e"

echo "=== VPC ==="
aws ec2 describe-vpcs --vpc-ids $VPC_ID \
  --query 'Vpcs[0].[VpcId,CidrBlock,Tags[?Key==`Name`].Value|[0]]' \
  --output table

echo ""
echo "=== Subnets ==="
aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'Subnets[].[Tags[?Key==`Name`].Value|[0],SubnetId,CidrBlock,AvailabilityZone]' \
  --output table

echo ""
echo "=== Internet Gateway ==="
aws ec2 describe-internet-gateways \
  --filters "Name=attachment.vpc-id,Values=$VPC_ID" \
  --query 'InternetGateways[].[InternetGatewayId,Tags[?Key==`Name`].Value|[0]]' \
  --output table

echo ""
echo "=== NAT Gateways ==="
aws ec2 describe-nat-gateways --filter "Name=vpc-id,Values=$VPC_ID" \
  --query 'NatGateways[].[NatGatewayId,SubnetId,PublicIp,Tags[?Key==`Name`].Value|[0]]' \
  --output table

echo ""
echo "=== Elastic IPs (for NAT) ==="
aws ec2 describe-addresses \
  --query 'Addresses[].[AllocationId,PublicIp,Tags[?Key==`Name`].Value|[0]]' \
  --output table

echo ""
echo "=== Route Tables ==="
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[].[RouteTableId,Tags[?Key==`Name`].Value|[0],Associations[].SubnetId]' \
  --output table
