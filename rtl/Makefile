PROJ = DE10_NANO_SoC_GHRD
TOP_LEVEL_ENTITY = DE10_NANO_SoC_GHRD
QSYS = soc_system
# QSYS_COMPONENT = bypass_block_hw
PROJ_FILES = $(PROJ).qpf $(PROJ).qsf
HEADER_FILE = hps_0

FAMILY = "Cyclone V"
DEVICE = "5CSEBA6U23I7"

SRCS = 	$(wildcard ./*.sv)   \
		$(wildcard ./*.v)    \
		$(wildcard ./*.qsys)

Target: clean $(PROJ).sof smart.log

$(PROJ).sof: $(PROJ_FILES) $(QSYS).sopcinfo
	@quartus_sh --flow compile $(TOP_LEVEL_ENTITY)

$(QSYS).sopcinfo:$(QSYS).qsys
	@make ip_gen
	@make qsys

smart.log:$(PROJ_FILES)
	@quartus_sh --determine_smart_action $(PROJ) > smart.log

.PHONY: clean qsys qsys_edit first ip_gen header flash
clean:
	@rm -rf incremental_db db output_files .qsys_edit hps_isw_handoff $(QSYS) greybox_tmp
	@rm -f *.rpt *.htm *.summary hps_sdram_* *.txt *.sopcinfo *.log
	@rm -f *.done *.fit.* *.sof *.sld *.qws *.ipx *.qdf *.map.* *.pin *.jdi *.ipx *.h

first:
	@quartus_map $(PROJ)
	@quartus_sh -t $(QSYS)/synthesis/submodules/hps_sdram_p0_parameters.tcl $(PROJ)
	@quartus_sh -t $(QSYS)/synthesis/submodules/hps_sdram_p0_pin_assignments.tcl $(PROJ)

qsys:
	qsys-generate $(QSYS).qsys --synthesis=VERILOG --family=$(FAMILY) --part=$(DEVICE)

qsys_edit:
	qsys-edit $(QSYS).qsys --family=$(FAMILY) --part=$(DEVICE)

# ip_gen:
# 	@ip-make-ipx --source-directory=../qsys ---output=./$(QSYS_COMPONENT).ipx

header:
	@sopcinfo2swinfo --input=$(QSYS).sopcinfo --output=$(QSYS).swinfo
	@swinfo2header --swinfo $(QSYS).swinfo --single $(HEADER_FILE).h --module $(HEADER_FILE) --silent
	@rm -f $(QSYS).swinfo

flash:
	@quartus_pgm -m JTAG -o  "p;$(TOP_LEVEL_ENTITY).sof@2" --quiet