FROM gcc:4.8.5 AS build
WORKDIR /app
COPY stream.c .
RUN gcc -O stream.c -o stream -static

FROM scratch
COPY --from=build /app/stream /
CMD ["/stream"]
