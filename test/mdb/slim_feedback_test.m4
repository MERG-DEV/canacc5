# Test CBUS output feedback events in SLiM mode.

define(test_name, slim_feedback_test)dnl
include(common.inc)dnl

set_up_test_simulation

set_data_for_feedback_events

run_test
