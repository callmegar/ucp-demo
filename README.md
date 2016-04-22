# Docker UCP Demo
```
Prerequisites:
- Vagrant
- Ruby
```

## The architecture
This repo will build a three node UCP cluster. The base OS will be Ubuntu with a patched kernel to support the namespace for the native Docker network stack.
On the first node we will install UCP, we will then deploy a consul container which we will use as the key/value store for the Docker network "swarm-private".
The next two nodes will join the UCP cluster and set up all the tls for authentication. Then we will deploy the ELK stack with Docker Compose using interlock as the entry point.
This will all be built with Puppet. 

Grab a trial license key for Docker data centre and copy it into docker_subscription.lic

# Run the environment
```
git clone https://github.com/scotty-c/ucp-demo.git && cd ucp-demo
vagrant up
echo "172.17.10.103 elk.ucp-demo.local">>/etc/hosts

```

# Access to the UCP console
````
https://172.17.10.101

````
Username : admin
Password : orca

# Access to Kibana console
````
http://elk.ucp-demo.local/
````