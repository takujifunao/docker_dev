FROM centos:centos6
MAINTAINER takuji funao

ARG USER_NAME

# install package
RUN yum install -y initscripts MAKEDEV
RUN yum update -y
RUN yum install -y vim git sudo passwd wget make gcc tar readline-devel gcc-c++
RUN yum install -y openssl-devel openssh openssh-server openssh-clients
RUN yum install -y ImageMagick ImageMagick-devel
RUN yum install -y install libxml2 libxml2-devel libxslt libxslt-devel
RUN yum install -y libffi-devel bzip2

# install MySQL
RUN yum -y install http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum info mysql-community-server
RUN yum -y install mysql-community-server
RUN yum -y install mysql-devel
RUN /etc/init.d/mysqld restart

# install redis
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum --enablerepo=epel -y install redis
RUN /etc/init.d/redis start
RUN chkconfig redis on

# create user
RUN useradd -m -s /bin/bash $USER_NAME
RUN echo 'set_pass_word' | passwd --stdin $USER_NAME

RUN echo 'root:screencast' | chpasswd
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start

# setup sudo config
RUN echo "$USER_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# setup rbenv
## rben install
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN git clone git://github.com/jf/rbenv-gemset.git $HOME/.rbenv/plugins/rbenv-gemset
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

EXPOSE 22 3000

CMD /sbin/init

