FROM alpine:latest
MAINTAINER João Paulo <seregatte@gmail.com>

ENV LUA_VERSION 5.1

ENV LUA_PACKAGE lua${LUA_VERSION}

ENV ROCKS_VERSION 3.0.1

RUN apk update

RUN apk add ${LUA_PACKAGE}
RUN apk add ${LUA_PACKAGE}-dev

RUN apk add --update ca-certificates build-base curl unzip outils-md5 openssl-dev

RUN wget -c http://luarocks.github.io/luarocks/releases/luarocks-${ROCKS_VERSION}.tar.gz && \
	tar -zxvf luarocks-${ROCKS_VERSION}.tar.gz && \
	mv luarocks-${ROCKS_VERSION} /usr/local/ && \
	cd /usr/local/luarocks-${ROCKS_VERSION} && \
	./configure --with-lua-bin=/usr/bin/ --with-lua=/usr/lua${LUA_VERSION} --with-lua-lib=/usr/lua${LUA_VERSION}/lib && \
	make build && make install && \
	rm -Rf /luarocks-${ROCKS_VERSION}.tar.gz && \
	rm -Rf /usr/local/luarocks-${ROCKS_VERSION} ;
