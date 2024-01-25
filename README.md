Hello! Thank you for your interest in this repository! 🥹 Here you’ll find my final project for [Telerik’s DevOps Upskill program](https://www.telerikacademy.com/upskill/devops). The goal is to build a complete automated software delivery pipeline.

The app being deployed is a simple one - a web page that collects names and email addresses and stores them in the cloud. Technologies used for the app - python, flask, DynamoDB.

<img width="1505" alt="291097909-b0eae815-5385-455e-a83e-6bb9613c7c83" src="https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/c0ea6d46-fa69-4d55-a94d-81d4b792a4f0">

The pipeline starts with this git repository. The main branch is protected and can be updated only with a Pull Request that passes necessary checks:

- Run [linters](https://github.com/wearerequired/lint-action)
- Run terraform fmt [check](https://github.com/marketplace/actions/terraform-fmt-check)
- Run tests
- Scan for [leaked secrets](https://github.com/GitGuardian/ggshield-action)
- Scan for [security vulnerabilities](https://www.sonarsource.com/products/sonarcloud/)
- Scan docker image for [vulnerabilities](https://github.com/aquasecurity/trivy-action)

<img width="917" alt="Screenshot 2024-01-25 at 16 50 10" src="https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/9dc32a90-9417-466a-9154-3a81a46afc0a">

Also, all work that needs to be done is tracked in a Jira board integrated with this GitHub repository.

![Screenshot 2024-01-22 at 14 21 54](https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/ea4a0c50-9c91-41db-b27d-e9e781f719da)

There are two rules created. 
- When a PR which contains the key of the Jira issue is opened, the issue is moved to the "Code Review" column.
- When the PR is merged, the issue is sent to the "Done" column.

Once the PR is merged to main, a pipeline in CodePipelines gets triggered. [AWS’s CodeStar Connections](https://docs.aws.amazon.com/codestar-connections/latest/APIReference/Welcome.html) are used to manage the integration between GitHub and CodePipeline. Note that the infrastructure for the deployment pipeline e.g. CodePipeline, CodeBuild, the IAM policies and roles, ECR, S3 bucket etc. are provisioned manually. 

To provision the required infrastructure follow these steps.
- Make sure you have access to the AWS account.
- Assume the role using which you'll provision the resources.
- Make sure you have terraform installed locally. Find intallation instructions [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- Run `cd terraform-initial-setup` to select the right folder.
- Run `terrafom plan` and `terraform apply` to provision the resources.
- Go to the AWS console and check if the resources are created.

A CodePipeline is one of these resources we just created. The pipeline executes the following stages:

1. **Source** - where it downloads the code package from GitHub and stores it in the S3 Bucket.
2. **Build Docker image** - build the docker image from a Dockerfile and push it to an existing ECR registry
3. **Terraform Plan** - where CodeBuild will execute the `terraform plan` and copy the `tfplan` into S3
4. **Approve** - waits for someone to review the `tfplan` and approve to proceed with the `apply`
5. **Apply** - If approved, this stage will fire up CodeBuild to do the `terraform apply` on the preexisting `tfplan` file.

Also, if a CodeBuild project fails, an email is sent to the subsribed stakeholders.

![Screenshot 2024-01-22 at 14 18 07](https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/1fb6e6d8-a253-40b2-9395-7d390d350ba9)
![Screenshot 2024-01-22 at 14 30 14](https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/829c9867-36cc-4355-83a3-f15a2f3d2885)

The app is deployed to an ECS (on Fargate) cluster with Internet Gateway and Application Load Balancer. 

[AWS ECS](https://aws.amazon.com/ecs/) is a fully managed service, meaning AWS handles the underlying infrastructure, updates, and maintenance tasks. This allows developers to focus on building and deploying applications without worrying about managing the container orchestration platform.

<img width="1185" alt="Screenshot 2024-01-23 at 9 18 07" src="https://github.com/anisarambelieva/devops-upskill-final-project/assets/36369561/d203fd2e-ac56-4f9f-859d-2c72f410b867">

⭐️ Future improvements wishlist
- Integrate the "Manual Approval" stage of the CodePipeline with MS Teams channel notifications.
- Migrate from ECS to EKS for a more granular control over the K8s cluster
- Use git commit SHA to tag the image in the ECR registry
