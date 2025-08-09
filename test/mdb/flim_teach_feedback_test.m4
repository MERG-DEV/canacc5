# Test CBUS teach feedback events in FLiM mode.

define(test_name, flim_teach_feedback_test)dnl

set_up_test_simulation

set_flim_CAN_id_and_module_status
set_node_id

set_data_for_five_events

run_test
