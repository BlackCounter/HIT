conf.d$ ls
dartilcdn.hasti.co.conf  default.conf



 cat dartilcdn.hasti.co.conf 
server  {
	listen  443 ssl;
	server_name dartilcdn.hasti.co;
	client_max_body_size        100M;
	resolver 127.0.0.11 ipv6=off valid=10s;

	location /  {
		autoindex on;
		root    /cdn;
		expires 360d;
	}
	# logs
	access_log /dev/stdout;
	error_log /dev/stdout;

	# header
	add_header Access-Control-Allow-Origin "*";
	add_header Access-Control-Allow-Methods POST,GET,OPTIONS;
	add_header Access-Control-Allow-Credentials true;
	add_header Access-Control-Allow-Headers cache-control,Origin,Content-Type,Accept,Authorization,Content-Type,X-PINGOTHER;

	# ssl
	ssl_session_timeout 180m;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
	ssl_certificate /etc/nginx/certs/nginx_bundle.crt;
	ssl_certificate_key /etc/nginx/certs/privkey.pem;






 cat default.conf 
server {
    listen 80;
    listen [::]:80;
    server_name *.hasti.co;
    resolver 127.0.0.11 ipv6=off valid=10s;
    return 301 https://$host$request_uri;
}
log_format main_json escape=json '{'
		'"msec": "$msec", ' # request unixtime in seconds with a milliseconds resolution
		'"connection": "$connection", ' # connection serial number
		'"connection_requests": "$connection_requests", ' # number of requests made in connection
		'"pid": "$pid", ' # process pid
		'"request_id": "$request_id", ' # the unique request id
		'"request_length": "$request_length", ' # request length (including headers and body)
		'"remote_addr": "$remote_addr", ' # client IP
		'"remote_user": "$remote_user", ' # client HTTP username
		'"remote_port": "$remote_port", ' # client port
		'"time_local": "$time_local", '
		'"time_iso8601": "$time_iso8601", ' # local time in the ISO 8601 standard format
		'"request": "$request", ' # full path no arguments if the request
		'"request_uri": "$request_uri", ' # full path and arguments if the request
		'"args": "$args", ' # args
		'"status": "$status", ' # response status code
		'"body_bytes_sent": "$body_bytes_sent", ' # the number of body bytes exclude headers sent to a client
		'"bytes_sent": "$bytes_sent", ' # the number of bytes sent to a client
		'"http_referer": "$http_referer", ' # HTTP referer
		'"http_user_agent": "$http_user_agent", ' # user agent
		'"http_x_forwarded_for": "$http_x_forwarded_for", ' # http_x_forwarded_for
		'"http_host": "$http_host", ' # the request Host: header
		'"server_name": "$server_name", ' # the name of the vhost serving the request
		'"request_time": "$request_time", ' # request processing time in seconds with msec resolution
		'"upstream": "$upstream_addr", ' # upstream backend server for proxied requests
		'"upstream_connect_time": "$upstream_connect_time", ' # upstream handshake time incl. TLS
		'"upstream_header_time": "$upstream_header_time", ' # time spent receiving upstream headers
		'"upstream_response_time": "$upstream_response_time", ' # time spend receiving upstream body
		'"upstream_response_length": "$upstream_response_length", ' # upstream response length
		'"upstream_cache_status": "$upstream_cache_status", ' # cache HIT/MISS where applicable
		'"ssl_protocol": "$ssl_protocol", ' # TLS protocol
		'"ssl_cipher": "$ssl_cipher", ' # TLS cipher
		'"scheme": "$scheme", ' # http or https
		'"request_method": "$request_method", ' # request method
		'"server_protocol": "$server_protocol", ' # request protocol, like HTTP/1.1 or HTTP/2.0
		'"pipe": "$pipe", ' # “p” if request was pipelined, “.” otherwise
		'"gzip_ratio": "$gzip_ratio", '
		'"http_cf_ray": "$http_cf_ray"'
	'}';
include /etc/nginx/upstreams/*.conf;
include /etc/nginx/maps/*.conf;


server {
    listen                      443 ssl http2;
    server_name                 *.hasti.co;
	resolver 127.0.0.11 ipv6=off valid=10s;

    location / {
        if ($request_method = 'OPTIONS') {
			add_header 'Access-Control-Allow-Origin' '*' always;
			add_header 'Access-Control-Allow-Credentials' 'true' always;
			add_header 'Access-Control-Allow-Methods' 'GET, POST, PUT, DELETE, OPTIONS' always;
			add_header 'Access-Control-Allow-Headers' 'Accept,Authorization,Cache-Control,Content-Type,Range,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Requested-With,X-Mx-ReqToken,client-name,client-version' always;
			add_header 'Access-Control-Max-Age' 1728000;
			add_header 'Content-Type' 'text/plain charset=UTF-8';
			add_header 'Content-Length' 0;
			return 204;
		}
		if ($request_method = 'POST') {
			add_header 'Access-Control-Allow-Origin' '*' always;
			add_header 'Access-Control-Allow-Credentials' 'true' always;
			add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
			add_header 'Access-Control-Allow-Headers' 'Accept,Authorization,Cache-Control,Content-Type,Range,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Requested-With,X-Mx-ReqToken,client-name,client-version' always;
			add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range' always;
		}
		if ($request_method = 'GET') {
			add_header 'Access-Control-Allow-Origin' '*' always;
			add_header 'Access-Control-Allow-Credentials' 'true' always;
			add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS' always;
			add_header 'Access-Control-Allow-Headers' 'Accept,Authorization,Cache-Control,Content-Type,Range,DNT,If-Modified-Since,Keep-Alive,Origin,User-Agent,X-Requested-With,X-Mx-ReqToken,client-name,client-version' always;
			add_header 'Access-Control-Expose-Headers' 'Content-Length,Content-Range' always;
		}
		proxy_hide_header Access-Control-Allow-Origin;
		add_header 'Access-Control-Allow-Origin' '*' always;
		proxy_http_version 1.1;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection keep-alive;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
		proxy_pass         http://$backend;
	}

	# logs
	
	access_log /dev/stdout main_json buffer=32k;
	error_log /dev/stdout info;

	# ssl
	ssl_session_timeout 180m;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384;
	ssl_certificate /etc/nginx/certs/nginx_bundle.crt;
	ssl_certificate_key /etc/nginx/certs/privkey.pem;
}

