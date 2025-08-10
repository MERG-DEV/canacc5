# Test CBUS output feedback events in SLiM mode.

define(test_name, patsubst(__file__, {.m4},))dnl

set_up_test_simulation

set_data_for_feedback_events

run_test
