# vProfile on Vagrant + VMware

A learning project. I'm learning DevOps, and this is my version of the **vProfile** multi-tier Java web app setup. It's fully automated with Vagrant and shell scripts, and adapted to run on **VMware Workstation** instead of VirtualBox.

One `vagrant up` creates five VMs and installs and configures the whole stack.

## The stack

```
Browser → Nginx (web01) → Tomcat (app01) → MariaDB   (db01)
                                         → Memcached (mc01)
                                         → RabbitMQ  (rmq01)
```

| VM    | Service   | Role                                 | IP             |
|-------|-----------|--------------------------------------|----------------|
| web01 | Nginx     | Reverse proxy, the entry point       | 192.168.56.11  |
| app01 | Tomcat 10 | Runs the Java app (built with Maven) | 192.168.56.12  |
| db01  | MariaDB   | Database                             | 192.168.56.15  |
| mc01  | Memcached | Database cache                       | 192.168.56.14  |
| rmq01 | RabbitMQ  | Message broker                       | 192.168.56.16  |

web01 runs Ubuntu 22.04. The other four run CentOS Stream 9.

## Requirements

- VMware Workstation
- [Vagrant](https://developer.hashicorp.com/vagrant/install) and the [Vagrant VMware Utility](https://developer.hashicorp.com/vagrant/install/vmware)
- Vagrant plugins:
  ```bash
  vagrant plugin install vagrant-vmware-desktop vagrant-hostmanager
  ```
- About 4 GB of free RAM

## Run it

From a terminal **run as Administrator** (the hostmanager plugin adds the VM names to your hosts file):

```bash
vagrant up
```

The first run takes a while, because it downloads the VM images and builds the app with Maven. When it finishes, give Tomcat a minute or two to start, then open **http://192.168.56.11** and log in with `admin_vp` / `admin_vp`.

```bash
vagrant halt        # stop all VMs
vagrant destroy -f  # delete all VMs
```

## What I changed from the original

- **VirtualBox → VMware:** switched the provider and replaced the VM images with ones that have VMware builds.
- **Memcached:** listens on IPv4 only (`-l 0.0.0.0`). IPv6 is disabled on this CentOS image, so the default `-l 127.0.0.1,::1` stopped the service from starting.
- **RabbitMQ:** installs Erlang 24 from the RabbitMQ repo. Erlang 26 from EPEL made RabbitMQ 3.9 crash on every connection.
- **Tomcat:** copies files with `cp` instead of `rsync`.
- Removed scripts that weren't used.

## Note

The passwords in these scripts (`admin123`, `test` / `test`, `admin_vp`) are lab defaults. This setup is for local learning only.
