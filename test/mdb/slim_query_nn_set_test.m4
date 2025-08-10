# Test CBUS Node Query request ignored in SLiM mode even if Node Number is set.

define(test_name, patsubst(__file__, {.m4},))dnl

set_up_test_simulation

set_node_id

set_number_of_events(5)

run_test
