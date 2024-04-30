FROM --platform=linux/amd64 debian:8-slim

MAINTAINER MURAMATSU Atsushi <amura@tomato.sakura.ne.jp>

WORKDIR /work
COPY open-src-cvc.patch cvc_cmd.pl cc_cmd.sh entrypoint.sh /
RUN rm /etc/apt/sources.list \
	&& echo "deb http://archive.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list.d/jessie.list \
	&& echo "deb http://archive.debian.org/debian jessie main" >> /etc/apt/sources.list.d/jessie.list \
	&& apt-get update && apt-get upgrade -y \
	&& apt-get install -y --force-yes \
		gcc make libc-dev libz-dev \
		git \
	&& git clone --depth 1 https://github.com/cambridgehackers/open-src-cvc \
	&& cd open-src-cvc && patch -p1 < /open-src-cvc.patch \
	&& cd src \
	&& make -f makefile.cvc64 OPTFLAGS= \
	&& cp cvc64 /usr/bin && ln /usr/bin/cvc64 /usr/bin/cvc \
	&& cp OSS-CVC-MOD-ARTISTIC-LIC.TXT / \
	&& cp ../pli_incs/* /usr/include \
	&& cd ../toggle_coverage/src \
	&& make -f makefile.lnx all \
	&& cp tvcd_to_tgldat chk_tgldat tgldat_report tgldat_merge /usr/bin \
	&& cd /work/open-src-cvc \
	&& mkdir /usr/share/doc/open-src-cvc \
	&& cp -r doc/* /usr/share/doc/open-src-cvc \
	&& cp getting_started.README OSS-CVC-* /usr/share/doc/open-src-cvc \
	&& cd /work && rm -rf open-src-cvc /open-src-cvc.patch \
	&& apt-get purge -y git && apt-get autoremove -y --purge \
		&& rm -rf /var/cache/apt

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/cvc64" ]

# docker build -t amura/open-src-cvc .
