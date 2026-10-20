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
2. In IAM, create an OIDC identity provider for
   `https://token.actions.githubusercontent.com` with audience
   `sts.amazonaws.com` (reuse it if it already exists).
3. Create an IAM role for GitHub Actions. Set its trust policy to allow your
   GitHub repository's `main` branch. Replace the example owner, repo, and
   account ID with yours:

   ```json
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Effect": "Allow",
       "Principal": {
         "Federated": "arn:aws:iam::AWS_ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
       },
       "Action": "sts:AssumeRoleWithWebIdentity",
       "Condition": {
         "StringEquals": {
           "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
         },
         "StringLike": {
           "token.actions.githubusercontent.com:sub": "repo:OWNER/REPOSITORY:ref:refs/heads/main"
         }
       }
     }]
   }
   ```

4. Attach [aws-iam-policy.json](./aws-iam-policy.json) to the role. It is
   already set up for the `tfstatefilepractise` bucket.
5. After creating the role, go to **IAM → Roles** and click the role name.
   On the role details page, copy the **ARN** shown near the top. It looks
   like `arn:aws:iam::123456789012:role/GitHubTerraformPractice`. You will
   paste this value into GitHub as `AWS_ROLE_ARN`.

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
