echo "Starting containers"

nodeapp="nodeapp"
redis="redis"
nginx="nginx"
rabbit="rabbitmq"


docker run -itd -v /srv/vagrant/docker/nodeapp/nodeapp:/home/node/nodeapp --name=nodeapp $nodeapp
sleep 1
NODEAPP_IP=$(docker inspect nodeapp | jq '.[]| .NetworkSettings.Networks.bridge.IPAddress' | awk '{{gsub(/\"/, "")}; print $0}')
NODEAPP_PORT=$(docker inspect nodeapp | jq '.[]| .NetworkSettings.Ports | keys[]' | awk '{{gsub(/\/tcp/, "")}; {gsub(/\"/, "")}; print $0}')
echo "$nodeapp container running on $NODEAPP_IP:$NODEAPP_PORT"

docker run -itd --name=redis $redis
sleep 1
REDIS_IP=$(docker inspect redis | jq '.[]| .NetworkSettings.Networks.bridge.IPAddress' | awk '{{gsub(/\"/, "")}; print $0}')
REDIS_PORT=$(docker inspect redis | jq '.[]| .NetworkSettings.Ports | keys[]' | awk '{{gsub(/\/tcp/, "")}; {gsub(/\"/, "")}; print $0}')
echo "$redis container running on $REDIS_IP:$REDIS_PORT"

echo "Populating the configuration file for nginx"
/srv/vagrant/scripts/populate_variables.sh $NODEAPP_IP $NODEAPP_PORT

docker run -p 0.0.0.0:80:80 -itd --name=nginx $nginx 
sleep 1
NGINX_IP=$(docker inspect nginx | jq '.[]| .NetworkSettings.Networks.bridge.IPAddress' | awk '{{gsub(/\"/, "")}; print $0}')
NGINX_PORT=$(docker inspect nginx | jq '.[]| .NetworkSettings.Ports | keys[]' | awk '{{gsub(/\/tcp/, "")}; {gsub(/\"/, "")}; print $0}')
for i in $NGINX_PORT; do echo "$nginx container running on $NGINX_IP:$i"; done

docker run -d --hostname rabbitmq --name rabbitmq -p 0.0.0.0:15672:15672 rabbitmq
sleep 1
RABBIT_IP=$(docker inspect rabbitmq | jq '.[]| .NetworkSettings.Networks.bridge.IPAddress' | awk '{{gsub(/\"/, "")}; print $0}')
RABBIT_PORT=$(docker inspect rabbitmq | jq '.[]| .NetworkSettings.Ports | keys[]' | awk '{{gsub(/\/tcp/, "")}; {gsub(/\"/, "")}; print $0}')
echo "$rabbit container running on $RABBIT_IP:$RABBIT_PORT"
