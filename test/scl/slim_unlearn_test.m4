define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(27740)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_slim -- Booted into SLiM
      --
      set_dolearn_on
      set_unlearn_on
      --
      report("test_name: Unlearn events");
      data_file_open(unlearn.dat)
      while endfile(data_file) == false loop
        last_output := outputs_port;
        data_file_report_line
        rx_data_file_event
        data_file_skip_till_done
        --
        output_wait_for_no_change(outputs_port, last_output, 1005)
      end loop;
      --
      file_close(data_file);
      --
      set_dolearn_off
      set_unlearn_off
      --
      report("test_name: Check events");
      last_output := outputs_port;
      data_file_open(remaining_events.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        --
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
