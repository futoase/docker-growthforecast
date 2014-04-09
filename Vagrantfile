# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

BOX_DIR = File.expand_path("~/.box")
BOX_NAME = "CentOS-6.5-x86_64-mininal-docker"
BOX_PATH = File.expand_path("~/.box/#{BOX_NAME}.box")

if !FileTest.exists?("packer/builds")
  Dir.mkdir("packer/builds")
end

if !FileTest.exists?(BOX_PATH)
  system(%W(
    cd packer && 
    packer build template.json && 
    mkdir -p #{BOX_DIR} && 
    mv builds/#{BOX_NAME}.box #{BOX_PATH} 
  ).join(' '))
end

$stop_iptables = <<EOF
  service iptables stop
EOF

$set_docker_option = <<EOF
  grep "tcp://0.0.0.0:4243" /etc/sysconfig/docker;

  if [ "$?" -eq 1 ]; then
    sed -i -e 's@other_args=""@other_args="\-H tcp:\/\/0.0.0.0:4243"@g' /etc/sysconfig/docker;
  fi
EOF

$set_script_on_profile = <<EOF
  find /etc/profile.d -type f | grep "docker.sh"

  if [ "$?" -eq 1 ]; then
    bash -c 'echo "export DOCKER_HOST='tcp://0.0.0.0:4243'" > /etc/profile.d/docker.sh'
    chmod 0644 /etc/profile.d/docker.sh
    chown root:root /etc/profile.d/docker.sh
  fi
EOF

$restart_docker = <<EOF
  service docker restart
EOF

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_PATH

  config.vm.network "private_network", ip: "192.168.33.171"

  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--memory", "384"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision :shell, inline: $stop_iptables
  config.vm.provision :shell, inline: $set_docker_option
  config.vm.provision :shell, inline: $set_script_on_profile
  config.vm.provision :shell, inline: $restart_docker

end
