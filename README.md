# workspace

Docker container for my day-to-day tasks.

This container is built of Fedora 30 with the packages I use installed. When
using this build, it is best to build your own image that uses the UID and
GID you are currently using on your host system. Then, you can share your
home directory with the container. The container also expects that the
docker socket be shared with the host. All of this is handled by the
Makefile.

Interaction with this container is done via make:

```bash
# Build the image
make build

# Remove existing containers
make clean

# Remove existing images
make clean_image

# Create a container from the image with appropriate mounts and options
make run

# Join the running container
make join

# Start the stopped container
make start

# Stop the running containers
make stop

# Get a root shell in the container
make root
```
