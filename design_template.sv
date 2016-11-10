//-----------------------------------------------------------------------------
// Original Author: Alina Ivanova
// Contact Point: Alina Ivanova (alina.al.ivanova@gmail.com), alinaivanovaoff.com
// design_template.sv
// Created: 10.26.2016
//
// Design File Template.
//
//-----------------------------------------------------------------------------
// Copyright (c) 2016 by Alina Ivanova
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//-----------------------------------------------------------------------------
`timescale 1 ns / 1 ps
//----------------------------------------------------------------------------- 
`include "settings_pkg.sv"
//-----------------------------------------------------------------------------
module design_template import settings_pkg::*;(
//-----------------------------------------------------------------------------
// Input Ports
//-----------------------------------------------------------------------------
    input  wire                                           clk,
    input  wire                                           reset,
//-----------------------------------------------------------------------------
    input  wire        [DATA_SIZE-1:0]                    input_data,
    input  wire                                           enable,
//-----------------------------------------------------------------------------
// Output Ports
//-----------------------------------------------------------------------------
    output reg  signed [FULL_SIZE-1:0]                    output_data);
//-----------------------------------------------------------------------------
// Signal declarations
//-----------------------------------------------------------------------------
    reg                                                   reset_synch;
    reg                [2:0]                              reset_z;
//-----------------------------------------------------------------------------
    reg signed         [FULL_SIZE-1:0]                    shift_reg  [SHIFT_REG_SIZE];
//-----------------------------------------------------------------------------
// Function Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Sub Module Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Signal Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Process Section
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: DESIGN_TEMPLATE_RESET_SYNCH
        reset_z                                          <= {reset_z[1:0], reset};
        reset_synch                                      <= (reset_z[1] & (~reset_z[2])) ? '1 : '0 ;
    end: DESIGN_TEMPLATE_RESET_SYNCH
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: DESIGN_TEMPLATE_SHIFT_REG
        if (reset_synch) begin
            for (int i = 0; i < SHIFT_REG_SIZE; i++) begin
                shift_reg[i]                             <= '0;
            end
        end else begin
             shift_reg[0]                                 <= (input_data[DATA_SIZE-1]) ? {{EXTRA_BITS{1'b1}}, input_data} : {{EXTRA_BITS{1'b0}}, input_data};
            for (int i = 1; i < SHIFT_REG_SIZE; i++) begin
                shift_reg[i]                             <= shift_reg[i-1];
            end
        end
    end: DESIGN_TEMPLATE_SHIFT_REG
//-----------------------------------------------------------------------------
    always_ff @(posedge clk) begin: DESIGN_TEMPLATE_OUTPUT_DATA
        if (reset_synch) begin
            output_data                                  <= '0;
        end else begin
            output_data                                  <= enable ? shift_reg[SHIFT_REG_SIZE-1] : '0;
        end
    end: DESIGN_TEMPLATE_OUTPUT_DATA
//-----------------------------------------------------------------------------
endmodule: design_template