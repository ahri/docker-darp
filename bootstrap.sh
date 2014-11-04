#!/bin/bash

set -ue

if [[ $# -ne 1 ]]; then
    echo "ERROR: provide a hostname for vhosts ('foo.com' -> vhost.foo.com)" >&2
    exit 1
fi

host=$1

default_root=/usr/share/nginx/html
default_index=index.html
sites_enabled=/etc/nginx/sites-enabled


index=$default_root/$default_index

check_http()
{
    ip=$1
    port=$2
    echo "GET / HTTP/1.1\r\nHost: foo\r\n\r\n" | nc "$ip" "$port" | awk 'NR == 1 && /^HTTP\// { exit 0 } NR > 1 { exit 1 } END { if (NR == 0) { exit 1 } }'
}

write_vhost()
{
    host=$1
    name=$2
    ip=$3
    port=$4

    cat <<EOF > "$sites_enabled/$name"
server {
    listen 80;
    server_name $name.$host;
    allow 192.168.1.0/24;
    deny all;

    location / {
        proxy_pass http://$ip:$port;
    }
}
EOF
}


write_index_header()
{
    cat <<EOF > "$index"
<html>
  <body>
EOF
}

add_to_index()
{
    host=$1
    name=$2

    echo "<a href=\"http://$name.$host\">$name</a><br />" >> $index
}

write_index_footer()
{
    cat <<EOF >> "$index"
  </body>
</html>
EOF
}

write_default_vhost()
{
    cat <<EOF > "$sites_enabled/default"
server {
    listen 80 default_server;
    server_name localhost;
    root $default_root;
    index $default_index;
    allow 192.168.1.0/24;
    deny all;
}
EOF
}




write_index_header

env | awk -F':' '
/^.*_PORT_[0-9]+_TCP=/ {
    sub(/_PORT.*/, "", $1);
    name=$1

    sub(/\/\//, "", $2);
    ip=$2
    port=$3

    print name " " ip " " port;
}' | while read detail; do
    arr=($detail)
    name=$(echo ${arr[0]} | tr '[:upper:]' '[:lower:]')
    ip=${arr[1]}
    port=${arr[2]}

    check_http $ip $port || continue

    write_vhost $host $name $ip $port
    add_to_index $host $name
done

write_index_footer
write_default_vhost

/sbin/my_init
