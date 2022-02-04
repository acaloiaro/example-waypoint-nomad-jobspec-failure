job "example-periodic-failure" {

  datacenters = ["dc1"]
  type = "batch"

  periodic {
    cron             = "* * * * * *"
  }

  task "main" {
    driver = "exec"

    config {
      command = "echo"
      args    = ["hello world"]
    }
  }
}
