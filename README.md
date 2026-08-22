# Flask CI Pipeline with Docker, GitHub Actions & Trivy

A containerized Flask application with an automated CI pipeline using GitHub Actions. This project demonstrates automated testing, Docker image builds, and container security scanning with Trivy.

The goal of this project was to build a simple production-style CI workflow that automatically validates application changes.

## Architecture

    Developer
        |
        | git push
        v
    GitHub Repository
        |
        v
    GitHub Actions
        |
        +--------------------+
        |                    |
        v                    v
    Install Dependencies   Run Pytest
        |                    |
        +---------+----------+
                  |
                  v
           Build Docker Image
                  |
                  v
            Trivy Security Scan
                  |
             +----+----+
             |         |
           PASS       FAIL
             |         |
             v         v
        Pipeline    Pipeline
        Continues     Stops

## Project Overview

This project uses a Flask application as the workload and Docker as the container runtime.

GitHub Actions automates the CI process whenever changes are pushed to the repository.

The pipeline:

1. Installs Python dependencies
2. Runs automated tests using Pytest
3. Builds the Docker image
4. Scans the Docker image using Trivy
5. Fails the workflow when security requirements are not met

## Technologies

- Python
- Flask
- Docker
- Docker Compose
- GitHub Actions
- Pytest
- Trivy
- Git / GitHub

## Application

The application is a simple Flask service that exposes application and monitoring endpoints.

### Home Endpoint

`GET /`

Returns a response from the Flask application.

The application also increments a Prometheus counter when the endpoint is accessed.

### Metrics Endpoint

`GET /metrics`

Exposes application metrics using the Prometheus Python client.

## Running Locally

### Prerequisites

Make sure you have:

- Docker Desktop
- Git
- Python 3.11+

### Clone the Repository

    git clone <your-repository-url>
    cd <repository-name>

### Run with Docker Compose

    docker compose up --build

The application will be available at:

`http://localhost:5000`

To stop the application:

    docker compose down

## Running Tests Locally

Install the development dependencies:

    pip install -r requirements-dev.txt

Run the test suite:

    pytest

Pytest is used to verify basic application functionality before the application progresses through the CI pipeline.

## CI Pipeline

The GitHub Actions workflow is triggered when code is pushed to the repository.

The pipeline performs the following stages:

    Push Code
        |
        v
    Install Dependencies
        |
        v
    Run Pytest
        |
        v
    Build Docker Image
        |
        v
    Trivy Security Scan
        |
        v
    Pipeline Result

### 1. Dependency Installation

The GitHub Actions runner installs the application's Python dependencies.

### 2. Automated Testing

Pytest runs the application's automated test suite.

If the tests fail, the workflow stops and the Docker image does not progress through the remaining pipeline stages.

### 3. Docker Image Build

The Flask application is packaged into a Docker image.

Example:

    docker build -t flask-app .

The Docker image provides a consistent runtime environment for the application.

### 4. Container Security Scanning

Trivy scans the Docker image for known vulnerabilities.

The scan checks:

- Operating system packages
- Python packages
- Known CVEs
- Container dependencies

The pipeline is configured to fail when vulnerabilities meet the configured severity threshold.

## Troubleshooting and Security Remediation

During development, the initial Trivy scan identified multiple HIGH-severity vulnerabilities in the Docker image.

### Initial Trivy Scan

The first scan reported:

- 36 HIGH-severity vulnerabilities in Debian OS packages
- 2 HIGH-severity vulnerabilities in Python packages
- 0 CRITICAL vulnerabilities

Example findings included vulnerabilities affecting:

- `util-linux`
- `bsdutils`
- `libmount`
- `libuuid`
- `setuptools`
- `wheel`
- `jaraco.context`

The vulnerabilities were identified by Trivy as part of the container security scanning stage.

### Investigation

The vulnerabilities were investigated to determine whether they originated from the application dependencies or the underlying Docker image.

The scan showed that the majority of the initial findings were associated with packages included in the Debian base image.

Additional Python package vulnerabilities were identified in the Python environment.

This helped distinguish between application dependencies and base image packages.

### Remediation

The affected packages were updated to versions containing the available security fixes.

The Docker image was then rebuilt without using the previous Docker build cache:

    docker compose build --no-cache

This ensured that the updated dependencies and base image packages were included in the newly built image.

The updated image was then rescanned using Trivy.

### Final Trivy Scan

After remediation, the final scan showed:

- 0 OS vulnerabilities
- 0 vulnerabilities in application dependencies
- 0 CRITICAL vulnerabilities

The final scan verified that the identified vulnerabilities had been remediated.

## Security Remediation Workflow

The troubleshooting process followed this workflow:

    Initial Docker Build
            |
            v
        Trivy Scan
            |
            v
    Identify Vulnerabilities
            |
            v
    Investigate Affected Packages
            |
            v
    Update Dependencies
            |
            v
    Rebuild Docker Image
            |
            v
    Run Trivy Again
            |
            v
    Verify Remediation
            |
            v
        Clean Scan

This demonstrates the importance of integrating security scanning into CI rather than treating vulnerability scanning as a one-time manual process.

## Testing Strategy

Pytest is used to perform automated application testing before the Docker image progresses through the CI pipeline.

Example:

    pytest

The tests verify basic application functionality and help prevent application changes from progressing through the pipeline when tests fail.

## Project Structure

    .
    ├── .github/
    │   └── workflows/
    │       └── ci.yml
    │
    ├── tests/
    │   └── test_app.py
    │
    ├── app.py
    ├── Dockerfile
    ├── compose.yml
    ├── requirements.txt
    ├── requirements-dev.txt
    └── README.md

## GitHub Actions Workflow

The CI workflow automates the validation process so that testing and security scanning do not have to be performed manually.

The workflow is responsible for:

- Setting up Python
- Installing dependencies
- Running Pytest
- Building the Docker image
- Running Trivy against the image
- Failing the workflow when security requirements are not met

This provides a repeatable process for validating changes before deployment.

## Key Learning Outcomes

This project provided hands-on experience with:

- Containerizing Python applications with Docker
- Building Docker images
- Using Docker Compose
- Writing automated tests with Pytest
- Creating GitHub Actions workflows
- Implementing CI automation
- Performing container vulnerability scanning
- Investigating CVEs
- Troubleshooting vulnerable dependencies
- Updating vulnerable packages
- Rebuilding Docker images
- Verifying security remediation
- Working with Git and GitHub
- Troubleshooting Python dependencies and imports

## Future Improvements

Potential future improvements include:

- Push Docker images to GitHub Container Registry (GHCR)
- Add Docker image tagging based on Git commits
- Implement Docker image caching
- Add dependency vulnerability scanning
- Add automated deployment
- Deploy the container to AWS
- Add application health checks
- Implement environment-specific deployments

## Summary

This project demonstrates a CI workflow for a containerized Flask application using Docker, GitHub Actions, Pytest, and Trivy.

The pipeline automatically:

    Code
      |
      v
    Test
      |
      v
    Build
      |
      v
    Security Scan
      |
      v
    PASS / FAIL

The project also demonstrates practical security troubleshooting by identifying vulnerabilities, investigating their source, updating affected dependencies, rebuilding the Docker image, and verifying the remediation with a subsequent Trivy scan.

The project intentionally keeps the application architecture simple so the focus remains on CI automation, containerization, testing, and security.
