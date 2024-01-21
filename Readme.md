## How to get this running

1. If Consul and Nomad are already running (or you want them to run for testing), skip the below steps.
    i. Start Consul in dev mode `sudo consul agent -dev -ui -data-dir /tmp/consul -config-file=consul-agent-config.hcl`
    ii. Start Nomad in dev mode `sudo nomad agent -dev-connect -config=nomad-server-config.hcl`. Will start both Nomad server and client.
2. Create appropriate [ACL Token](https://developer.hashicorp.com/consul/tutorials/security/access-control-setup-production) for services to be deployed i.e. Nomad servers, Nomad clients, Consul servers, Consul clients, Example Apps, etc.
3. Deployment of API-GW requires and image with both Consul and Envoy, build an image using the Dockerfile in this repo and push it to a registry.
4. Write proxy-defaults and service-defaults in Consul. (If you don't have configs defined for each service and proxy already).
    i. Use files proxy-defaults.hcl and service-defaults.hcl in this repo.
5. Start API-GW, following instructions below.
    i. Look at the api-gateway-docker.nomad.hcl file in this repo.
    ii. Edit the ports and Consul address appropriately.
    iii. Run `nomad run api-gateway-docker.nomad.hcl`
    iv. Check Nomad UI, you should see the job running.
    v. Check Consul UI, you should see the API-GW registered.
6. Start example-app, following instructions below.
    i. Look at the hello-app-golang-docker.nomad.hcl file in this repo.
    ii. Edit the ports and Consul address appropriately.
    iii. Run `nomad run hello-app-golang-docker.nomad.hcl`
    iv. Check Nomad UI, you should see the job running.
    v. Check Consul UI, you should see the example-app registered.
7. Add intentions to allow traffic from API-GW to example-app.
    i. Use file rest-api-intentions.hcl in this repo.
    ii. Run `consul config write rest-api-intentions.hcl`
8. Register listener for API-GW.
    i. Use file gateway-listeners.hcl in this repo.
    ii. Run `consul config write gateway-listeners.hcl`
9. Register http routes for API-GW. So, that Envoy knows how and where to write the traffic.
    i. Use file my-http-route.hcl in this repo.
    ii. Run `consul config write my-http-route.hcl`.
10. Test the API-GW.
    i. Run `curl -v http://<api-gw-address>:<api-gw-port>/hello`
    ii. You should see the response from hello-app.
11. For additional debugging, you could dive into Envoy configs through envoy admin url, nomad job logs and consul catalog service definition.