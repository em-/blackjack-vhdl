GHDL=ghdl
GHDLFLAGS= --ieee=synopsys
GHDLRUNFLAGS= --stop-time=50ns

TESTBENCHES=tb_or2 tb_or3 tb_and2 tb_ha tb_fa tb_rca \
            tb_mux21 tb_mux21_1bit tb_mux41 tb_mux41_1bit tb_comparator \
            tb_fd tb_ft tb_reg tb_ld tb_latch tb_counter tb_accumulator \
            tb_display_simulator tb_shift_reg tb_display_controller \
			tb_fsm tb_bcd_encoder tb_game_logic \
			tb_blackjack

# Default target
all: run

# Testbenches dependencies
tb_or2: or2.o tb_or2.o
tb_or3: or3.o tb_or3.o
tb_and2: and2.o tb_and2.o
tb_ha: ha.o tb_ha.o
tb_fa: fa.o tb_fa.o
tb_mux21: mux21.o tb_mux21.o
tb_mux21_1bit: mux21_1bit.o tb_mux21_1bit.o
tb_mux41: mux41.o tb_mux41.o
tb_mux41_1bit: mux41_1bit.o tb_mux41_1bit.o
tb_comparator: comparator.o tb_comparator.o
tb_rca: rca.o tb_rca.o
tb_fd: fd.o tb_fd.o
tb_ft: ft.o tb_ft.o
tb_reg: reg.o tb_reg.o
tb_ld: ld.o tb_ld.o
tb_latch: latch.o tb_latch.o
tb_counter: counter.o tb_counter.o
tb_accumulator: accumulator.o tb_accumulator.o
tb_display_simulator: display_simulator.o tb_display_simulator.o
tb_shift_reg: shift_reg.o tb_shift_reg.o
tb_display_controller: display_controller.o tb_display_controller.o
tb_fsm: fsm.o tb_fsm.o
tb_bcd_encoder: bcd_encoder.o tb_bcd_encoder.o
tb_game_logic: game_logic.o tb_game_logic.o
tb_blackjack: blackjack.o tb_blackjack.o

comparator.o: fa.o
rca.o: fa.o
reg.o: fd.o
latch.o: ld.o
counter.o: ha.o fd.o
accumulator.o: mux21.o rca.o reg.o
display_simulator.o: seven_segment_dot.o
shift_reg.o: fd.o
display_controller.o: shift_reg.o mux21_1bit.o mux41_1bit.o
blackjack.o: reg.o rca.o game_logic.o fsm.o bcd_encoder.o
display.o: sevensegment_encoder.o mux21.o display_controller.o


# Elaboration target
$(TESTBENCHES):
	$(GHDL) -e $(GHDLFLAGS) $@

# Targets to analyze files
%.o: */%.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

# Syntax check target
check:
	$(GHDL) -s $(GHDLFLAGS) */*.vhdl

# Run target
run: $(TESTBENCHES) 
	for i in $^; do echo $$i; $(GHDL) -r $$i $(GHDLRUNFLAGS); done

# Clean target
clean:
	-ghdl --remove
