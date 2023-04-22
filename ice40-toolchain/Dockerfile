# Set the base image to Ubuntu
FROM ubuntu:23.04

# Add any additional packages or modifications here
# For example, you can update the package list and install packages like curl and nano
RUN apt-get update && apt-get install -y \
    curl \
    nano \
    yosys \
    nextpnr-ice40 \
    git
    

# Set the working directory
WORKDIR /app

# Copy your application files to the image
COPY . /app

# Expose a port for your application to run on, if necessary
#EXPOSE 22

# Add a command to run your application, if necessary
# CMD ["your-command-here"]
