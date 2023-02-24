#!/bin/sh

control_plane_name=$1

kubectl cordon $control_plane_name && \
    kubectl drain $control_plane_name --ignore-daemonsets --delete-emptydir-data && \
    sudo systemctl stop kubelet && \
    sudo reboot




