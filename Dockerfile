# CHANGE: Use standard Node Alpine image instead of n8n's locked-down image
FROM node:22-alpine

USER root

# 1. Install Python, Supervisor, and build tools
RUN apk add --update --no-cache python3 py3-pip supervisor build-base sqlite

# 2. Install n8n and the Task Runner globally via npm
#    (This rebuilds n8n from source for this OS, which is safer)
RUN npm install -g n8n @n8n/task-runner

# 3. Create directory for Supervisor logs
RUN mkdir -p /var/log/supervisor

# 4. Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 5. Setup n8n user directory (so we don't run as root)
RUN mkdir -p /home/node/.n8n && chown -R node:node /home/node/.n8n

USER root

# 6. Start Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]