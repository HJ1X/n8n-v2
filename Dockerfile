FROM n8nio/n8n:latest

USER root

# Install Python 3 and pip
RUN apk add --update --no-cache python3 py3-pip

# (Optional) Install common Python libraries if needed
# RUN pip3 install requests pandas numpy

USER node