# Docker Guide

This guide is more of a cheat sheet to help remember what commands are useful and often used. For full / in-depth guide, refer to [Official Docker Documentation](https://docs.docker.com/).

## Table of Content

- [Docker Guide](#docker-guide)
  - [Table of Content](#table-of-content)
  - [Installation](#installation)
    - [Linux (Most Distro)](#linux-most-distro)
    - [Windows](#windows)
  - [Terms](#terms)
  - [Docker CLI](#docker-cli)
    - [Steps / Workflow](#steps--workflow)
    - [Docker CLI Command](#docker-cli-command)
  - [Docker Compose](#docker-compose)
    - [Steps](#steps)
    - [Docker Compose Commands](#docker-compose-commands)

## Installation

### Linux (Most Distro)

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

### Windows

1. Install [WSL2](../Windows/WSL2.md)
2. Download and Install Docker Desktop

   > **Notes**
   >
   > When prompted, ensure the Use WSL 2 instead of Hyper-V option on the Configuration page

## Terms

| Terms | Meaning |
|:------|:--------|
|Host / Host Machine|The OS that docker is installed on|
|Image|A file / files that contains the necessary files to run a service / container (in VM world, this can be considered as ISO)|
|Tag|A value that is commonly used to differentiate versions between images (one image can have multiple tags)|
|Container|A running Image (in VM world, this can be considered as the VM)|
|Port|Network Port Number|
|Registry / Container Registry|Sites that host container images|

## Docker CLI

Using Docker on command line.

### Steps / Workflow

1. Find Image / Create `Dockerfile`
2. Pull Image / Build Image
3. Determine network port number and other things to be exposed or bound from the container to the host (Refer to the Image's documentation)
4. Create Container (this step runs the Image)
5. Test/Use the Container

### Docker CLI Command

1. **Find Image**

    1. Open [hub.docker.com](https://hub.docker.com/search?q=)
    2. Search for the Image
    3. Copy the `docker pull [image name]` command on the top right

2. **Pull/Download Image**

    From `Official Docker Registry`

    ```bash
    docker pull <image name>[:<tag>]
    ```

    or

    ```bash
    docker pull <username>/<image name>[:<tag>]
    ```

    From `Other Third Party Registry`

    ```bash
    docker pull <ragistry url>/<usernme>/<image name>[:<tag>]
    ```

    > **Notes**
    >
    > When using insecure regitry, a config file `/etc/docker/daemon.json` need to be configured with:
    >
    > ```json
    > {
    >    "insecure-registries": ["0.0.0.0/1","128.0.0.0/2","192.0.0.0/3","224.0.0.0/4"]
    > }
    > ```
    >
    > Change the IP with the actual IP or domain name, the sample above allows all IP Addresses

3. **Create Container**

    ```bash
    docker run <image name>[:<tag>] [command]
    ```

    or more commonly used by me

    ```bash
    docker run -itd --restart unless-stopped --name <container name> -p <host>:<container> -v <host>:<container> <image name>[:<tag>] [command]
    ```

    > **Notes**
    >
    > `-d` run in background  
    > `-i -t` run interactive and tty mode (allows interaction with the container through command line) (this 2 are mostly used together)  
    > `-p <host>:<container>` binds host and container port number  
    > `-v <host>:<container>` binds host and container file / directory  
    > `-e <env>` sets continer environment variable  
    > `--restart <policy>` sets container restart policy. Can only be one of these: `always`, `unless-stopped`, `on-failure`  
    > `--rm` remove container on exit  
    > `--entrypoint <command>` override image entrypoint
    > `--privileged` uses the host network (no need to bind ports)  

4. **Container Management**

    **List All Containers**

    ```bash
    docker ps -a
    ```

    **Stop Container**

    ```bash
    docker stop <container name>
    ```

    **Remove Stopped Container**

    ```bash
    docker rm <container name>
    ```

    **Force Remove Running Container / Remove Container without Stopping**

    ```bash
    docker rm -f <container name>
    ```

    **Show Container Logs / Debug Container**

    ```bash
    docker logs [-f] <container name>
    ```

    Inspect Container

    ```bash
    docker inspect <container name>
    ```

5. Managing Images

    List All Images

    ```bash
    docker images
    ```

    Delete Image

    ```bash
    docker rmi <image name:tag / image id>
    ```

    Tag Image

    ```bash
    docker image tag <image name:tag / image id> <new image name:new tag>
    ```

6. Managing Volumes

    List All Volumes

    ```bash
    docker volume ls
    ```

    Create Volume

    ```bash
    docker volume create <volume name>
    ```

    Remove Volume

    ```bash
    docker volume rm <volume name>
    ```

    Remove All Unused Volume

    ```bash
    docker volume prune
    ```

7. Managing Networks

    List All Networks

    ```bash
    docker network ls
    ```

    Create Network

    ```bash
    docker network create <network name>
    ```

    Connect Network to Container

    ```bash
    docker network connect <network name> <container name> [--alias <network host name alias>]
    ```

    Remove Network

    ```bash
    docker network rm <network name>
    ```

    Remove All Unused Network

    ```bash
    docker network prune
    ```

## Docker Compose

A way to manage Docker Continers in a form of configuration file intead of line by line command. This allows consistent and mass deployment of Containers.

### Steps

1. Create `docker-compose.yml` configuration file
2. Run `docker-compose up -d`

### Docker Compose Commands

1. Example of `docker-compose.yml` file:

    ```yml
    --- # Just a best practices [OPTIONAL]
    version: "2.4" # Version 2.4 is mostly used for single machine setup; Version 3.8 is the latest and is mostly used for Docker Swarm setup
    services: # Must have this line
        ubuntu: # The name of the service, will also be used for interneal DNS
            image: ubuntu:latest # The image name and tag to be downloaded if unavailabel and run
            container_name: ubuntu # The container name [OPTIONAL]
            hostname: ubuntu # Add hostname [OPTIONAL]
            restart: unless-stopped # Restart Policy, can be "no", "always", "on-failure", "unless-stopped"
            environment: # Add Container Environment Variables [OPTIONAL]
                - HELLO=world
            entrypoint: /bin/bash # Override the default entrypoint [OPTIONAL]
            command: echo "${HELLO}" # Override the default command [OPTIONAL]
            networks: # Define the network connected by this container [OPTIONAL]
                ubuntu_network: # Network interface name to be connected [OPTIONAL]
            ports: # Ports to be bound with the host
                - 8080:80/tcp # Bind host port 8080 to container port 80
            volumes: # File / Directory to be bound with the host 
                - ./app_config:/config # Mount hosts's ./app_config directory to container /config directory
                - dedicated_dir:/dedicated_dir # Mount docker volume named dedicated_dir to /dedicated_dir

    networks: # List of docker networks [OPTIONAL]
        ubuntu_network: # Network interface name [OPTIONAL]
            name: ubuntu-network # Name of docker network [OPTIONAL]
            external: false # Spawn new docker network; If set to true, it will instead find the docker network with the name stated above [OPTIONAL]

    volumes: # List of docker volumes [OPTIONAL]
        dedicated_dir: # [OPTIOANL]
            name: ubuntu_docker_volume
            external: false
            driver_opts:
                o: bind 
                device: ./ubuntu_directory
                type: none
    ```

    > **Notes**
    >
    > Values that start with number, should start and ends with `"` but is not mandatory
    >
    > Template can be found [here](./compose_template)

2. Starting Docker Compose Project

   ```bash
   docker-compose [-f <path/to/docker/compose/file>] up -d
   ```

   > **Notes**
   >
   > `-d` is to start the project detached from the current terminal  
   > `-f` can be used if you did not make standard file name of `docker-compose.yml`

3. Stopping Docker Compose Project

   ```bash
   docker-compose [-f <path/to/docker/compose/file>] down
   ```

   > **Notes**
   >
   > `-d` is to start the project detached from the current terminal  
   > `-f` can be used if you did not make standard file name of `docker-compose.yml`
