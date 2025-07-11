### Download CTL & CLI files

1. Kubectl
2. Eksctl
3. AWS CLI


### AWS configure


```
aws congifure
```
AWS Access Key ID : **************************

AWS Secert Access ID : **************************

Deafult Region name [us-east-1] :

Deafult Output Fromat [json] :




To get AWS AWS Access Key ID & AWS Secert Access ID -> AWS account -> Profile -> Security credentials -> Create New Access Key (at a time only two Access Key only provide)



### Create eksctl Cluster using Fargate

```
eksctl create cluster --name demo-cluster --region us-east-1 --fargate
```

Check in AWS account weather it is created -> EKS cluster


Update the Kube-config

```
aws eks update-kubeconfig --name <your cluster> --region <your region>
```

### Create a Fargate Profile

```
eksctl create fargateprofile \
    --cluster demo-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace game-2048
```

### Deploy the deployment, service and Ingress

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/examples/2048/2048_full.yaml
```

Check the pods & Ingress are Running

```
kubectl get pods -n game-2048
```

```
kubectl get ingress -n game-2048
```


### Configure OCID connector & ALB controller


```
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve
```

Download IAM policy

```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.11.0/docs/install/iam_policy.json
```


Create IAM policy

```
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```


Create IAM Role

```
eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

Deploy ALB Controller




Download helm




Run in Adminstrator

```
choco install kubernetes-helm
```


Add helm repo

```
helm repo add eks https://aws.github.io/eks-charts
```

Update the repo

```
helm repo update eks
```


Install Load-Balancer-Controller


```
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \            
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region> \
  --set vpcId=<your-vpc-id>
```


Verify that the deployments are running.

```
kubectl get deployment -n kube-system aws-load-balancer-controller
```




After Deploy the Load-Balancer-Controller Check the Ingress pods

```
kubectl get ingress -n game-2048
```


### Copy the DNS name address


paste it the local browser





