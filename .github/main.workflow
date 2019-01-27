workflow "New workflow" {
  on = "push"
  resolves = ["push"]
}

action "login" {
  uses = "actions/docker/login@c08a5fc9e0286844156fefff2c141072048141f6"
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]
}

action "build" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["login"]

  args = "build -t my_image ."
}

action "tag" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["build"]

  args = "tag my_image awseward/try_docker_actions:$GITHUB_SHA"
}

action "push" {
  uses = "actions/docker/cli@c08a5fc9e0286844156fefff2c141072048141f6"
  needs = ["tag"]
  secrets = ["DOCKER_USERNAME", "DOCKER_PASSWORD"]

  args = ["push awseward/try_docker_actions:$GITHUB_SHA"]
}
