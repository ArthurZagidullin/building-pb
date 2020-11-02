FROM diebietse/go-gw-protoc
RUN apt-get --assume-yes install jq
RUN curl -o /usr/local/bin/swagger $(curl -s https://api.github.com/repos/go-swagger/go-swagger/releases/latest | \
  jq -r '.assets[] | select(.name | contains("'"$(uname | tr '[:upper:]' '[:lower:]')"'_amd64")) | .browser_download_url')
RUN chmod +x /usr/local/bin/swagger