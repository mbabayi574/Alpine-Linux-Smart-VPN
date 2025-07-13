# Use the official gost image as the base
FROM ginuerzh/gost:latest

EXPOSE 14433/tcp
EXPOSE 14433/udp
CMD ["-L", "ss2022://2022-blake3-aes-128-gcm:13771210@:14433"]
