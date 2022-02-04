project = "example-periodic-failure"

app "main" {
  build {
    use "docker" {}
  }

  deploy {
    use "nomad-jobspec" {
      jobspec = templatefile("${path.app}/example-periodic-failure.nomad.hcl")
    }
  }
}
