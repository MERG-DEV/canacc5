# Test CBUS node variable requests in FLiM mode.

set_test_name()dnl

set_up_test_simulation

set_flim_CAN_id_and_module_status
set_node_id

set_number_of_events(5)

# Set output pulse times
Write /e 0xE6 8 7 6 5 1 2 3 4

run_test
