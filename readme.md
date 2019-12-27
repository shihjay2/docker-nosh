# Docker-NOSH


## Installation
### Step 1: Preparation
1. It is recommended to use an email service to take advantage of all the features of NOSH such as message and schedule notifications.  Compatible mail serivices include [Mailgun](https://mailgun.com).
2. Make sure you have a domain name registered and linked to the WAN IP (Wide Area Network Internet Protocol) address where Docker-NOSH is connected to.  You can get a crazy cheap one ($0.88/year) at [Namecheap](https://www.namecheap.com).  They have great instructions for how to do this.
3. If your Docker-NOSH is installed physically and is behind a network router, make sure port forwarding is set on your router for ports 22 (for SSH), 80 (for HTTP), and 443 (for HTTPS) routed to the LAN IP (Local Area Network Internet Protocol) address for Docker-NOSH.

### Step 2: Download and install [Docker](https://www.docker.com/products/docker-desktop)
1. If you use Linux, install Docker based on the distribution you use such as [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/), [Fedora](https://docs.docker.com/install/linux/docker-ce/fedora/), [CentOS](https://docs.docker.com/install/linux/docker-ce/centos/), and [Arch/Manjaro](https://wiki.archlinux.org/index.php/Docker).
2. If you use Linux, install [Docker Compose](https://docs.docker.com/compose/install/#linux)

### Step 3: Download and install Git
[Git for Windows.](https://gitforwindows.org/)

[Git for Mac.](https://git-scm.com/download/mac)

[Git for Linux.](https://git-scm.com/download/linux)

### Step 4: Install Docker-NOSH
#### Windows:
1. Click the Windows or Start icon.  In the Programs list, open the Git folder.  Click the option for Git Bash.
2. <code>git clone https://github.com/shihjay2/docker-nosh.git</code>
3. <code>cd docker-nosh</code>
4. <code>./init_win.sh</code>

#### Mac:
1. Open the Applications folder. Open Utilities and double-click on Terminal.
2. <code>git clone https://github.com/shihjay2/docker-nosh.git</code>
3. <code>cd docker-nosh</code>
4. <code>./init.sh</code>

#### Linux:
1. Open a command-line terminal.
2. <code>git clone https://github.com/shihjay2/docker-nosh.git</code>
3. <code>cd docker-nosh</code>
4. <code>./init.sh</code>

## Security Vulnerabilities

If you discover a security vulnerability within NOSH-in-a-Box, please send an e-mail to Michael Chen at shihjay2 at gmail.com. All security vulnerabilities will be promptly addressed.

## License

Docker-NOSH is open-sourced software licensed under the [GNU AGPLv3 license](https://opensource.org/licenses/AGPL-3.0).
