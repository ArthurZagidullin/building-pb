FROM grpc/go
COPY . /app/
WORKDIR /app
VOLUME ./artifacts
RUN ["chmod", "+x", "/app/build-pb.sh"]
ENTRYPOINT ["/app/build-pb.sh"]
