# Linux Docker Installation Script

Automated Docker and Docker Compose installation script for various Linux distributions.

## Description

One-command script to install Docker Engine and Docker Compose on Ubuntu, Debian, CentOS, Fedora, and Arch Linux.

## Prerequisites

- Linux system (Ubuntu/Debian/CentOS/Fedora/Arch)
- sudo/root access
- Internet connection

## Installation

### Quick Install

```bash
# Download and run
curl -fsSL https://get.docker.com | sh

# Or use this script
./install_docker.sh
```

### Manual Install

```bash
# Make executable
chmod +x install_docker.sh

# Run script
sudo ./install_docker.sh
```

## Supported Distributions

- **Ubuntu** 20.04, 22.04, 24.04
- **Debian** 10, 11, 12
- **CentOS** 7, 8, 9
- **Fedora** 36, 37, 38, 39
- **Arch Linux** (rolling)

## Features

### What Gets Installed

1. **Docker Engine**
   - Latest stable version
   - Docker daemon
   - Docker CLI

2. **Docker Compose**
   - Docker Compose Plugin (v2)
   - Standalone docker-compose (v1)

3. **System Configuration**
   - Docker systemd service
   - User permissions (docker group)
   - Docker daemon auto-start

## Usage

### Basic Installation

```bash
# Run installation script
sudo ./install_docker.sh

# Verify installation
docker --version
docker-compose --version
```

### Non-Root Usage

```bash
# Add user to docker group (done automatically by script)
sudo usermod -aG docker $USER

# Apply new group (logout/login or use newgrp)
newgrp docker

# Test without sudo
docker run hello-world
```

## Script Features

### Auto-Detection

The script automatically detects:
- Linux distribution
- Distribution version
- Package manager (apt/yum/dnf/pacman)
- System architecture (x86_64/arm64)

### Installation Options

```bash
# Install Docker only (no Compose)
sudo ./install_docker.sh --docker-only

# Install specific version
sudo ./install_docker.sh --version 24.0.0

# Skip user group setup
sudo ./install_docker.sh --no-usermod

# Dry run (show commands without executing)
sudo ./install_docker.sh --dry-run
```

## Post-Installation

### Verify Installation

```bash
# Check Docker version
docker --version

# Run test container
docker run hello-world

# Check Docker Compose
docker compose version
```

### Configure Docker Daemon

Edit `/etc/docker/daemon.json`:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

### Enable Docker at Boot

```bash
sudo systemctl enable docker
```

## Uninstallation

### Remove Docker

```bash
# Ubuntu/Debian
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

# CentOS/Fedora
sudo yum remove docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Arch
sudo pacman -R docker docker-compose

# Remove all Docker data
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
```

## Troubleshooting

### Permission Denied

```bash
# If you get "permission denied" when running docker:
sudo usermod -aG docker $USER
newgrp docker

# Or logout and login again
```

### Docker Daemon Not Starting

```bash
# Check status
sudo systemctl status docker

# View logs
sudo journalctl -u docker

# Restart daemon
sudo systemctl restart docker
```

### Network Issues

```bash
# Check Docker network
docker network ls

# Reset Docker networks
sudo systemctl restart docker
```

### Storage Issues

```bash
# Check disk usage
docker system df

# Clean up
docker system prune -a
```

## Security

### Best Practices

```bash
# Enable Docker Content Trust
export DOCKER_CONTENT_TRUST=1

# Scan images for vulnerabilities
docker scan image_name

# Use rootless mode (advanced)
./install_docker.sh --rootless
```

### Firewall Configuration

```bash
# Ubuntu/Debian (UFW)
sudo ufw allow 2375/tcp
sudo ufw allow 2376/tcp

# CentOS/Fedora (firewalld)
sudo firewall-cmd --permanent --add-port=2375/tcp
sudo firewall-cmd --permanent --add-port=2376/tcp
sudo firewall-cmd --reload
```

## Advanced

### Install Specific Components

```bash
# Docker Engine only
sudo apt-get install docker-ce docker-ce-cli containerd.io

# Docker Compose Plugin only
sudo apt-get install docker-compose-plugin
```

### Configure Proxy

Edit `/etc/systemd/system/docker.service.d/http-proxy.conf`:
```ini
[Service]
Environment="HTTP_PROXY=http://proxy.example.com:80"
Environment="HTTPS_PROXY=https://proxy.example.com:443"
Environment="NO_PROXY=localhost,127.0.0.1"
```

### Custom Installation Path

```bash
# Change Docker root directory
sudo mkdir -p /mnt/docker
sudo systemctl stop docker
sudo rsync -av /var/lib/docker/ /mnt/docker/

# Edit /etc/docker/daemon.json
{
  "data-root": "/mnt/docker"
}

sudo systemctl start docker
```

## Automation

### Silent Install

```bash
# Non-interactive installation
export DEBIAN_FRONTEND=noninteractive
sudo -E ./install_docker.sh --yes
```

### Ansible Playbook

```yaml
- name: Install Docker
  hosts: all
  tasks:
    - name: Run Docker installation script
      script: install_docker.sh
      args:
        creates: /usr/bin/docker
```

## What the Script Does

1. Updates package repositories
2. Installs prerequisites (curl, ca-certificates, etc.)
3. Adds Docker's official GPG key
4. Adds Docker repository
5. Installs Docker Engine
6. Installs Docker Compose
7. Starts and enables Docker service
8. Adds current user to docker group
9. Verifies installation

## Resources

- [Official Docker Installation](https://docs.docker.com/engine/install/)
- [Docker Post-Installation Steps](https://docs.docker.com/engine/install/linux-postinstall/)
- [Docker Compose](https://docs.docker.com/compose/)

## License

Personal project - Private use

---

**Note**: This script uses official Docker installation methods. Always verify script contents before running with sudo.
