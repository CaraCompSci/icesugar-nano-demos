file = led
pcf  = io.pcf

build:
	yosys -p "synth_ice40 -top top -json $(file).json" $(file).v
	nextpnr-ice40 --pcf-allow-unconstrained --lp1k --package cm36 --json $(file).json --pcf $(pcf) --asc $(file).asc
	icepack $(file).asc $(file).bin
	





