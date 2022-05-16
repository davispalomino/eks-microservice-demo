<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Pipeline
![](img/pipeline.jpg)

## Requirements

Supported Operating System **Linux & MacOs**

| Name | Version |
|------|---------|
| kubectl | >= v1.24.0 |
| aws-cli | >= 2.7.0 |
| jq | >= 1.6 |
| terraform | >= v0.15.0 |
| Makefile | >= 3.81 |
| docker | >= 20.10.8 |
| docker-compose | >= 1.29.2 |
| (*) gsed | >= 4.8 |

(*)MacOs 

## QuickInstall

Quick-Install Wizard is provided that will guide you through the first installation and setup, **environment variables to configure the AWS CLI** https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html

```Makefile
make quickstart
```

## Update Image and APP code

Update the application code

```Makefile
make container_update
```

## Troubleshooting

```shell
deprecated API version client.authentication.k8s.io/v1alpha1
```

Fix Linux:
```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && sudo ./aws/install
```

Fix MacOS:
```
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```