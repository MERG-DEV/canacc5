# Test CBUS teach poll events in SLiM mode.

define(test_name, slim_teach_poll_test)dnl
include(common.inc)dnl

set_up_test_simulation

set_data_for_five_events

run_test
