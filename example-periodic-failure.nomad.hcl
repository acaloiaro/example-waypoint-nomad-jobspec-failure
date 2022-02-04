job "example-periodic-failure" {

  datacenters = ["dc1"]
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
