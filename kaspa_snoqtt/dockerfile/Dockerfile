FROM debian:9-slim

ENV PROTECTED_SUBNET="192.168.146.0/24" EXTERNAL_SUBNET='!$HOME_NET' OINKCODE="a6e57f37417785ca9af06f735bb9fd89c6985dfe" ALERT_MQTT_SERVER="10.252.108.100" ALERT_MQTT_PORT=1883 NETINT="vmnet8" ALERT_MQTT_TOPIC="snoqttv5" DEVICE_ID="sensor-mmt02" COMPANY="PENS"

# Instalasi package yang diperlukan melalui apt
COPY require /root

RUN apt-get update && apt-get install -y \
	apt-utils \
	build-essential \
	libpcap-dev \
	libpcre3-dev \
	libdumbnet-dev \
	bison \
	flex \
	net-tools \
	wget \
	zlib1g-dev \
	supervisor \
	python3-dev \
	python3-pip \
	sed \
	tar \
	libcrypt-ssleay-perl \
	liblwp-useragent-determined-perl &&\

# File requirement yang dibutuhkan package python untuk menjalankan snort

	pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
	hash -r pip && \
	pip3 install --no-cache-dir -r /root/requirements.txt &&\

# Membuat direktori untuk source file daq, snort dan pulledpork

	mkdir -p /root/snort_src && \
	mkdir -p /root/daq_src && \
	mkdir -p /root/pulledpork_src &&\
	cd /root &&\

# Download source daq dan simpan pada directory ~/daq_src
	
	wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz -O daq.tar.gz &&\
	tar -xvzf daq.tar.gz --strip-components=1 -C /root/daq_src &&\
	rm daq.tar.gz &&\

# Download source snort dan simpan pada directory ~/daq_src

	wget https://www.snort.org/downloads/snort/snort-2.9.11.1.tar.gz -O snort.tar.gz &&\
	tar -xvzf snort.tar.gz --strip-components=1 -C /root/snort_src &&\
	rm snort.tar.gz &&\

# Download source pulledpork dan simpan pada directory ~/daq_src

	wget https://github.com/shirkdog/pulledpork/archive/v0.7.3.tar.gz -O pulledpork.tar.gz &&\
	tar -xvzf pulledpork.tar.gz --strip-components=1 -C /root/pulledpork_src &&\
	rm pulledpork.tar.gz &&\

# Compile source code dari daq terlebih dahulu

	cd /root/daq_src && \
	./configure && \
	make && \
	make install &&\

# Compile source code dari snort selanjutnya

	cd /root/snort_src && \
	./configure --enable-sourcefire --enable-reload && \
	make && \
	make install && \
	ldconfig && \
	ln -s /usr/local/bin/snort /usr/sbin/snort &&\

# Tambahkan username, user dan group dengan nama "snort"

	groupadd snort && \
	useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort &&\

# Buat direktori kerja snort

	mkdir /etc/snort && \
	mkdir /etc/snort/rules && \
	mkdir /etc/snort/rules/iplists && \
	mkdir /etc/snort/preproc_rules && \
	mkdir /etc/snort/so_rules && \
	mkdir /var/log/snort && \
	mkdir /var/log/snort/archived_logs && \
	mkdir /usr/local/lib/snort_dynamicrules && \
	mkdir /tmp/snort && \
	touch /etc/snort/rules/iplists/white_list.rules /etc/snort/rules/iplists/black_list.rules /etc/snort/rules/local.rules /etc/snort/sid-msg.map && \
	chmod -R 5775 /etc/snort && \
	chmod -R 5775 /var/log/snort && \
	chmod -R 5775 /var/log/snort/archived_logs && \
	chmod -R 5775 /usr/local/lib/snort_dynamicrules && \
	chown -R snort:snort /etc/snort && \
	chown -R snort:snort /var/log/snort && \
	chown -R snort:snort /usr/local/lib/snort_dynamicrules && \
	cp /root/snort_src/etc/*.conf* /etc/snort && \
	cp /root/snort_src/etc/*.map /etc/snort && \
	cp /root/snort_src/etc/*.dtd /etc/snort && \
	cp /root/snort_src/src/dynamic-preprocessors/build/usr/local/lib/snort_dynamicpreprocessor/* /usr/local/lib/snort_dynamicpreprocessor/ &&\

# Lakukan edit konfigurasi yang dibutuhkan pada file /etc/snort/snort.conf

	sed -i \
	-e 's@^ipvar HOME_NET.*@ipvar HOME_NET '"$PROTECTED_SUBNET"'@' \
	-e 's@^ipvar EXTERNAL_NET.*@ipvar EXTERNAL_NET '"$EXTERNAL_SUBNET"'@' \
	-e 's@^var RULE_PATH.*@var RULE_PATH /etc/snort/rules@' \
	-e 's@^var SO_RULE_PATH.*@var SO_RULE_PATH /etc/snort/so_rules@' \
	-e 's@^var PREPROC_RULE_PATH.*@var PREPROCRULE_PATH /etc/snort/preproc_rules@' \
	-e 's@^var WHITE_LIST_PATH.*@var WHITE_LIST_PATH /etc/snort/rules/iplists@' \
	-e 's@^var BLACK_LIST_PATH.*@var BLACK_LIST_PATH /etc/snort/rules/iplists@' \
	-e 's@^\(include $.*\)@# \1@' \
	-e 's@\# include \$RULE\_PATH\/local\.rules@include \$RULE\_PATH\/local\.rules@' \
	-e '/include \$RULE\_PATH\/local\.rules/a include \$RULE\_PATH\/snort\.rules' \
		/etc/snort/snort.conf &&\

# Instalasi source pulledpork

	cp /root/pulledpork_src/pulledpork.pl /usr/local/bin && \
	chmod +x /usr/local/bin/pulledpork.pl &&\
	cp /root/pulledpork_src/etc/*.conf /etc/snort &&\
	cp /root/pulledpork.conf /etc/snort &&\

	sed -i 's@.oinkcode.@'"$OINKCODE"'@' /etc/snort/pulledpork.conf &&\

	/usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l &&\
	snort -T -c /etc/snort/snort.conf &&\

	sed -i '/import alert/c\import snortunsock.alert as alert' /usr/local/lib/python3.5/dist-packages/snortunsock/snort_listener.py &&\

# Cleanup
	rm -rf /root/snort_src &&\
	rm -rf /root/daq_src &&\
	rm -rf /root/pulledpork_src &&\
	rm /root/requirements.txt /root/pulledpork.conf &&\
	apt-get purge -y net-tools &&\
	apt-get purge -y wget &&\
	apt autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5000

ENTRYPOINT ["/usr/bin/supervisord","-c","/root/libs/super_snort.conf"]
