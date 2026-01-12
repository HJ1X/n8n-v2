FROM n8nio/n8n:latest

USER root

# 1. Install Python, Supervisor, and build dependencies
RUN apk add --update --no-cache python3 py3-pip supervisor build-base

# 2. Install the n8n Task Runner separately (since it was removed from the main image)
RUN npm install -g @n8n/task-runner

# 3. Create directory for Supervisor logs
RUN mkdir -p /var/log/supervisor

# 4. Copy the Supervisor configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 5. Switch back to the node user (optional, but Supervisor usually runs as root or needs perms)
# For simplicity on Render, we run as root or ensure permissions are correct. 
# n8n warns if run as root, but for this custom setup it's often smoother.
# If you want strictly non-root, you'll need to chown the supervisor dirs.
USER root

# 6. Start Supervisor (which starts n8n and the Runner)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]