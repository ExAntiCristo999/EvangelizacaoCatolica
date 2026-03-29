qemu-system-x86_64 -drive file=corepure64.img,format=qcow2 -m 1024 -netdev user,id=net0,net=10.0.2.0/24 -device virtio-net-pci,netdev=net0 -vnc :0 -boot c
