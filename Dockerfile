# Dockerfile to build/generate web-site 
# docker build -t hugo --build-arg local_user=gdha --build-arg local_id=1000 .

# docker: Error response from daemon: Mounts denied: 
# The path /projects/web/it3.be is not shared from the host and is not known to Docker.
# You can configure shared paths from Docker -> Preferences... -> Resources -> File Sharing.

# docker run -it -v ~/projects/web/gdha-personal-archive:/home/gdha/projects/web/gdha-personal-archive \
# -v /home/gdha/.gitconfig:/home/gdha/.gitconfig -v /home/gdha/.ssh:/home/gdha/.ssh \
# -v /home/gdha/.gnupg:/home/gdha/.gnupg  --net=host hugo

# Afterwards we can just start the container as:
# docker start -i hugo

FROM ubuntu:26.04
ARG local_user=gdha
ARG local_id=1000
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    curl \
    ca-certificates \
    git \
    openssh-client \
    gnupg \
    locales \
    vim \
    build-essential

RUN apt-get install -y hugo yq \
    && apt-get install -y imagemagick ghostscript \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN usermod -l ${local_user}  ubuntu && \
    groupmod  --new-name ${local_user} ubuntu && \
    mkdir -p /home/${local_user}/projects/web/gdha-personal-archive && \
    chown -R ${local_user}:${local_user} /home/${local_user}

# Needed to make nerdtree plugin for vim work
RUN locale-gen en_US.UTF-8 && \
    echo "export LC_CTYPE=en_US.UTF-8" >> /home/${local_user}/.bashrc && \
    echo "export LC_ALL=en_US.UTF-8" >> /home/${local_user}/.bashrc

WORKDIR /home/${local_user}/projects/web/gdha-personal-archive
USER ${local_user}
