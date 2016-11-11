//-----------------------------------------------------------------------------
// Original Author: Alina Ivanova
// Contact Point: Alina Ivanova (alina.al.ivanova@gmail.com)
// tempalte_testbench.sv
// Created: 11.01.2016
//
// Testbench for tempalte.sv.
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
//`include "settings_pkg.sv"
`include "interfaces_pkg.sv";
`include "template_test_program.sv"
//-----------------------------------------------------------------------------
module template_testbench ();
//-----------------------------------------------------------------------------
// Variable declarations
//-----------------------------------------------------------------------------
    logic                                                 clk;
    logic                                                 reset;
//-----------------------------------------------------------------------------
    template_data_intf ICKData (
        .clk                                              (clk),
        .reset                                            (reset));
//-----------------------------------------------------------------------------
    template_result_intf ICKResult ();
//-----------------------------------------------------------------------------
// Function Section
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
// Process Section
//-----------------------------------------------------------------------------
    initial begin: TEMPLATE_TESTBENCH_INITIAL
        $display("Running testbench");
        reset                                             = 0;
        clk                                               = 0;
        #4  reset                                         = 1;
    end: TEMPLATE_TESTBENCH_INITIAL
//-----------------------------------------------------------------------------
    always begin: TEMPLATE_TESTBENCH_CLK
        #2 clk                                            = ~clk;
    end: TEMPLATE_TESTBENCH_CLK
//-----------------------------------------------------------------------------
// Sub Module Section
//-----------------------------------------------------------------------------
    template Template (
        .clk                                              (clk),
        .reset                                            (reset),
//-----------------------------------------------------------------------------
        .input_data                                       (ICKData.input_data),
        .enable                                           (ICKData.enable),
//-----------------------------------------------------------------------------
        .output_data                                      (ICKResult.output_data),
        .output_data_valid                                (ICKResult.output_data_valid));
//-----------------------------------------------------------------------------
// Program Section
//-----------------------------------------------------------------------------
    template_test_program TemplateTestProgram (
        .ICKData   (ICKData.master),
        .ICKResult (ICKResult.slave));
//-----------------------------------------------------------------------------
endmodule: template_testbench