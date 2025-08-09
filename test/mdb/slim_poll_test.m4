# Test CBUS output poll events in SLiM mode.

define(test_name, slim_poll_test)dnl

set_up_test_simulation

set_data_for_feedback_events

run_test
