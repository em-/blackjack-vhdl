GHDL=ghdl
GHDLFLAGS= --ieee=synopsys
GHDLRUNFLAGS= --stop-time=20ns

SOURCES=or2/or2.vhdl or2/tb_or2.vhdl \
        or3/or3.vhdl or3/tb_or3.vhdl \
        and2/and2.vhdl and2/tb_and2.vhdl \
        ha/ha.vhdl ha/tb_ha.vhdl \
        fa/fa.vhdl fa/tb_fa.vhdl \
        mux21/mux21.vhdl mux21/tb_mux21.vhdl \
        mux21/mux21_1bit.vhdl mux21/tb_mux21_1bit.vhdl \
        rca/rca.vhdl rca/tb_rca.vhdl \
        comparator/comparator.vhdl comparator/tb_comparator.vhdl \
        fd/fd.vhdl fd/tb_fd.vhdl \
        ft/ft.vhdl ft/tb_ft.vhdl \
        reg/reg.vhdl reg/tb_reg.vhdl \
        counter/counter.vhdl counter/tb_counter.vhdl \
        accumulator/accumulator.vhdl accumulator/tb_accumulator.vhdl \
        display/vectors.vhdl display/seven_segment_dot.vhdl display/display.vhdl display/tb_display.vhdl


# Default target
all: run

# Elaboration target
tb_or2: or2.o tb_or2.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_or3: or3.o tb_or3.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_and2: and2.o tb_and2.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_ha: ha.o tb_ha.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_fa: fa.o tb_fa.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_mux21: mux21.o tb_mux21.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_mux21_1bit: mux21_1bit.o tb_mux21_1bit.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_comparator: comparator.o fa.o tb_comparator.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_rca: rca.o fa.o tb_rca.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_fd: fd.o tb_fd.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_ft: ft.o tb_ft.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_reg: fd.o reg.o tb_reg.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_counter: ha.o fd.o counter.o tb_counter.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_accumulator: fa.o fd.o mux21.o rca.o reg.o accumulator.o tb_accumulator.o
	$(GHDL) -e $(GHDLFLAGS) $@

tb_display: vectors.o seven_segment_dot.o display.o tb_display.o
	$(GHDL) -e $(GHDLFLAGS) $@


# Run target
run: tb_or2 tb_or3 tb_and2 tb_ha tb_fa tb_mux21 tb_mux21_1bit tb_comparator tb_rca tb_fd tb_ft tb_reg tb_counter tb_accumulator tb_display
	$(GHDL) -r tb_or2 $(GHDLRUNFLAGS)
	$(GHDL) -r tb_or3 $(GHDLRUNFLAGS)
	$(GHDL) -r tb_and2 $(GHDLRUNFLAGS)
	$(GHDL) -r tb_ha $(GHDLRUNFLAGS)
	$(GHDL) -r tb_fa $(GHDLRUNFLAGS)
	$(GHDL) -r tb_mux21 $(GHDLRUNFLAGS)
	$(GHDL) -r tb_mux21_1bit $(GHDLRUNFLAGS)
	$(GHDL) -r tb_comparator $(GHDLRUNFLAGS)
	$(GHDL) -r tb_rca $(GHDLRUNFLAGS)
	$(GHDL) -r tb_fd $(GHDLRUNFLAGS)
	$(GHDL) -r tb_ft $(GHDLRUNFLAGS)
	$(GHDL) -r tb_reg $(GHDLRUNFLAGS)
	$(GHDL) -r tb_counter $(GHDLRUNFLAGS)
	$(GHDL) -r tb_accumulator $(GHDLRUNFLAGS)
	$(GHDL) -r tb_display $(GHDLRUNFLAGS)


# Targets to analyze files
tb_or2.o: or2/tb_or2.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
or2.o: or2/or2.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_or3.o: or3/tb_or3.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
or3.o: or3/or3.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_and2.o: and2/tb_and2.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
and2.o: and2/and2.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_ha.o: ha/tb_ha.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
ha.o: ha/ha.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_fa.o: fa/tb_fa.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
fa.o: fa/fa.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_mux21.o: mux21/tb_mux21.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
mux21.o: mux21/mux21.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_mux21_1bit.o: mux21/tb_mux21_1bit.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
mux21_1bit.o: mux21/mux21_1bit.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_comparator.o: comparator/tb_comparator.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
comparator.o: comparator/comparator.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_rca.o: rca/tb_rca.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
rca.o: rca/rca.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_fd.o: fd/tb_fd.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
fd.o: fd/fd.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_ft.o: ft/tb_ft.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
ft.o: ft/ft.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_reg.o: reg/tb_reg.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
reg.o: reg/reg.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_counter.o: counter/tb_counter.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
counter.o: counter/counter.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_accumulator.o: accumulator/tb_accumulator.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
accumulator.o: accumulator/accumulator.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<

tb_display.o: display/tb_display.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
display.o: display/display.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
seven_segment_dot.o: display/seven_segment_dot.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<
vectors.o: display/vectors.vhdl
	$(GHDL) -a $(GHDLFLAGS) $<


# Check target
check:
	$(GHDL) -s $(GHDLFLAGS) $(SOURCES)

clean:
	-ghdl --remove
