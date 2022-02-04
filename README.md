# About

This is a demonstration of a `waypoint deploy` bug resulting in successful Periodic Nomad Jobspecs deployments marked as failures.

Periodic Nomad Jobspec deployments result in the following message on the CLI

> ! No evaluation with id "" found

# Reproduce

With a working waypoint/nomad environment, run the following in this directory:

`waypoint up`

After running `waypoint up`, the end result is a job that successfully deploys to Nomad and is running as expected. However, Waypoint considers the deployment a failure. This failure also brings a different waypoint issue to light, which prevents failed deployments from being destroyed: https://github.com/hashicorp/waypoint/issues/533

### Confirm the job is deployable and produces expected `hello world` output

```
$ nomad alloc logs $(nomad job periodic force example-periodic-failure | grep Allocation | awk '{print $3}' | sed s/\"//g )
$ hello world
```

# Example app status output, indicating `ERROR` Lifecycle state

## Lifecycle state after deployment

```
waypoint status -plain -app=main
Current status for application "main" in project "example-periodic-failure" in server context "waypoint.dev.eu-west-1.bkcoincapital.com:9701".

» Application Summary
APP     WORKSPACE       DEPLOYMENT STATUS       DEPLOYMENT CHECKED      RELEASE STATUS  RELEASE CHECKED
main    default         N/A                                             N/A

» Deployment Summary
APP NAME        VERSION WORKSPACE       PLATFORM        ARTIFACT        LIFECYCLE STATE
main            v5      default         nomad-jobspec   id:3            ERROR
```


