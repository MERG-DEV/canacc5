define(test_name, flim_unlearn_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(25687)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_flim -- Booted into FLiM
      --
      set_dolearn_on
      set_unlearn_on
      --
      report("test_name: Unlearn events");
      data_file_open(unlearn.dat)
      last_output := outputs_port;
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        --
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
      file_close(data_file);
      --
      set_dolearn_off
      set_unlearn_off
      --
      report("test_name: Check events");
      data_file_open(not_unlearnt.dat)
      last_output := outputs_port;
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        --
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
