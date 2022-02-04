job "example-periodic-failure" {

  datacenters = ["eu-west-1a"]
  type = "batch"

  periodic {
    cron             = "* * * * * *"
    prohibit_overlap = true
  }

  task "main" {
    driver = "exec"

    config {
      command = "echo"
      args    = ["hello world"]
    }

    resources {
      cpu    = 100
      memory = 128
    }
  }
}
