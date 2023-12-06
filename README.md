# Setup Smart X poc in your AWS account

## Prerequisites

### AWS Account

### Domain Name

### Hosted Zone configured in your aws Account with your domain name

### Make a Key Pair in your AWS account in preferred Region to ssh into your instance

### Tiny URL Account and API Key

## Deploy Smart-X !

### Deploy the Stack Using the Cloudformation template - TODO: CHANGE security group rules in Template

# Template changes: Get IAM user policies from original user and update the AMI - add `route53:GetChange`

Go to Cloudformation in your AWS Console

1. create new Stack

-   Prerequisite - Prepare template: Keep the default `Tempalte is Ready` selected
-   Specify Template: Select `Upload a template file` and choose the template

2. Specify stack details

-   Stack Name: (ex: smart-x)
-   AmiID: Provide the given AMI ID in Docs
-   AvailabilityZoneName: Select the availability zone where you wish to deploy our infrastructure
-   DomainName: Enter the domain name for which you have the Hosted Zone configured (ex. `smartsenselabs.com` or `learn.smartsenselabs.com`) Ensure you have SOA record for the same domain in your Hosted Zone
-   HostedZoneId: Select your configured HostedZone
-   KeyPair: Select a key pair to access your ec2 instance which will be deployed
-   VpcName: You can leave the VPC Name as it is or enter your preferred one
-   Click on next

3. Configure stack options

-   Leave most of the options as it is, just change the below options
-   Stack failure options -> Delete newly created resources during a rollback -> Select Delete all newly created resources (This will delete all the resource when you rollback or delete your cloudformation stack)

Enter stack name: (ex: smart-x)

4. Review your stack

-   Scroll down and select `I acknowledge...` in the tickbox, and click on Next

The Cloudformation stack is being provisioned, please wait until all the resources deployed, this might take few mins. Referesh the Events Tab to see the status and wait for stack to be complete

Once complete, you can see all the things deployed in the Resources tab, and see few details in the Output Tab. Keep the output tab open as we will need these details further.

### ssh into Instance

Copy the `Ec2PublicIP` from the Output section

Open your terminal and ssh into the Instance

```sh
ssh -i /path/to/key.pem ubuntu@{ec2-public-ip}
```

In the next few steps we will change environment variables and configurations in the EC2 Instance.

### Change variables in `k8s/configmap.yaml`

`SERVER_IP` - `Ec2PublicIp` from the Outputs

`K8S_BASE_PATH` - `Ec2PrivateIP` from the Outputs - "https://{ec2-private-ip}:8443" -> "https://10.0.1.18:8443"

`BASE_DOMAIN` - Your Base Domain // TODO: Clear its usage

`S3_BUCKET_NAME` - S3BucketName from the Outputs

`VEREIGN_HOST` - to the OCM host that we want to use // Ask for the env name: will this work?

At the end, under smartsense-gaia-x-signer

`HOST` - Replace you domain name provided while make the stack - "http://gaia-x.{your-domain}:30017" -> "http://gaia-x.smartsenselabs.com:30017"

Please make sure that the indentation are not disturbed while pasting the values as these are yaml files

Save the file and close it

### Change variable in `k8s/secret.yaml`. Use `echo -n "secretMessage" | base64` command in a second terminal to generate base64 encoded strings for your secrets. Keep in mind that, all the secrets in this file should be base64 encoded.

`AWS_ACCESS_KEY` - `MyIAMAccessKey` from the Outputs

`AWS_SECRET_KEY` - `MyIAMSecretKey` from the Outputs

`HOSTED_ZONE_ID` - `HostedZoneID` from the Outputs

`CREDENTIAL_DEFINITION_ID` - provided

`PARTICIPANT_CREDENTIAL_DEFINITION_ID` - provided

`TINY_URL_KEY` - your Tiny URL API key // Make sure there is no new line

Leave K8S_TOKEN as it is, it will be automatically generated

Save the file and close it

### Change domain names in `k8s/ingress.yaml`

-   Replace [your-domain] with your domain name

Example: If your domain name is `learn.smartsenselabs.com`

1. gaia-x.[your-domain] -> gaia-x.learn.smartsenselabs.com

2. if ($http_origin ~* (.*\.[your-domain]|.*localhost)) -> if ($http*origin ~* (.\_\.learn.smartsenselabs.com|.\*localhost))

There are total 6 places where you need to replace your domain in `k8s/ingress.yaml` file.

### Change email names in `k8s/issuer.yaml`

### Change URL in frontend - `nano projects/smartsense-gaia-x-ui/src/environments/environment.ts`

## Execute `run.sh`

```sh
./run.sh
```

This will take few minutes to complete

Make sure there are no errors while applying the files.

If you get this error:

```sh
Error from server (InternalError): error when creating "k8s/ingress.yaml": Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://ingress-nginx-controller-admission.ingress-nginx.svc:443/networking/v1/ingresses?timeout=10s": dial tcp 10.103.93.67:443: connect: connection refused
```

Run:

```sh
kubectl apply -f k8s/ingress.yaml
```

Make sure the `K8S_TOKEN` is properly set in `k8s/secret.yaml` file

Wait for few moments so that all the services are up and running.

## Now you can visit you app on `gaia-x[your-domain]`
