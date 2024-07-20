define(test_name, slim_boot_unlearn_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(846)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_on
      --
      wait_until_slim -- Booted into SLiM
      --
      set_unlearn_off
      --
      report("test_name: Check events");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        data_file_skip_till_done
        wait_until_idle
        output_check_for_no_change(outputs_port, 0)
      end loop;
      --
end_of_test
