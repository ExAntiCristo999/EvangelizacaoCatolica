tce-load -il samba
echo -e "[global]\n\tworkgroup = SAMBA\n\tserver string = Micro Core Samba\n\tmap to guest = Bad User\n\tlog file = /var/log/samba/log.%m\n\tmax log size = 50\n\n[Compartilhado]\n\tpath = /\n\tbrowseable = yes\n\tread only = yes\n\tguest ok = yes\n\tcreate mask = 0755" | sudo tee /usr/local/etc/samba/smb.conf
sudo /usr/local/etc/init.d/samba restart
