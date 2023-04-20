file = top
pcf  = io.pcf

build:
	yosys -p "synth_ice40 -top top -json $(file).json" $(file).v
	nextpnr-ice40  --lp1k --package cm36 --json $(file).json --pcf $(pcf) --asc $(file).asc
	icepack $(file).asc $(file).bin
build-raspbian:
	yosys -p "synth_ice40 -top top -blif $(file).blif" $(file).v
	arachne-pnr --device 1k --pcf-file $(pcf) --package cm36 --output-file $(file).asc $(file).blif 
	icepack $(file).asc $(file).bin
clean: 
	rm $(file).bin $(file).asc $(file).json $(file).blif
	





