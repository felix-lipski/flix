#!/run/current-system/sw/bin/bash -e

if [[ $# -eq 0 ]]; then
cat <<EOF
usage: re-vm <command>

Commands used with VM interaction:
state            Show  VM state
start            Start VM, update VPN endpoint, ping VM
start-instance   Start VM
hibernate        Hibernate VM
hibernate-nowait Hibernate VM without waiting for state change
stop             Stop  VM
stop-nowait      Stop  VM without waiting for state change
show             Show status
public-ip        Show public ip
update-wg        Update VPN endpoint
EOF
fi

export AWS_DEFAULT_REGION=eu-central-1
export AWS_PAGER=cat

source ~/.config/restaumatic-vm.env

INTERFACE="${WG_INTERFACE:-wg-restaumatic}"


public-ip() {
  aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r .Reservations[].Instances[].NetworkInterfaces[].Association.PublicIp
}

show() {
  aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq .Reservations[].Instances[] | less
}

state() {
  aws ec2 describe-instances --instance-ids $INSTANCE_ID | jq -r .Reservations[].Instances[].State.Name
}

stop-nowait() {
  aws ec2 stop-instances --instance-ids $INSTANCE_ID
}

hibernate-nowait() {
  aws ec2 stop-instances --instance-ids $INSTANCE_ID --hibernate
}

stop() {
  stop-nowait
  echo -n "Waiting for state 'stopped'"
  while [ "$(state)" != "stopped" ]; do
    echo -n "."
    sleep 1
  done
  echo
  echo Done.
}

hibernate() {
  hibernate-nowait
  echo -n "Waiting for state 'stopped'"
  while [ "$(state)" != "stopped" ]; do
    echo -n "."
    sleep 1
  done
  echo
  echo Done.
}

start() {
  start-instance
  update-wg
  if [[ $OSTYPE == 'darwin'* ]]; then
    ping -c 1 -t 30 10.244.1.1
  else
    ping -c 1 -w 30 10.244.1.1
  fi
}

start-instance() {
  aws ec2 start-instances --instance-ids $INSTANCE_ID
  echo -n "Waiting for state 'running'"
  while [ "$(state)" != "running" ]; do
    echo -n "."
    sleep 1
  done
  echo
  echo Done.
}

# Update VPN endpoint
update-wg() {
  sudo wg set "$INTERFACE" peer "$WG_PEER_PUBKEY" endpoint $(public-ip):51820
  sudo wg show "$INTERFACE"
}

$@
