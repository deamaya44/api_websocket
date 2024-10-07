
# WebSocket API with AWS Lambda and Terraform

This repository provides a Terraform configuration for deploying a WebSocket API using AWS services, including Lambda functions for handling connections, disconnections, and default messages. The stack allows for real-time communication and is scalable to meet dynamic application needs.

## Features

- **WebSocket API**: Managed through AWS API Gateway, facilitating real-time interactions between clients and services.
- **AWS Lambda Functions**:
  - **Connect Lambda**: Handles new WebSocket connections.
  - **Disconnect Lambda**: Manages disconnections to maintain session integrity.
  - **Default Lambda**: Processes default messages received through the WebSocket.

## Requirements

To set up this WebSocket API, ensure you have the following installed:

- [Terraform](https://www.terraform.io/downloads.html)
- AWS account with proper IAM permissions

## Installation

1. **Clone this repository**:

    ```bash
    git clone https://github.com/your-username/websocket-api.git
    cd websocket-api
    ```

2. **Configure the necessary variables** in `variables.tf` to set your AWS region, access key, and secret key.

3. **Initialize Terraform**:

    ```bash
    terraform init
    ```

4. **Deploy the infrastructure**:

    ```bash
    terraform apply
    ```

    Confirm the action when prompted. This will create the WebSocket API, Lambda functions, and necessary IAM roles.

## Usage

- Once deployed, you can connect to the WebSocket API endpoint provided by Terraform.
- Use the following endpoints for interaction:
  - **Connect**: Handle new connections.
  - **Disconnect**: Manage disconnections.
  - **Default**: Handle default messages.

## Lambda Deployment

The Lambda functions are defined in the Terraform configuration and should have the necessary Node.js code packaged in a `lambda.zip` file. Ensure the code is properly defined to handle the respective events.

## Contributions

Contributions are welcome! Please feel free to open an issue for feature requests or improvements. To contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
