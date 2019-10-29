FROM ubuntu:16.04

RUN apt-get update && \
	apt-get clean  && \
	apt-get install -y openssh-server  --no-install-recommends && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*
	
RUN mkdir /var/run/sshd && \
	echo 'root:root' | chpasswd && \
	sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \ 
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


RUN apt-get update && \
	apt-get install -y qemu wget && \
	apt-get install -y vnc4server && \
	apt-get autoclean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/*
RUN cd
RUN wget https://www.dropbox.com/s/phtmdgcjfvabp7w/winxp.img

RUN vncserver 
RUN vncserver -kill :1 

RUN chmod +x ~/.vnc/xstartup

RUN echo 'qemu-system-x86_64 -hda kvm/winxp.img -m 512M -net nic,model=virtio -net user -redir tcp:3389::3389'  >>/root/.vnc/xstartup

ADD vncserver /etc/init.d/vncserver
RUN chmod +x /etc/init.d/vncserver
RUN update-rc.d vncserver defaults

WORKDIR /root	

EXPOSE 3389
EXPOSE 22


CMD ["/usr/sbin/sshd", "-D","vncserver"]
