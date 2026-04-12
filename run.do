vlib work
vlog spi_slave_interface.v mem.v wrapper.v SPI_tb.v
vsim -voptargs=+acc work.spi_tb

add wave *
add wave -position insertpoint \
sim:/spi_tb/dut/spi/rx_counter \
sim:/spi_tb/dut/spi/rx_data \
sim:/spi_tb/dut/spi/rx_valid \
sim:/spi_tb/dut/spi/tx_counter \
sim:/spi_tb/dut/spi/tx_data \
sim:/spi_tb/dut/spi/tx_valid

add wave -position insertpoint \
sim:/spi_tb/dut/RAM/write_addr
add wave -position insertpoint  \
sim:/spi_tb/dut/RAM/read_addr

add wave -position insertpoint  \
sim:/spi_tb/dut/spi/flag

add wave -position insertpoint  \
sim:/spi_tb/dut/spi/cs

add wave -position insertpoint  \
sim:/spi_tb/dut/spi/tx_shift


add wave -position insertpoint \
sim:/spi_tb/dut/RAM/mem_array

run -all