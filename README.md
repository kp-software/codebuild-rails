# AWS CodeBuild Rails Environment

CodeBuild configuration for a Rails server container.

Dockerfile: https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332

## Features
- Layered Docker build that produces small Rails server containers ~175 MB
- Docker build layer caching via build-env image

# Setup

1. Copy Dockerfile and buildspec.yml into your project root.
2. Define the following environment variable in the CodeBuild project Environment
  - REPOSITORY_URI

# Credits

Original Docker file from @lemuelbarango
https://medium.com/@lemuelbarango/ruby-on-rails-smaller-docker-images-bff240931332

Docker layer caching from @monken and @Rathgore
https://github.com/aws/aws-codebuild-docker-images/issues/26#issuecomment-386913125
