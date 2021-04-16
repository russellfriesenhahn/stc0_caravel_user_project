<!---
# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
-->

# Caravel User Project
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) [![CI](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_example_ci.yml/badge.svg)](https://github.com/efabless/caravel_project_example/actions/workflows/caravel_example_ci.yml)

# Overview

This repo contains a sample user project that utilizes the [caravel](https://github.com/efabless/caravel.git) chip user space. The user project is a simple counter that showcases how to make use of [caravel's](https://github.com/efabless/caravel.git) user space utilities like IO pads, logic analyzer probes, and wishbone port. The repo also demonstrates the recommended structure for the open-mpw shuttle projects. 

# Caravel Integration

## Files Integration

Caravel files are kept separate from the user project by having caravel as submodule. The submodule commit should point to the latest of caravel master. The following files should have a symbolic link to [caravel's](https://github.com/efabless/caravel.git) corresponding files: 

- [Root Makefile](Makefile): This is to make sure that you adhere to the required implementation of the `compress` and `uncompress` targets. Also, [caravel's](https://github.com/efabless/caravel.git) Makefile provides useful targets like running `lvs`, `drc`, and `xor` checks. Run `make help` to display the available targets. 

- [Openlane Makefile](openlane/Makefile): This provides an easier way for running openlane to harden your macros. Refer to [ Hardening the User Project Macro]. Also, the makefile retains the openlane summary reports under the signoff directory. 

- [Pin order](openlane/user_project_wrapper/pin_order.cfg) file for the user wrapper: The hardened user project wrapper macro must have the same pin order specified in caravel's repo. Failing to adhere to the same order will fail the gds integration of the macro with caravel's back-end. 

To create the symbolic links run the following: 

```bash
# In case caravel is sub-moduled under the project root, export CARAVEL_ROOT=caravel
export CARAVEL_ROOT=<caravel-path> 

ln -s $CARAVEL_ROOT/Makefile  Makefile
ln -s $CARAVEL_ROOT/openlane/Makefile openlane/Makefile
ln -s $CARAVEL_ROOT/openlane/user_project_wrapper_empty/pin_order.cfg openlane/user_project_wrapper/pin_order.cfg
```

## Verilog Integration

You need to create a wrapper around your macro that adheres to the template at [user_project_wrapper](caravel/verilog/rtl/__user_project_wrapper.v). The wrapper top module must be named `user_project_wrapper` and must have the same input and output ports. The wrapper gives access to the user space utilities provided by caravel like IO ports, logic analyzer probes, and wishbone bus connection to the management SoC. 

For this sample project, the user macro makes use of: 

- The IO ports for displaying the count register values on the IO pads. 

- The LA probes for supplying an optional reset and clock signals and for setting an initial value for the count register. 

- The wishbeone port for reading/writing the count value through the management SoC. 

Refer to [user_project_wrapper](verilog/rtl/user_project_wrapper.v) for more information. 

<p align=”center”>
<img src="doc/counter_32.png" width="50%" height="10%">
</p>

# Running Full Chip Simulation

The verilog test-benches are under this [verilog/dv](verilog/dv). For more information on setting up the simulation environment and the available testbenches for this sample project, refer to [README] (verilog/dv/README.md).

# Hardening the User Project Macro using Openlane 

For instructions on how to install openlane and the pdk refer to [README](https://github.com/efabless/openlane/blob/master/README.md). 

There are two options for hardening the user project macro using openlane: 

1. Hardening the user macro, then embedding it in the wrapper
2. Flattening the user macro with the wrapper. 

For more details on this, refer to this [README](caravel/blob/master/openlane/README.rst).

For this sample project, we went for the first option where the user macro is hardened first, then it is inserted in the user project wrapper. 

<p align=”center”>
<img src="doc/wrapper.png" width="30%" height="5%">
</p>

To reproduce hardening this project, run the following: 

```bash
export OPENLANE_TAG=v0.12
cd openlane
# Runs openlane to harder user_proj_example
make user_proj_example
# Runs openlane to harder user_project_wrapper
make user_project_wrapper
```

# Checklist for Open-MPW Submission

- [x] The project repo adheres to the same directory structure in this repo.
- [x] The project repo contain info.yaml at the project root. 
- [x] Top level macro is named `user_project_wrapper`. 
- [x] Full Chip Simulation passes for RTL and GL (gate-level)
- [x] The hardened Macros are LVS and DRC clean
- [x] The hardened `user_project_wrapper` adheres to the same pin order specified at [pin_order](https://github.com/efabless/caravel/blob/master/openlane/user_project_wrapper_empty/pin_order.cfg)
- [x] XOR check passes with zero total difference. 
- [x] Openlane summary reports are retained under ./signoff/<macro-name> 
