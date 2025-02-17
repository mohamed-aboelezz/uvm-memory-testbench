SIM = questa
COVERAGE = 1
GUI = 0

all: compile run

compile:
	vlib work
	vlog -sv -mfcu \
	+incdir+include+tb/package \
	include/intf.sv \
	rtl/Memory.sv \
	tb/pkg.sv \
	sim/top.sv

run:
	vsim -c -do "run -all; quit" +UVM_TESTNAME=my_test +UVM_CONFIG_DB_TRACE=1 top

coverage:
	vcover report -html -details -output docs/reports/coverage vsim.coverage

clean:
	rm -rf work vsim.wlf transcript *.log *.vstf *.html docs/reports/*