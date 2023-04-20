file = top
pcf  = io.pcf

build:
	yosys -p "synth_ice40 -top top -json $(file).json" $(file).v
	nextpnr-ice40  --p -lp1k --package cm36 --json $(file).json --pcf $(pcf) --asc $(file).asc
	icepack $(file).asc $(file).bin
build-raspbian:
	yosys -p "synth_ice40 -top top -blif $(file).blif" $(file).v
	arachne-pnr --device 1k --pcf-file $(file).pcf $(file).blif -o $(file).asc
	icepack $(file).asc $(file).bin
clean: 
	rm $(file).bin $(file).asc $(file).json $(file).blif
	





