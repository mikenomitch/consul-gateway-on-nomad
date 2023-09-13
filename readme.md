# Consul API Gateway on Nomad

## How to get this running

Write the gateway config
`consul config write gateways.hcl`

Run the Nomad job
`nomad run ./api-gateway.nomad.hcl`

Write the route
`consul config write my-http-route.hcl`

## To Do

- Figure out TLS?
