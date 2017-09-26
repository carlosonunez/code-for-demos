FROM python:2.7

RUN pip install ansible==2.4.0
RUN pip install ansible-lint==2.3.2
RUN mkdir /src
WORKDIR /src
ENTRYPOINT ["/usr/local/bin/ansible-lint"]