## Deploy with verbose logging
```
waypoint deploy -plain -vv                                                                                                                1 ↵
2022-02-03T16:19:51.052-0800 [INFO]  waypoint: waypoint version: full_string="v0.7.1 (062857d16)" version=v0.7.1 prerelease="" metadata="" revision=062857d16
2022-02-03T16:19:51.052-0800 [DEBUG] waypoint: home configuration directory: path=/home/adriano/.config/waypoint
2022-02-03T16:19:51.052-0800 [INFO]  waypoint.server: attempting to source credentials and connect
2022-02-03T16:19:51.052-0800 [DEBUG] waypoint.serverclient: connection information: address=<REDACTED>:9701 tls=true tls_skip_verify=true send_auth=true has_token=true
2022-02-03T16:19:51.913-0800 [DEBUG] waypoint.server: connection established with sourced credentials
2022-02-03T16:19:52.163-0800 [INFO]  waypoint: server version info: version=v0.7.1 api_min=1 api_current=1 entrypoint_min=1 entrypoint_current=1
2022-02-03T16:19:52.163-0800 [INFO]  waypoint: negotiated api version: version=1
2022-02-03T16:19:52.163-0800 [DEBUG] waypoint: will operate on app: name=main

» Deploying main...
2022-02-03T16:19:52.670-0800 [DEBUG] waypoint.setupLocalJobSystem: determining if a local or remote runner should be used for this and future jobs
2022-02-03T16:19:52.904-0800 [DEBUG] waypoint: Remote operations are disabled for this project - operation cannot occur remotely
2022-02-03T16:19:52.904-0800 [DEBUG] waypoint: starting runner to process local jobs
2022-02-03T16:19:52.904-0800 [DEBUG] waypoint.runner: Created runner: id=01FV11M1Y8F2PND65B201B8NF7
2022-02-03T16:19:52.904-0800 [DEBUG] waypoint.runner: registering runner
2022-02-03T16:19:52.904-0800 [DEBUG] waypoint.runner: runner registered, waiting for first config processing
2022-02-03T16:19:53.119-0800 [INFO]  waypoint.runner.config_recv: new configuration received
2022-02-03T16:19:53.119-0800 [DEBUG] waypoint.runner.watch_config.watchloop: new config variables received, scheduling refresh
2022-02-03T16:19:53.620-0800 [DEBUG] waypoint.runner.watch_config.watchloop: new configuration computed
2022-02-03T16:19:53.620-0800 [INFO]  waypoint.runner: runner registered with server and ready
2022-02-03T16:19:53.620-0800 [DEBUG] waypoint.setupLocalJobSystem: result: isLocal=true
2022-02-03T16:19:53.620-0800 [DEBUG] waypoint: queueing job: operation=*gen.Job_Deploy
2022-02-03T16:19:53.620-0800 [DEBUG] waypoint.runner: opening job stream
2022-02-03T16:19:53.621-0800 [INFO]  waypoint.runner: waiting for job assignment
2022-02-03T16:19:54.100-0800 [DEBUG] waypoint: opening job stream: job_id=01FV11M3ZAN76JFGTV27ESDX7D
2022-02-03T16:19:54.100-0800 [INFO]  waypoint.runner: job assignment received: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.101-0800 [INFO]  waypoint.runner: starting job execution: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.101-0800 [DEBUG] waypoint.runner: job data downloaded (or local): job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy pwd=/home/adriano/git/example-periodic-failure ref=(*gen.Job_DataSource_Ref)(nil)
2022-02-03T16:19:54.309-0800 [DEBUG] waypoint.runner: plugin search path: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=["/home/adriano/git/example-periodic-failure", "/home/adriano/git/example-periodic-failure/.waypoint/plugins", "/home/adriano/.config/waypoint/plugins", "/home/adriano/.config/.waypoint/plugins"]
2022-02-03T16:19:54.309-0800 [DEBUG] waypoint.runner: searching for plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=docker
2022-02-03T16:19:54.309-0800 [DEBUG] waypoint.runner: plugin found as builtin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=docker
2022-02-03T16:19:54.309-0800 [INFO]  waypoint.runner: register: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=docker type=Mapper nil=false
2022-02-03T16:19:54.309-0800 [INFO]  waypoint.runner: register: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=docker type=Builder nil=false
2022-02-03T16:19:54.310-0800 [DEBUG] waypoint.runner: searching for plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=nomad-jobspec
2022-02-03T16:19:54.310-0800 [DEBUG] waypoint.runner: plugin found as builtin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=nomad-jobspec
2022-02-03T16:19:54.310-0800 [INFO]  waypoint.runner: register: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=nomad-jobspec type=Platform nil=false
2022-02-03T16:19:54.310-0800 [INFO]  waypoint.runner: register: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy plugin_name=nomad-jobspec type=Mapper nil=false
2022-02-03T16:19:54.312-0800 [DEBUG] waypoint.runner.app.main: loading mapper plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy name=docker
2022-02-03T16:19:54.313-0800 [INFO]  waypoint.runner.app.main.mapper: launching plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Mapper path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "docker"]
2022-02-03T16:19:54.313-0800 [DEBUG] waypoint.runner.app.main.mapper: starting plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "docker"]
2022-02-03T16:19:54.313-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin started: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130765
2022-02-03T16:19:54.313-0800 [DEBUG] waypoint.runner.app.main.mapper: waiting for RPC address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint
2022-02-03T16:19:54.355-0800 [DEBUG] waypoint.runner.app.main.mapper.waypoint: plugin address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy @module=plugin address=/tmp/plugin3896974968 network=unix timestamp=2022-02-03T16:19:54.355-0800
2022-02-03T16:19:54.355-0800 [DEBUG] waypoint.runner.app.main.mapper: using plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy version=1
2022-02-03T16:19:54.356-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin successfully launched and connected: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.356-0800 [INFO]  waypoint.runner.app.main.mapper: initialized component: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Mapper
2022-02-03T16:19:54.356-0800 [DEBUG] waypoint.runner.app.main: no mappers advertised by plugin, closing: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy name=docker
2022-02-03T16:19:54.357-0800 [DEBUG] waypoint.runner.app.main.mapper.stdio: received EOF, stopping recv loop: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unavailable desc = error reading from server: EOF"
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin process exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130765
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main: loading mapper plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy name=nomad-jobspec
2022-02-03T16:19:54.359-0800 [INFO]  waypoint.runner.app.main.mapper: launching plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Mapper path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main.mapper: starting plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin started: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130778
2022-02-03T16:19:54.359-0800 [DEBUG] waypoint.runner.app.main.mapper: waiting for RPC address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint
2022-02-03T16:19:54.390-0800 [DEBUG] waypoint.runner.app.main.mapper.waypoint: plugin address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy @module=plugin address=/tmp/plugin3365249815 network=unix timestamp=2022-02-03T16:19:54.390-0800
2022-02-03T16:19:54.390-0800 [DEBUG] waypoint.runner.app.main.mapper: using plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy version=1
2022-02-03T16:19:54.391-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin successfully launched and connected: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.391-0800 [INFO]  waypoint.runner.app.main.mapper: initialized component: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Mapper
2022-02-03T16:19:54.391-0800 [DEBUG] waypoint.runner.app.main: no mappers advertised by plugin, closing: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy name=nomad-jobspec
2022-02-03T16:19:54.391-0800 [DEBUG] waypoint.runner.app.main.mapper.stdio: received EOF, stopping recv loop: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unavailable desc = error reading from server: EOF"
2022-02-03T16:19:54.393-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin process exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130778
2022-02-03T16:19:54.393-0800 [DEBUG] waypoint.runner.app.main.mapper: plugin exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.393-0800 [INFO]  waypoint.runner: project initialized: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy workspace=default
2022-02-03T16:19:54.393-0800 [INFO]  waypoint.runner: executing operation: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.393-0800 [WARN]  waypoint.runner.app.main: failed to prepare template variables, will not be available: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="Error decoding template data for *gen.PushedArtifact: unexpected end of JSON input"
  Performing operation locally
2022-02-03T16:19:54.509-0800 [WARN]  waypoint: unknown stream event: job_id=01FV11M3ZAN76JFGTV27ESDX7D event="&{job:{id:"01FV11M3ZAN76JFGTV27ESDX7D"  application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  target_runner:{id:{id:"01FV11M1Y8F2PND65B201B8NF7"}}  data_source:{local:{}}  deploy:{artifact:{application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  sequence:3  id:"01FV11D0W6HTCMFHZGTD3820AG"  status:{state:SUCCESS  start_time:{seconds:1643933761  nanos:105711834}  complete_time:{seconds:1643933762  nanos:65342624}}  component:{type:BUILDER  name:"docker"}  artifact:{artifact:{[type.googleapis.com/docker.Image]:{image:"waypoint.local/main"  tag:"latest"  docker:{}}}}  build_id:"01FV11CY3VBAQQ0J3P0CAVWSX3"  labels:{key:"waypoint/workspace"  value:"default"}  job_id:"01FV11CXB0D4WHQ8YG9TPQZ4SK"  preload:{}}}  state:WAITING  assigned_runner:{id:"01FV11M1Y8F2PND65B201B8NF7"}  queue_time:{seconds:1643933994  nanos:986308762}  assign_time:{seconds:1643933994  nanos:988701935}  expire_time:{seconds:1643934024  nanos:986288566}}}"
2022-02-03T16:19:54.510-0800 [WARN]  waypoint: unknown stream event: job_id=01FV11M3ZAN76JFGTV27ESDX7D event="&{job:{id:"01FV11M3ZAN76JFGTV27ESDX7D"  application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  target_runner:{id:{id:"01FV11M1Y8F2PND65B201B8NF7"}}  data_source:{local:{}}  deploy:{artifact:{application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  sequence:3  id:"01FV11D0W6HTCMFHZGTD3820AG"  status:{state:SUCCESS  start_time:{seconds:1643933761  nanos:105711834}  complete_time:{seconds:1643933762  nanos:65342624}}  component:{type:BUILDER  name:"docker"}  artifact:{artifact:{[type.googleapis.com/docker.Image]:{image:"waypoint.local/main"  tag:"latest"  docker:{}}}}  build_id:"01FV11CY3VBAQQ0J3P0CAVWSX3"  labels:{key:"waypoint/workspace"  value:"default"}  job_id:"01FV11CXB0D4WHQ8YG9TPQZ4SK"  preload:{}}}  state:RUNNING  assigned_runner:{id:"01FV11M1Y8F2PND65B201B8NF7"}  queue_time:{seconds:1643933994  nanos:986308762}  assign_time:{seconds:1643933994  nanos:988701935}  ack_time:{seconds:1643933995  nanos:438218706}  expire_time:{seconds:1643934024  nanos:986288566}}}"
2022-02-03T16:19:54.511-0800 [WARN]  waypoint: unknown stream event: job_id=01FV11M3ZAN76JFGTV27ESDX7D event="&{job:{id:"01FV11M3ZAN76JFGTV27ESDX7D"  application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  target_runner:{id:{id:"01FV11M1Y8F2PND65B201B8NF7"}}  data_source:{local:{}}  deploy:{artifact:{application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  sequence:3  id:"01FV11D0W6HTCMFHZGTD3820AG"  status:{state:SUCCESS  start_time:{seconds:1643933761  nanos:105711834}  complete_time:{seconds:1643933762  nanos:65342624}}  component:{type:BUILDER  name:"docker"}  artifact:{artifact:{[type.googleapis.com/docker.Image]:{image:"waypoint.local/main"  tag:"latest"  docker:{}}}}  build_id:"01FV11CY3VBAQQ0J3P0CAVWSX3"  labels:{key:"waypoint/workspace"  value:"default"}  job_id:"01FV11CXB0D4WHQ8YG9TPQZ4SK"  preload:{}}}  state:RUNNING  assigned_runner:{id:"01FV11M1Y8F2PND65B201B8NF7"}  queue_time:{seconds:1643933994  nanos:986308762}  assign_time:{seconds:1643933994  nanos:988701935}  ack_time:{seconds:1643933995  nanos:438218706}  config:{source:FILE}  expire_time:{seconds:1643934024  nanos:986288566}}}"
2022-02-03T16:19:54.717-0800 [INFO]  waypoint.runner.app.main.platform: launching plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Platform path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:54.718-0800 [DEBUG] waypoint.runner.app.main.platform: starting plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:54.718-0800 [DEBUG] waypoint.runner.app.main.platform: plugin started: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130790
2022-02-03T16:19:54.718-0800 [DEBUG] waypoint.runner.app.main.platform: waiting for RPC address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint
2022-02-03T16:19:54.787-0800 [DEBUG] waypoint.runner.app.main.platform.waypoint: plugin address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy address=/tmp/plugin554223416 network=unix @module=plugin timestamp=2022-02-03T16:19:54.787-0800
2022-02-03T16:19:54.787-0800 [DEBUG] waypoint.runner.app.main.platform: using plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy version=1
2022-02-03T16:19:54.788-0800 [INFO]  waypoint.runner.app.main.platform: platform plugin capable of destroy: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.788-0800 [INFO]  waypoint.runner.app.main.platform: platform plugin capable of generation ID creation: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.788-0800 [DEBUG] waypoint.runner.app.main.platform: plugin successfully launched and connected: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:54.788-0800 [INFO]  waypoint.runner.app.main.platform: initialized component: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Platform
2022-02-03T16:19:55.794-0800 [DEBUG] waypoint.runner.app.main.deploy: creating metadata on server: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.475-0800 [DEBUG] waypoint.runner.app.main.deploy: running local operation: id=01FV11M63VCDS68BDY87QDR04V job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.477-0800 [DEBUG] waypoint.runner.app.main.platform.stdio: received EOF, stopping recv loop: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unavailable desc = error reading from server: EOF"
2022-02-03T16:19:56.486-0800 [DEBUG] waypoint.runner.app.main.platform: plugin process exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130790
2022-02-03T16:19:56.486-0800 [DEBUG] waypoint.runner.app.main.platform: plugin exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.487-0800 [INFO]  waypoint.runner.app.main.platform: launching plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Platform path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:56.487-0800 [DEBUG] waypoint.runner.app.main.platform: starting plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint args=["/usr/bin/waypoint", "plugin", "nomad-jobspec"]
2022-02-03T16:19:56.487-0800 [DEBUG] waypoint.runner.app.main.platform: plugin started: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130803
2022-02-03T16:19:56.487-0800 [DEBUG] waypoint.runner.app.main.platform: waiting for RPC address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint
2022-02-03T16:19:56.552-0800 [DEBUG] waypoint.runner.app.main.platform.waypoint: plugin address: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy address=/tmp/plugin2078468760 network=unix @module=plugin timestamp=2022-02-03T16:19:56.552-0800
2022-02-03T16:19:56.552-0800 [DEBUG] waypoint.runner.app.main.platform: using plugin: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy version=1
2022-02-03T16:19:56.553-0800 [INFO]  waypoint.runner.app.main.platform: platform plugin capable of destroy: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.553-0800 [INFO]  waypoint.runner.app.main.platform: platform plugin capable of generation ID creation: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.554-0800 [DEBUG] waypoint.runner.app.main.platform: plugin successfully launched and connected: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.554-0800 [INFO]  waypoint.runner.app.main.platform: initialized component: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy type=Platform
2022-02-03T16:19:56.554-0800 [DEBUG] waypoint.runner.app.main: evaluating config vars for syncing: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:19:56.554-0800 [DEBUG] waypoint.runner.app.main: no file-based config vars, not syncing config: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
-> Initializing the Nomad client...
-> Parsing the job specification...
-> Registering job "example-periodic-failure"...
Monitoring evaluation ""
2022-02-03T16:19:59.815-0800 [WARN]  waypoint.runner.app.main.deploy: error during local operation: id=01FV11M63VCDS68BDY87QDR04V job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unknown desc = No evaluation with id "" found"
2022-02-03T16:20:00.427-0800 [DEBUG] waypoint.runner.app.main.deploy: metadata marked as complete: id=01FV11M63VCDS68BDY87QDR04V job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:20:00.428-0800 [DEBUG] waypoint.runner.app.main.platform.stdio: received EOF, stopping recv loop: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unavailable desc = error reading from server: EOF"
2022-02-03T16:20:00.435-0800 [DEBUG] waypoint.runner.app.main.platform: plugin process exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy path=/usr/bin/waypoint pid=2130803
2022-02-03T16:20:00.435-0800 [DEBUG] waypoint.runner.app.main.platform: plugin exited: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:20:00.435-0800 [DEBUG] waypoint.runner: closing project: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy
2022-02-03T16:20:00.435-0800 [DEBUG] waypoint.runner: job finished: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy error="rpc error: code = Unknown desc = No evaluation with id "" found"
2022-02-03T16:20:00.435-0800 [WARN]  waypoint.runner: error during job execution: job_id=01FV11M3ZAN76JFGTV27ESDX7D job_op=*gen.Job_Deploy err="rpc error: code = Unknown desc = No evaluation with id "" found"
2022-02-03T16:20:01.169-0800 [DEBUG] waypoint.runner: opening job stream
2022-02-03T16:20:01.169-0800 [WARN]  waypoint: unknown stream event: job_id=01FV11M3ZAN76JFGTV27ESDX7D event="&{job:{id:"01FV11M3ZAN76JFGTV27ESDX7D"  application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  target_runner:{id:{id:"01FV11M1Y8F2PND65B201B8NF7"}}  data_source:{local:{}}  deploy:{artifact:{application:{application:"main"  project:"example-periodic-failure"}  workspace:{workspace:"default"}  sequence:3  id:"01FV11D0W6HTCMFHZGTD3820AG"  status:{state:SUCCESS  start_time:{seconds:1643933761  nanos:105711834}  complete_time:{seconds:1643933762  nanos:65342624}}  component:{type:BUILDER  name:"docker"}  artifact:{artifact:{[type.googleapis.com/docker.Image]:{image:"waypoint.local/main"  tag:"latest"  docker:{}}}}  build_id:"01FV11CY3VBAQQ0J3P0CAVWSX3"  labels:{key:"waypoint/workspace"  value:"default"}  job_id:"01FV11CXB0D4WHQ8YG9TPQZ4SK"  preload:{}}}  state:ERROR  assigned_runner:{id:"01FV11M1Y8F2PND65B201B8NF7"}  queue_time:{seconds:1643933994  nanos:986308762}  assign_time:{seconds:1643933994  nanos:988701935}  ack_time:{seconds:1643933995  nanos:438218706}  complete_time:{seconds:1643934001  nanos:766542813}  config:{source:FILE}  error:{code:2  message:"No evaluation with id \"\" found"}  expire_time:{seconds:1643934024  nanos:986288566}}}"
2022-02-03T16:20:01.169-0800 [INFO]  waypoint.runner: waiting for job assignment
2022-02-03T16:20:01.170-0800 [WARN]  waypoint: job failed: job_id=01FV11M3ZAN76JFGTV27ESDX7D code=Unknown message="No evaluation with id "" found"
! No evaluation with id "" found
2022-02-03T16:20:01.170-0800 [WARN]  waypoint.runner.watch_config: exiting due to context ended
```
