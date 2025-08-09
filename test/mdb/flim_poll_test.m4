# Test CBUS output poll events in FLiM mode.

define(test_name, flim_poll_test)dnl

set_up_test_simulation

set_flim_CAN_id_and_module_status
set_node_id

set_data_for_feedback_events

run_test
