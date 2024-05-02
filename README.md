# Cloud Resume Challenge - Setup Repository

This repository contains the Bicep code for deploying the shared resources used by both the backend and frontend of my [Cloud Resume Challenge](https://cloudresumechallenge.dev) project.

## Overview

The Cloud Resume Challenge is a project designed to showcase cloud skills by creating a personal resume website hosted on a cloud platform. This setup repository is part of a larger project that also includes separate repositories for the frontend and backend.

## Shared Resources

The Bicep code in this repository deploys the following shared resources:

- **Azure Public DNS Zone**: This resource is used to manage the DNS records for your domain.
- **Storage Account for Terraform state files**: This resource provides a location for storing your Terraform state files.
- **Managed User Assigned Identity**: This resource is used for connecting the GitHub Repositories to Azure.

## Deployment Instructions

Follow these steps to deploy the shared resources:

1. Clone the repo or download the files.
2. Modify the default values of the parameters to match your own environments.
3. Run the main.bicep file.

Please ensure you have the necessary permissions and have installed the required tools before starting the deployment process.

## Contact

If you have any questions or feedback, please feel free to contact me.

