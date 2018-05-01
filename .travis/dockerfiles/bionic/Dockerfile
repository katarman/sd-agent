FROM ubuntu:18.04
WORKDIR /root
RUN apt-get update && apt-get install -y pbuilder debootstrap devscripts ubuntu-dev-tools qemu qemu-user-static binfmt-support
RUN echo 'for release in trusty xenial bionic stretch jessie; do for arch in amd64 i386; do pbuilder-dist $release $arch create; done; done' > /root/pbuilder-bootstrap.sh
RUN apt-get install --reinstall qemu-user-static
RUN echo 'USENETWORK=yes' >> /etc/pbuilderrc
RUN chmod +x /root/pbuilder-bootstrap.sh
COPY ./entrypoint.sh /
CMD ["sh","/root/pbuilder-bootstrap.sh"]
