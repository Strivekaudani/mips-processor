set search_path [list . $search_path} "/apps/design_kits/ibm_kits/IBM_IP/ibm_cmos8hp/std_cell/sc/v.20110613/synopsys/ss_125" "../src" "../db"]
set target_library IBM_CMOS8HP_SS125.db
set link_library { * IBM_CMOS8HP_SS125.db }
set acs_work_dir "."

set DESIGN "cpu_top"

# analyze design
analyze -format verilog { ../../source/cpu_top.v }
analyze -format verilog { ../../source/instruction_fetch.v }
analyze -format verilog { ../../source/instruction_decode.v }
analyze -format verilog { ../../source/rename_unit.v }
analyze -format verilog { ../../source/reservation_station.v }
analyze -format verilog { ../../source/alu.v }
analyze -format verilog { ../../source/load_store_queue.v }
analyze -format verilog { ../../source/memory_unit.v }
analyze -format verilog { ../../source/common_data_bus.v }
analyze -format verilog { ../../source/reorder_buffer.v }
analyze -format verilog { ../../source/reg_file.v }

# elaborate design
elaborate ${DESIGN} -architecture verilog -library DEFAULT
uniquify

# constraints
source ../constraints/constraints_${DESIGN}.tcl

# check design for issues
check_design

# compile design
compile -exact_map

#compile -map_effort high -incremental

# reports
## worst case timing paths
redirect ../reports/${DESIGN}_timing_worst.rpt {report_timing -path full -delay max -nworst 20 -max_paths 20 -significant_digits 3 -sort_by group }

redirect ../reports/${DESIGN}_area.rpt {report_area}

redirect ../reports/${DESIGN}_area_hier.rpt {report_area -hierarchy }

# write netlist
write -hierarchy -format verilog -output ../netlists/${DESIGN}_syn.v
