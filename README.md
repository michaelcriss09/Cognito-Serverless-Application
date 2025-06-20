# AWS COGNITO SERVERLESS SIGNIN/SIGNUP

A few months ago, deployed a Serverless Architecture using manually resources on AWS | Watch here: [![Here](https://img.shields.io/badge/Project%20Here-blue.svg)](https://www.linkedin.com/posts/michael-d-cris%C3%B3stomo-10706423a_serverless-application-deployment-on-aws-activity-7273372351348498433-IOH8?utm_source=share&utm_medium=member_desktop&rcm=ACoAADtz4ZcBz7xHHAntAuuc4Zrt8XQue4DZZ5Q)

Same task, new challenges! Dynamic Profile Generator based on Amazon Cognito and Serverless Architecure 💻☁️

This project allow the following architecture:

![Arquitectura AWS](https://i.postimg.cc/BnWQqxtC/Diagrama-sin-t-tulo.jpg)

# Description

Serverless web application that allows users to authenticate using Amazon Cognito and create a profile based on specific informations automatically extracted from personal documents, in this scenario, a passport!

# Pre-requisites

1) Create an AWS free tier account
2) Install terraform
3) Allow Terraform to interact with your AWS resources through an IAM User  
4) Get the access keys credentials from your IAM User  
5) Export your Access keys in your local terminal:  
   ```bash
   export AWS_ACCESS_KEY_ID="AKIAxxxxxxxxxxxx"
   export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/xxxxxxx"

  # Usage

1) Initialize the Terraform directory:  
   ```bash
   terraform init
2) Generate the execution plan and apply to run:  
   ```bash
   terraform plan 
   terraform apply

  AWS architecture is up!

3) Connect to website from your browser
4) Test! 
5) Once finished, rember delete aws resources to avoid charges:
     ```bash
    terraform destroy

 # About this project
Be free to explore each scenario, keep improving! 🕵️  
THIS IS A TEST, DON'T SHARE YOUR AWS ACCESS KEYS !!!! ⚠️
