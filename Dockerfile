FROM debian:8-slim

MAINTAINER MURAMATSU Atsushi <amura@tomato.sakura.ne.jp>

WORKDIR /work
COPY open-src-cvc.patch cvc_cmd.sh cc_cmd.sh entrypoint.sh /
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
		gcc make libc-dev libz-dev \
		git \
	&& git clone --depth 1 https://github.com/cambridgehackers/open-src-cvc \
	&& cd open-src-cvc && patch -p1 < /open-src-cvc.patch \
	&& cd src \
	&& make -f makefile.cvc64 OPTFLAGS= \
	&& cp cvc64 /usr/bin && ln /usr/bin/cvc64 /usr/bin/cvc \
	&& cp ../pli_incs/* /usr/include \
	&& cp OSS-CVC-MOD-ARTISTIC-LIC.TXT / \
	&& cd /work && rm -rf open-src-cvc /open-src-cvc.patch \
	&& apt-get purge -y git \
	&& apt-get autoremove -y --purge \
	&& rm -rf /var/cache/apt

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/bin/cvc64" ]

# docker build -t amura/open-src-cvc .
