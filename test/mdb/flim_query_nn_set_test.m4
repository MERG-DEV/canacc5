# Test CBUS Node Query request in FLiM mode with Node Number set.

define(test_name, flim_query_nn_set_test)dnl

set_up_test_simulation

set_flim_CAN_id_and_module_status
set_node_id

set_number_of_events(5)

run_test
