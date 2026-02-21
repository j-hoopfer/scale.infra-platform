#!/bin/bash
# Batch import script for network resources
# Usage: 
#   From the network directory: ../../../../scripts/import-network.sh
#   Or: bash scripts/import-network.sh (depending on where you run it from)
#   Ensure you are in the directory containing the terraform files (environments/dev/us-east-1/00-network/)

# Build list of IDs to import - UPDATE THESE BEFORE RUNNING
VPC_ID="vpc-0ee0d1b8a2c83120e"

# Subnets
SUBNET_PUB_1A="subnet-0c99cfa7162ce31ab"
SUBNET_PUB_1B="subnet-0b1d5bc999554e07d"
SUBNET_PRIV_1A="subnet-0fac8d4d2fc72e201"
SUBNET_PRIV_1B="subnet-02b0d9a848b011401"

# Internet Gateway
IGW_ID="igw-0424ecaae2465df9b"

# NAT Gateways & EIPs (assuming 2 for HA based on vpc.tf)
# If you only have 1 in reality, you may need to adjust vpc.tf or comment out the second import
NAT_GW_1A_ID="nat-12aa817a4d50f437d"
NAT_GW_1B_ID="nat-placeholder-id-1b" # UPDATE ME
EIP_1A_ID="eipalloc-0e22c26798c47893a"
EIP_1B_ID="eipalloc-placeholder-id-1b" # UPDATE ME

# Route Tables
RT_PUBLIC="rtb-placeholder-public" # UPDATE ME
RT_PRIVATE_1A="rtb-placeholder-private-1a" # UPDATE ME
RT_PRIVATE_1B="rtb-placeholder-private-1b" # UPDATE ME


echo "Starting network import..."
echo "Target VPC: $VPC_ID"
echo ""

# Function to run import and continue on failure
run_import() {
    local resource_type=$1
    local resource_name=$2
    local aws_id=$3

    echo "==> Importing $resource_type.$resource_name ($aws_id)..."
    if terraform state show "$resource_type.$resource_name" &> /dev/null; then
        echo "    Already imported."
    else
        if terraform import "$resource_type.$resource_name" "$aws_id"; then
            echo "    Success."
        else
            echo "    FAILED to import $resource_type.$resource_name"
        fi
    fi
    echo ""
}

# VPC
run_import "aws_vpc" "existing" "$VPC_ID"

# Subnets
run_import "aws_subnet" "public_1a" "$SUBNET_PUB_1A"
run_import "aws_subnet" "public_1b" "$SUBNET_PUB_1B"
run_import "aws_subnet" "private_1a" "$SUBNET_PRIV_1A"
run_import "aws_subnet" "private_1b" "$SUBNET_PRIV_1B"

# Internet Gateway
run_import "aws_internet_gateway" "existing" "$IGW_ID"

# Elastic IPs
# Note: vpc.tf defines aws_eip.nat_1a and aws_eip.nat_1b. 
# Previous script had aws_eip.nat. Updated to match vpc.tf.
run_import "aws_eip" "nat_1a" "$EIP_1A_ID"
run_import "aws_eip" "nat_1b" "$EIP_1B_ID"

# NAT Gateways
run_import "aws_nat_gateway" "nat_1a" "$NAT_GW_1A_ID"
run_import "aws_nat_gateway" "nat_1b" "$NAT_GW_1B_ID"

# Route Tables
# Note: Inline routes in vpc.tf might cause diffs after import. 
# Terraform essentially strictly manages routes defined inline.
run_import "aws_route_table" "public" "$RT_PUBLIC"
run_import "aws_route_table" "private_1a" "$RT_PRIVATE_1A"
run_import "aws_route_table" "private_1b" "$RT_PRIVATE_1B"

# Route Table Associations
# Construct IDs based on Subnet ID / Route Table ID
echo "==> Importing Route Table Associations..."
# Format: subnet_id/route_table_id
run_import "aws_route_table_association" "public_1a" "$SUBNET_PUB_1A/$RT_PUBLIC"
run_import "aws_route_table_association" "public_1b" "$SUBNET_PUB_1B/$RT_PUBLIC"
run_import "aws_route_table_association" "private_1a" "$SUBNET_PRIV_1A/$RT_PRIVATE_1A"
run_import "aws_route_table_association" "private_1b" "$SUBNET_PRIV_1B/$RT_PRIVATE_1B"


echo "✅ Import process finished. Run 'terraform plan' to check for drifts or missing resources."
