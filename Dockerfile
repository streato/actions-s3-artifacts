FROM alpine:latest
 
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && pip3 install \
        awscli-plugin-endpoint \    
    && rm -rf /var/cache/apk/*
    
RUN aws --version 

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
