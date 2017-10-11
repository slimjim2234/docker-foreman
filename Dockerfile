FROM centos:7

# Rediculous centos stuff
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

# Install prequisites
RUN yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm && \
    yum -y install http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum -y install https://yum.theforeman.org/releases/1.15/el7/x86_64/foreman-release.rpm && \
    yum -y install foreman-installer && \
    :;

# Copy our first_run.sh script into the container:
COPY first_run.sh /usr/local/bin/first_run.sh
RUN chmod 755 /usr/local/bin/first_run.sh

# Also copy our installer script
COPY install_foreman.sh /opt/install_foreman.sh
RUN chmod 755 /opt/install_foreman.sh

# Perform the installation
RUN bash /opt/install_foreman.sh
RUN rm -f /opt/install_foreman.sh # Don't need it anymore

# Add foreman install service
COPY install-foreman.service /etc/systemd/system/install-foreman.service
RUN systemctl enable install-foreman.service

CMD ["/usr/sbin/init"]
