GHDL=ghdl
GHDLFLAGS= --ieee=synopsys
GHDLRUNFLAGS= --stop-time=20ns

TESTBENCHES=tb_or2 tb_or3 tb_and2 tb_ha tb_fa tb_rca \
            tb_mux21 tb_mux21_1bit tb_comparator \
            tb_fd tb_ft tb_reg tb_counter tb_accumulator

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
tb_comparator: comparator.o fa.o tb_comparator.o
tb_rca: rca.o fa.o tb_rca.o
tb_fd: fd.o tb_fd.o
tb_ft: ft.o tb_ft.o
tb_reg: fd.o reg.o tb_reg.o
tb_counter: ha.o fd.o counter.o tb_counter.o
tb_accumulator: fa.o fd.o mux21.o rca.o reg.o accumulator.o tb_accumulator.o


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
