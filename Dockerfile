FROM centos:centos7
MAINTAINER takuji funao

ARG USER_NAME

# install package
RUN yum -y install systemd-libs-208-11.el7_0.4 systemd-sysv-208-11.el7_0.4
RUN yum update -y
RUN yum install -y vim git sudo passwd wget make gcc tar readline-devel
RUN yum install -y openssl-devel openssh openssh-server openssh-clients
RUN yum install -y ImageMagick ImageMagick-devel
RUN yum install -y install libxml2 libxml2-devel libxslt libxslt-devel
RUN yum install -y libffi-devel.x86_64

# install MySQL
RUN yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum info mysql-community-server
RUN yum -y install mysql-community-server
RUN /etc/init.d/mysqld restart
RUN yum -y install mysql-devel

# create user
RUN useradd -m -s /bin/bash $USER_NAME
RUN echo 'set_pass_word' | passwd --stdin $USER_NAME

# Set up SSH
RUN	mkdir -p /home/$USER_NAME/.ssh; chown docker /home/docker/.ssh; chmod 700 /home/docker/.ssh && \
	echo "公開鍵" > /home/$USER_NAME/.ssh/authorized_keys && \
	chown docker /home/$USER_NAME/.ssh/authorized_keys && \
	chmod 600 /home/$USER_NAME/.ssh/authorized_keys

# setup sudo config
RUN echo "$USER_NAME ALL=(ALL) ALL" >> /etc/sudoers.d/docker

# Set up SSHD config

RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
    sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config && \
    sed -i -e 's/^\(session.*pam_loginuid.so\)/#\1/g' /etc/pam.d/sshd

# setup rbenv
## rben install
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile

## ruby install
RUN ~/.rbenv/bin/rbenv install 2.2.0
RUN ~/.rbenv/bin/rbenv global 2.2.0

# setup nodebrew
RUN curl -L https://raw.githubusercontent.com/hokaccha/nodebrew/master/nodebrew | perl - setup
RUN echo 'export PATH="$HOME/.nodebrew/current/bin:$PATH"' >> ~/.bash_profile

## node install
RUN ~/.nodebrew/current/bin/nodebrew install-binary stable
RUN ~/.nodebrew/current/bin/nodebrew use stable

EXPOSE 22

CMD /sbin/init

