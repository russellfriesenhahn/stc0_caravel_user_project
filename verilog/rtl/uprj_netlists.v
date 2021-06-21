// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

// Include caravel global defines for the number of the user project IO pads 
`include "defines.v"
`define USE_POWER_PINS

`ifdef GL
    // Assume default net type to be wire because GL netlists don't have the wire definitions
    `default_nettype wire
    `include "gl/user_project_wrapper.v"
    `include "gl/user_proj_example.v"
    `include "gl/stc0_core.v"
    `include "gl/lfsr32.v"
`else
    `include "user_project_wrapper.v"
    `include "user_proj_example.v"
    `include "lfsr32.v"
    `include "rstSync.v"
    `include "lfsr32stc0.v"
    `include "stc0_addrMap.vh"
    `include "crc32reg.v"
    `include "byteIngressCmdProcessor.v"
    `include "crc32.v"
    `include "egressStage.v"
    `include "multiplier.v"
    `include "oneWordFifo.v"
    `include "spram.v"
    `include "stc0butterfly.v"
    `include "stc0_core.v"
    `include "stc0Ctrl.v"
    
`endif
