vlib work
vlog spi_slave_interface.v mem.v wrapper.v SPI_tb.v
vsim -voptargs=+acc work.spi_tb
add wave *
run -all