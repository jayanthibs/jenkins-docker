# FROM jenkins/jenkins:2.414.2-jdk11
# USER root
# RUN apt-get update && apt-get install -y lsb-release python3-pip
# RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
#   https://download.docker.com/linux/debian/gpg
# RUN echo "deb [arch=$(dpkg --print-architecture) \
#   signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
#   https://download.docker.com/linux/debian \
#   $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
# RUN apt-get update && apt-get install -y docker-ce-cli
# USER jenkins
# RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"

FROM jenkins/jenkins:lts-jdk17

USER root

# Basic tools + Python
RUN apt-get update && \
    apt-get install -y \
    lsb-release \
    curl \
    git \
    python3 \
    python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python || true \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI setup
RUN curl -fsSL https://download.docker.com/linux/debian/gpg \
    -o /usr/share/keyrings/docker-archive-keyring.asc

RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

RUN apt-get update && \
    apt-get install -y docker-ce-cli && \
    rm -rf /var/lib/apt/lists/*

USER jenkins

# Jenkins plugins (modern + stable stack)
RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    github \
    credentials-binding \
    docker-workflow \
    pipeline-stage-view \
    blueocean:1.27.25