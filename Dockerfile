FROM alpine:3.21.3

RUN apk add --no-cache nfs-utils=~2.6 bash=~5.2

COPY nfs.conf /etc/nfs.conf
COPY nfsd.sh /usr/bin/nfsd.sh
ENTRYPOINT ["/usr/bin/nfsd.sh"]
