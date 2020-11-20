Vagrant.configure("2") do |config|
  config.vm.box = "michael-slx/arch64-base"

  config.vm.provider "virtualbox" do |v|
    v.memory = 8192
    v.cpus = 8
    v.customize ["modifyvm", :id, "--accelerate3d", "off"]
  end

  config.vm.synced_folder ".", "/media/sf_vagrant", id: "vagrant", automount: true
  config.vm.disk :disk, name: "data", size: "8GB"

  config.vm.provision "shell", keep_color: true, inline: <<-SHELL
    pacman -Syyuu --noconfirm
    pacman -S --noconfirm btrfs-progs vsftpd pv sqlite3
    usermod -a -G vboxsf vagrant
  SHELL
  config.vm.provision "shell", reboot: true
  config.vm.provision "shell", path: "box.sh", privileged: false, keep_color: true
end
