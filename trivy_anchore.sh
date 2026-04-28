# trivy scanning
trivy image --format cyclonedx --output sbom.json <image_name>

# Useful for compliance + audits
trivy sbom myapp:latest -o sbom.json  # Software Bill of Materials -- detailed inventory of software components

trivy config .    # misconfiguration scanning

trivy repo https://github.com/example/repo



# Anchore - Deprecated
# Pull image
# docker pull nginx

# # Add to Anchore
# anchore-cli image add nginx:latest

# # Check vulnerabilities
# anchore-cli image vuln nginx:latest all

# # Policy evaluation
# anchore-cli evaluate check nginx:latest


# Grype is the new anchore



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


# grype pipeline
name: Grype Scan

on:
  push:

jobs:
  scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install Grype
        run: |
          curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh
          sudo mv ./bin/grype /usr/local/bin/

      - name: Update DB
        run: grype db update

      - name: Scan Image
        run: |
          grype dakshsawhneyy/demo-service-a \
          --fail-on medium \
          -o table
