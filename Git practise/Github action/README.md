# EC2 practice: Terraform + GitHub Actions

This lab uses Terraform and GitHub Actions to create a small EC2 web server.
The workflows run only when you start them manually. The server has a public
web page and no SSH access.

> **Costs:** AWS may charge for the EC2 instance, storage, and public IP.
> Deploy only for practice, then run the destroy workflow.

## 1. Prepare AWS

1. In S3, create the bucket `tfstatefilepractise` in the AWS region you plan
   to use. Turn on bucket versioning and keep Block Public Access enabled.
   The bucket stores Terraform's state; this project does not create it.
2. In **IAM → Identity providers**, check whether
   `token.actions.githubusercontent.com` already exists. If not, add it with
   audience `sts.amazonaws.com`.
3. In **IAM → Roles → Create role**, choose **Web identity**, select the
   GitHub provider, and set the audience to `sts.amazonaws.com`. Finish
   creating a role named `GitHubTerraformPractice`.
4. Open the new role's **Trust relationships → Edit trust policy**. Replace
   the trust policy with the contents of
   [aws-trust-policy.json](./aws-trust-policy.json), then save. Confirm the
   provider ARN in the file matches the provider in your AWS account. If your
   account ID is different, replace `676206937049` in the file with your
   account ID.

   This policy allows workflows from any branch in this repository to assume
   the role. For a more restrictive setup, replace the `sub` value with
   `repo:olajidenurudeenrasaq-dotcom/terraform-practise:ref:refs/heads/main`
   to allow only the `main` branch.
5. On the role page, choose **Add permissions** and attach the policy created
   from [aws-iam-policy.json](./aws-iam-policy.json). Then copy the role ARN
   shown near the top of the page.

## 2. Add GitHub variables

In your repository, go to **Settings → Secrets and variables → Actions →
Variables** and add:

| Variable | Value |
| --- | --- |
| `AWS_ROLE_ARN` | Paste the role ARN you copied in step 5 |
| `AWS_REGION` | The region where you created the S3 bucket |
| `TF_STATE_BUCKET` | `tfstatefilepractise` |

No AWS access keys are needed. The workflows use OIDC for temporary
credentials.

If the workflow still cannot assume the role, confirm the saved trust policy
matches [aws-trust-policy.json](./aws-trust-policy.json), the OIDC provider
has `sts.amazonaws.com` as an audience, and GitHub's `AWS_ROLE_ARN` variable
matches the ARN shown on this role's page.

## 3. Push the files to GitHub

Run from the repository root in PowerShell:

```powershell
git status
git add "Git practise/Github action" ".github/workflows/deploy-ec2.yml" ".github/workflows/destroy-ec2.yml"
git diff --cached
git commit -m "Add EC2 practice deployment"
git push
```

Check the staged changes before committing.

## 4. Deploy

In GitHub, open **Actions → Deploy practice EC2 → Run workflow** on `main`.
When it finishes, the log prints the website URL. It can take a minute or two
for the web server to start responding.

## 5. Clean up

Open **Actions → Destroy practice EC2 → Run workflow** on `main`. Type
`DESTROY` to confirm. This removes the EC2 instance and security group.
Terraform's state bucket is kept so you can practice again.

## Optional: change Terraform settings

[terraform.tfvars.example](./terraform.tfvars.example) shows the region and
instance size. For local Terraform use, copy it to `terraform.tfvars` and
edit the values. That local file is ignored by Git. GitHub Actions uses the
`AWS_REGION` variable instead.
