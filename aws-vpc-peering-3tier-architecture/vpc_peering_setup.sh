
# Set Variables
REGION="us-east-1"
VPC1_CIDR="10.0.0.0/16"
VPC2_CIDR="10.1.0.0/16"
SUBNET1_CIDR="10.0.1.0/24"
SUBNET2_CIDR="10.1.1.0/24"

# Create VPCs
VPC1_ID=$(aws ec2 create-vpc --cidr-block $VPC1_CIDR --query 'Vpc.VpcId' --output text --region $REGION)
VPC2_ID=$(aws ec2 create-vpc --cidr-block $VPC2_CIDR --query 'Vpc.VpcId' --output text --region $REGION)

# Create Subnets
SUBNET1_ID=$(aws ec2 create-subnet --vpc-id $VPC1_ID --cidr-block $SUBNET1_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)
SUBNET2_ID=$(aws ec2 create-subnet --vpc-id $VPC2_ID --cidr-block $SUBNET2_CIDR --query 'Subnet.SubnetId' --output text --region $REGION)

# Create VPC Peering Connection
PEERING_ID=$(aws ec2 create-vpc-peering-connection --vpc-id $VPC1_ID --peer-vpc-id $VPC2_ID --query 'VpcPeeringConnection.VpcPeeringConnectionId' --output text --region $REGION)
aws ec2 accept-vpc-peering-connection --vpc-peering-connection-id $PEERING_ID --region $REGION

# Modify Route Tables
RT1_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC1_ID" --query 'RouteTables[0].RouteTableId' --output text --region $REGION)
RT2_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC2_ID" --query 'RouteTables[0].RouteTableId' --output text --region $REGION)
aws ec2 create-route --route-table-id $RT1_ID --destination-cidr-block $VPC2_CIDR --vpc-peering-connection-id $PEERING_ID --region $REGION
aws ec2 create-route --route-table-id $RT2_ID --destination-cidr-block $VPC1_CIDR --vpc-peering-connection-id $PEERING_ID --region $REGION

# Launch EC2 Instances for Web & App Server
WEB_INSTANCE_ID=$(aws ec2 run-instances --image-id ami-12345678 --count 1 --instance-type t2.micro --subnet-id $SUBNET1_ID --query 'Instances[0].InstanceId' --output text --region $REGION)
APP_INSTANCE_ID=$(aws ec2 run-instances --image-id ami-12345678 --count 1 --instance-type t2.micro --subnet-id $SUBNET2_ID --query 'Instances[0].InstanceId' --output text --region $REGION)

# Create RDS Database in Private Subnet
DB_SUBNET_GROUP_NAME="db-subnet-group"
aws rds create-db-subnet-group --db-subnet-group-name $DB_SUBNET_GROUP_NAME --subnet-ids "[$SUBNET2_ID]" --query 'DBSubnetGroup.DBSubnetGroupName' --output text --region $REGION
aws rds create-db-instance --db-instance-identifier mydb --db-instance-class db.t3.micro --engine mysql --allocated-storage 20 --master-username admin --master-user-password MySecurePass --vpc-security-group-ids "sg-12345678" --db-subnet-group-name $DB_SUBNET_GROUP_NAME --region $REGION

# Output Results
echo "VPC1_ID: $VPC1_ID"
echo "VPC2_ID: $VPC2_ID"
echo "VPC Peering ID: $PEERING_ID"
echo "Web Server Instance ID: $WEB_INSTANCE_ID"
echo "App Server Instance ID: $APP_INSTANCE_ID"
