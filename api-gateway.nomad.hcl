job "ingress" {
  type = "system"

  group "gateway" {
    network {
      port "gateway-port" {
        /* OR CHANGE THIS BASED ON YOUR CONFIG */
        static = 8443
      }
    }

    task "agent" {
      driver = "exec"

      config {
        command = "consul"
        args = [
          "connect",
          "envoy",
          "-gateway", "api",
          "-register",
          "-service", "my-api-gateway",
        ]
      }

      artifact {
        source      = "https://releases.hashicorp.com/consul/1.16.1/consul_1.16.1_linux_amd64.zip"
        destination = "local/consul"
        mode        = "file"
      }
    }
  }
}
