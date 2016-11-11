//-----------------------------------------------------------------------------
// Original Author: Alina Ivanova
// email: alina.al.ivanova@gmail.com
// web: www.alinaivanovaoff.com
// template_test_program.sv
// Created: 10.26.2016
//
// Program for Template Testbench.
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
program template_test_program import settings_pkg::*; (
    interface ICKData,
    interface ICKResult);
//-----------------------------------------------------------------------------
    logic [FULL_SIZE-1:0]                              data_gm_fifo[$] = '{10};
    logic [FULL_SIZE-1:0]                              data;
    logic [FULL_SIZE-1:0]                              input_data;
    logic                                              enable;
//-----------------------------------------------------------------------------
    assign ICKData.data_input                          = data_i;
    assign ICKData.enable                              = enable;
//-----------------------------------------------------------------------------
    initial begin: TEMPLAT_TEST_PROGRAM_INITIAL
        $display("Running program");
        input_data                                     = 0;
        enable                                         = 0;
        @(posedge ICKData.reset);
//        $display("After reset");
        #12;
        input_data                                     = 10;
        enable                                         = 1;
//-----------------------------------------------------------------------------
        fork
            begin
                while (data_gm_fifo.size() != 0) begin
//                    $display("Inside cycle");
//                    $stop;
                    @(posedge ICKData.clk);
//                    $display("Inside clk");
//                    $stop;
                    if (ICKResult.output_data_valid) begin
//                        $display("Inside if");
//                        $stop;
                        data                            = data_gm_fifo.pop_front();
//                        $display("After amp_gm_fifo");
//                        $stop;
                        if ((data - ICKResult.output_data) != 0) begin
                            $display("Error! Expetcted DATA %b != received DATA %b", data, ICKResult.output_data);
                        end
                    end
                end
                $display("Test finished.");
                $stop;
            end
            begin
                while ($time < 800) begin
                    @(posedge ICKData.clk);
                end
                $display("Timeout!");
                $stop;
            end
        join_any
    end: TEMPLATE_TEST_PROGRAM_INITIAL
//-----------------------------------------------------------------------------
endprogram: template_test_program
