#!/bin/bash

# list of design files to be compiled

ver_files=("../../source/cpu_top.v"	
	  "../../source/instruction_fetch.v"
	  "../../source/instruction_decode.v"	
	  "../../source/rename_unit.v"	
	  "../../source/reservation_station.v"	
	  "../../source/alu.v"	
	  "../../source/load_store_queue.v"	
	  "../../source/memory_unit.v"	
	  "../../source/reorder_buffer.v"	
	  "../../source/reg_file.v"	
	  "../testbench/instruction_fetch_tb.v"	
	  "../testbench/instruction_decode_tb.v"	
	  "../testbench/rename_unit_tb.v"	
	  "../testbench/reservation_station_tb.v"	
	  "../testbench/alu_tb.v"	
	  "../testbench/load_store_queue_tb.v"	
	  "../testbench/memory_unit_tb.v"	
	  "../testbench/reorder_buffer_tb.v"	
	  "../testbench/common_data_bus_tb.v"	
	  "../testbench/reg_file_tb.v"	
	  "../testbench/cpu_top_tb.v")	
