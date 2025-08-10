set_test_name()dnl

beginning_of_test(48)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_on
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      set_dolearn_off
      --
      report("test_name: Check events");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        --
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
