FROM hashicorp/terraform:0.14.7

RUN mkdir -p /usr/local/share/ca-certificates
COPY caadmin.netskope.com.pem /usr/local/share/ca-certificates/netskope.crt
RUN cat /usr/local/share/ca-certificates/netskope.crt >> /etc/ssl/certs/ca-certificates.crt
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

COPY terraform_apply.sh /terraform_apply.sh

ENTRYPOINT [""]

CMD ["/terraform_apply.sh"]