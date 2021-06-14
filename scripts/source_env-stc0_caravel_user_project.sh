#!/bin/bash

#export CARAVEL_ROOT=../caravel-lite
#echo "CARAVEL_ROOT=$CARAVEL_ROOT"
# specify simulation mode: RTL/GL
#export SIM=RTL
export OPENLANE_ROOT=/home/rfriesen/prj/mpw20210618/OpenLane
echo "OPENLANE_ROOT=$OPENLANE_ROOT"
export OPENLANE_TAG=v0.15
echo "OPENLANE_TAG=$OPENLANE_TAG"
export PDK_ROOT=$OPENLANE_ROOT/pdks
echo "PDK_ROOT=$PDK_ROOT"
export PRECHECK_ROOT=/home/rfriesen/prj/mpw20210618/open_mpw_precheck
echo "PRECHECK_ROOT=$PRECHECK_ROOT"

case $HOSTNAME in
  (bpre012) USE_ROOTLESS_DOCKER="1"; echo "$HOSTNAME: Using rootless Docker";;
  (sgl-lap054) USE_ROOTLESS_DOCKER="1"; echo "$HOSTNAME: Using rootless Docker";;
  (*)   echo "$HOSTNAME: Using regular (rooted) Docker";;
esac
