vlib work
vmap work

vcom -work work -93 -explicit ../motion_estimation/package_motion_estimation.vhd
vcom -work work -93 -explicit ../motion_estimation/unsigned_adder_subtractor.vhd
vcom -work work -93 -explicit ../motion_estimation/sad_N.vhd
vcom -work work -93 -explicit ../motion_estimation/sad_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/sad_1.vhd
vcom -work work -93 -explicit ../motion_estimation/regNbits.vhd
vcom -work work -93 -explicit ../motion_estimation/reference_registers.vhd
vcom -work work -93 -explicit ../motion_estimation/block_registers.vhd
vcom -work work -93 -explicit ../motion_estimation/block_registers_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/processing_module.vhd
vcom -work work -93 -explicit ../motion_estimation/mux4x1.vhd
vcom -work work -93 -explicit ../motion_estimation/mux4x1_regCols.vhd
vcom -work work -93 -explicit ../motion_estimation/mux2x1.vhd
vcom -work work -93 -explicit ../motion_estimation/component_abs.vhd
vcom -work work -93 -explicit ../motion_estimation/comp_AeB.vhd
vcom -work work -93 -explicit ../motion_estimation/comp.vhd
vcom -work work -93 -explicit ../motion_estimation/reference_registers_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/control_all_processing_module.vhd
vcom -work work -93 -explicit ../motion_estimation/all_processing_module_and_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/all_processing_module.vhd
vcom -work work -93 -explicit ../motion_estimation/pm_comparator.vhd
vcom -work work -93 -explicit ../motion_estimation/comparador_3valores.vhd
vcom -work work -93 -explicit ../motion_estimation/delay_motion_vectors.vhd
vcom -work work -93 -explicit ../motion_estimation/regNbits_rst.vhd
vcom -work work -93 -explicit ../motion_estimation/memories_and_memories_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/memoria.vhd
vcom -work work -93 -explicit ../motion_estimation/memory_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/n_memories.vhd
vcom -work work -93 -explicit ../motion_estimation/init_memory_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/total_architecture.vhd 
vcom -work work -93 -explicit ../motion_estimation/mux_32x1.vhd 
vcom -work work -93 -explicit ../motion_estimation/mux_Nx1.vhd
vcom -work work -93 -explicit ../motion_estimation/buffer_memportB.vhd
vcom -work work -93 -explicit ../motion_estimation/shift_circular.vhd
vcom -work work -93 -explicit ../motion_estimation/memory_level_2.vhd
vcom -work work -93 -explicit ../motion_estimation/memory_level_2_manager.vhd
vcom -work work -93 -explicit ../motion_estimation/global_control.vhd
vcom -work work -93 -explicit ../motion_estimation/map_addr_a_circular.vhd
vcom -work work -93 -explicit ../testbench/TB_total_architecture.vhd

vsim -t 1ns -lib work TB_total_architecture

add wave -noupdate -format logic -radix binary /tb_total_architecture/clk 												
add wave -noupdate -format logic -radix binary /tb_total_architecture/reset 
add wave -noupdate -format logic -radix binary /tb_total_architecture/start_architecture 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/entrada_blk
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/dinb
#add wave -noupdate -format logic -radix binary /tb_total_architecture/flag
#add wave -noupdate -format logic -radix binary /tb_total_architecture/flag_never
#add wave -noupdate -format logic -radix binary /tb_total_architecture/i
add wave -noupdate -format literal -radix decimal /tb_total_architecture/motion_vector_x
add wave -noupdate -format literal -radix decimal /tb_total_architecture/motion_vector_y
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/best_sad
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/mems_port_a_qs
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/mems_port_b_qs
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/mems_port_b_datas
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/start_init_line 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/sig_result_mp0 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/sig_result_mp1 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/sig_result_mp2 
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/end_search
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/sig_start_comparator 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/clk
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/finished_init_memory
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/start_pm_comparator 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/start_sad_manager_mp0
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/mem_port_b_addr_choice
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/sig_sel_mux_memportb
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/map_mp0/map_reference_registers/ref_registers_data_out 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/map_mp1/map_reference_registers/ref_registers_data_out 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/map_mp2/map_reference_registers/ref_registers_data_out 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/out_mux_mem_portb 
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/sel_mux_mp
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/delay_01_mem_port_a_addr_out
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/out_muxes_memories_porta
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/portb_buffer_mp0
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/portb_buffer_mp1
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/portb_buffer_mp2
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/sel_muxes_memories
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/sig_we_reg_mp0 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/sig_we_reg_mp1 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/sig_we_reg_mp2 
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/out_muxes_memories
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/wrens_b

add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/map_mp0/map_rrm/state
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_all_processing_module/map_mp0/map_sm/state
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_control_all_processing_module/state 
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_control_all_processing_module/state_comp
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/map_memory_manager/state 
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/map_init_memory_manager/state
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_global_control/state
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/state
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/mmap_memory_level_2_manager/state
#add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_control_all_processing_module/shifts_ver_std 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_control_all_processing_module/aeb_ver 
#add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_pm_comparator/map_all_processing_module_and_manager/map_control_all_processing_module/count_shifts_ver_out
add wave -noupdate -format logic -radix binary /tb_total_architecture/start_write_buffer
add wave -noupdate -format literal -radix hexadecimal /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/mmap_memory_level_2_manager/map_memory_level_2_manager/ram
add wave -noupdate -format literal -radix hexadecimal /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/data_b_memory
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/wrens_b
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/wrens_b_init
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/wrens_b_buffer
add wave -noupdate -format literal -radix unsigned /tb_total_architecture/map_total_architecture/map_memories_and_memories_manager/mmap_memory_level_2_manager/reg_addr_out
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/start_reference_manager_fill_mp0_out
add wave -noupdate -format logic -radix binary tb_total_architecture/map_total_architecture/map_block_registers_manager/we_start_blk 
add wave -noupdate -format logic -radix binary tb_total_architecture/map_total_architecture/map_block_registers_manager/sig_we_blk 
add wave -noupdate -format literal -radix unsigned  /tb_total_architecture/map_total_architecture/map_block_registers_manager/count_out
add wave -noupdate -format logic -radix binary /tb_total_architecture/map_total_architecture/map_block_registers_manager/state
