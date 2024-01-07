# Use an official Ubuntu base image
FROM ubuntu:latest

# Install SSH and other necessary utilities
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create ansible user and add to sudoers for passwordless sudo
RUN useradd -m ansibleuser && \
    echo 'ansibleuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansibleuser

# SSH key setup
RUN mkdir -p /home/ansibleuser/.ssh
COPY files/id_ed25519.pub /home/ansibleuser/.ssh/authorized_keys
RUN chown -R ansibleuser:ansibleuser /home/ansibleuser/.ssh && \
    chmod 700 /home/ansibleuser/.ssh && \
    chmod 600 /home/ansibleuser/.ssh/authorized_keys

# SSH configuration
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Run SSH server
CMD ["/usr/sbin/sshd", "-D"]
