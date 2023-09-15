vlib work
vlog DSP48A1.v DSP_tb.v
vsim -voptargs=+acc work.DSP_tb
add wave *
run -all