FROM ubuntu:14.04
MAINTAINER João Paulo Seregatte Costa <seregatte@gmail.com>
RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible

RUN echo '[local]\nlocalhost\n' > /etc/ansible/hosts

RUN mkdir /srv/example
WORKDIR /srv/example
ADD build.yml /srv/example/

RUN ansible-galaxy install seregatte.openresty

RUN ansible-playbook build.yml -c local

RUN apt-get remove --purge ansible && apt-clean

EXPOSE 80
