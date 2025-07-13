FROM ginuerzh/gost

EXPOSE 1080
EXPOSE 3128

CMD ["-L", "socks5://bobby:13771210@:1080", "-L", "http://bobby:13771210@:3128"]
