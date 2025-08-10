# Test CBUS Node Query request ignored in FLiM mode if Node Number is zero.

set_test_name()dnl

set_up_test_simulation

set_flim_CAN_id_and_module_status

set_number_of_events(5)

run_test
