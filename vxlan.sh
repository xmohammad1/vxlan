install_iproute() {
    sudo apt install -y iproute2 bridge-utils
}

Iran() {
    SERVER_IP=$(hostname -I | awk '{print $1}')
    echo "Iran IP: $SERVER_IP"
    read -p "Enter Kharej Public IP: " remote_ip
    sudo ip link add vxlan0 type vxlan id 10 dev eth0 remote $remote_ip dstport 4789
    sudo ip addr add 10.0.0.1/24 dev vxlan0
    sudo ip link set up vxlan0
    echo "VXLAN interface for Iran configured."
    echo "Iran VXLAN IP: 10.0.0.1"
}

kharej() {
    SERVER_IP=$(hostname -I | awk '{print $1}')
    echo "Kharej IP: $SERVER_IP"
    read -p "Enter Iran Public IP: " remote_ip
    sudo ip link add vxlan0 type vxlan id 10 dev eth0 remote $remote_ip dstport 4789
    sudo ip addr add 10.0.0.2/24 dev vxlan0
    sudo ip link set up vxlan0
    echo "VXLAN interface for kharej configured."
    echo "Kharej VXLAN IP: 10.0.0.2"
}
remove_full() {
    sudo ip link set down vxlan0
    sudo ip link delete vxlan0
    echo "VXLAN interface removed."
}
while true; do
  echo ""
  echo "1) Iran"
  echo "2) kharej"
  echo "3) Remove Completely"
  echo "9) Back"
  read -p "Enter your choice: " choice

  case $choice in
    1)
      install_iproute
      Iran
      ;;
    2)
      install_iproute
      kharej
      ;;
    3)
      remove_full
      ;;
    9)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac
done
