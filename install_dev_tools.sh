#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Starting Development Tools Installation: Docker, Docker Compose, Python, Django ==="

# --- Function to check and install Docker ---
install_docker() {
    if command -v docker &> /dev/null; then
        echo "✅ Docker is already installed. Skipping installation."
    else
        echo "⚙️ Installing Docker..."
        # Update package index and install prerequisites
        sudo apt update -y
        sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
        
        # Add Docker's official GPG key
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        
        # Set up the stable Docker repository
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # Install Docker Engine, CLI, and Containerd
        sudo apt update -y
        sudo apt install -y docker-ce docker-ce-cli containerd.io

        # Add current user to the docker group
        if ! grep -q "docker" /etc/group || ! groups $USER | grep -q "docker"; then
            sudo usermod -aG docker $USER
            echo "⚠️ Added user **$USER** to the **'docker'** group. You need to **log out and log back in** for this change to take effect."
        fi
        echo "✅ Docker installed successfully."
    fi
}

# --- Function to check and install Docker Compose ---
install_docker_compose() {
    # Check for the legacy 'docker-compose' command
    if command -v docker-compose &> /dev/null; then
        echo "✅ Docker Compose (legacy binary) is already installed. Skipping installation."
    # Check for the new 'docker compose' plugin (which is often installed with docker-ce now)
    elif docker compose version &> /dev/null; then
        echo "✅ Docker Compose (plugin) is already installed. Skipping installation."
    else
        echo "⚙️ Installing Docker Compose (legacy binary method)..."
        # Determine the latest stable version of Docker Compose
        DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K[^"]+')
        
        # Download the binary file
        sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        
        # Apply executable permissions
        sudo chmod +x /usr/local/bin/docker-compose
        
        # Verification
        if command -v docker-compose &> /dev/null; then
            echo "✅ Docker Compose (${DOCKER_COMPOSE_VERSION}) installed successfully."
        else
            echo "❌ Failed to install Docker Compose."
        fi
    fi
}

# --- Function for revised check/installation of Python and Django (for the required environment) ---
install_python_django() {
    # Check for Python 3.9+ (assuming system package check via apt is required by the task)
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        
        # We rely on the system already having Python 3.9+ or installing it via apt
        if dpkg --compare-versions "$PYTHON_VERSION" "ge" "3.9"; then
            echo "✅ Python ($PYTHON_VERSION) version 3.9+ is already installed. Skipping base installation."
        else
            echo "⚙️ Python version ($PYTHON_VERSION) < 3.9. Installing/Upgrading Python and pip..."
            sudo apt update -y
            sudo apt install -y python3 python3-pip
            echo "✅ Python installed/upgraded via apt."
        fi
    else
        echo "⚙️ Installing Python 3 and pip..."
        sudo apt update -y
        sudo apt install -y python3 python3-pip
        echo "✅ Python 3 and pip installed successfully."
    fi

    # 2. Check/Install Django
    # We now check for the system package or the pip installed version
    if python3 -m django --version &> /dev/null || dpkg -l | grep -q "python3-django"; then
        DJANGO_VERSION=$(python3 -m django --version 2>/dev/null || echo "System-Managed")
        echo "✅ Django ($DJANGO_VERSION) is already installed. Skipping installation."
    else
        echo "⚙️ Installing Django using apt (system package manager)..."
        # ⚠️ ADDING APT UPDATE HERE TO PREVENT 404 ERRORS ⚠️
        sudo apt update -y
        # Use apt to install the official Ubuntu Django package
        sudo apt install -y python3-django
        echo "✅ Django installed successfully."
    fi
}

# --- Execute Functions ---
install_docker
install_docker_compose
install_python_django

echo "================================================================="
echo "🎉 Installation complete!"
echo "Note: If this was your first time installing Docker, remember to **log out and log back in**"
echo "for the 'docker' group changes to take effect."
echo "================================================================="