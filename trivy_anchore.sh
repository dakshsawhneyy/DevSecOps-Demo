# trivy scanning
trivy image --format cyclonedx --output sbom.json <image_name>

trivy sbom myapp:latest -o sbom.json  # Software Bill of Materials -- detailed inventory of software components

trivy config .    # misconfiguration scanning

# Anchore
# Pull image
docker pull nginx

# Add to Anchore
anchore-cli image add nginx:latest

# Check vulnerabilities
anchore-cli image vuln nginx:latest all

# Policy evaluation
anchore-cli evaluate check nginx:latest


# CICD
name: Trivy Scan

on:
  push:
    branches: [ "main" ]
  pull_request:

jobs:
  trivy-scan:
    name: Trivy Vulnerability Scan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Build Docker Image
        run: docker build -t myapp:latest .

      - name: Run Trivy Scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'myapp:latest'
          format: 'table'
          exit-code: '1'
          ignore-unfixed: true
          severity: 'CRITICAL,HIGH'


# Anchore
name: Anchore Scan

on:
  push:
    branches: [ "main" ]

jobs:
  anchore:
    runs-on: ubuntu-latest
    name: Anchore Image Scan

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Build Image
        run: docker build -t myapp:latest .

      - name: Run Anchore Scan
        uses: anchore/scan-action@v3
        with:
          image: "myapp:latest"
          fail-build: true
          severity-cutoff: high
