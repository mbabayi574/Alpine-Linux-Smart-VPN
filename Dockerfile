# Use the official Debian 12 (Bookworm) as the base image
FROM debian:bookworm-slim

# Install OpenSSH server and other necessary packages
# - apt-utils: provides utilities for apt
# - locales: needed for locale generation, which can prevent some warnings
# - sudo: useful for managing user permissions if you add non-root users later
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server apt-utils locales sudo && \
    rm -rf /var/lib/apt/lists/*

# Generate locales to avoid warnings
RUN locale-gen en_US.UTF-8

# Create SSH host keys if they don't exist (they usually don't in a fresh image)
RUN ssh-keygen -A

# Set the root password. Replace '13771210' with your desired password.
# The 'echo' command pipes the password to 'chpasswd'.
RUN echo 'root:13771210' | chpasswd

# Configure SSH daemon:
# - PermitRootLogin yes: Allows root login via SSH. Be cautious with this in production.
# - PasswordAuthentication yes: Allows password-based authentication.
# - UsePAM no: Disables Pluggable Authentication Modules (PAM) for simpler setup.
# - PrintMotd no: Disables the Message of the Day banner.
# - ListenAddress 0.0.0.0: Makes SSH listen on all available network interfaces.
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    echo "PrintMotd no" >> /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config

# Expose the SSH port
EXPOSE 22

# Command to start the SSH server when the container launches
# -D: Runs sshd in non-daemonizing mode (foreground)
# -e: Sends logs to stderr, which is good for Docker logging
CMD ["/usr/sbin/sshd", "-D", "-e"]
