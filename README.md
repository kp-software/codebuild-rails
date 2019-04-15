# AWS CodeBuild Rails Environment

This repository is an extension of the AWS CodeBuild Ruby environment with everything needed to create production ready Rails builds.

Based on: https://github.com/aws/aws-codebuild-docker-images/tree/861780d9f6591bd71cbbe84a44375990118bc039/ubuntu/ruby/2.5.3

## Features:
- Node.js 10 LTS
- Yarn

# Setup

- Create ECR Repository
- Create CodeBuild Project
  - Add REPOSITORY_URI to the ENV
