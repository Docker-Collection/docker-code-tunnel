# Docker Workspace

This is my personal use [Remote Tunnel](https://code.visualstudio.com/docs/remote/tunnels), you will need a GitHub account to set up this.

If you need a self-host version, not using vscode.dev, you can check out [linuxserver/docker-code-server](https://github.com/linuxserver/docker-code-server).

## Docker Compose

If you see permission error, then you must ``chown -R $(whoami):$(whoami) volume_path``.

After you startup container, using ``docker compose logs`` to setup workspace!

```yaml
version: "3"

services:
  workspace:
    hostname: workspace
    container_name: workspace
    image: ghcr.io/docker-collection/workspace:latest
    volumes:
      - "./path:/home/ubuntu"
    environment:
      - SUDO_PASSWORD=1234567890
    restart: always
```
