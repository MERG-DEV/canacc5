set_test_name()dnl

beginning_of_test(27740)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(0, 0)
      --
      report("test_name: Unlearn events");
      data_file_open(unlearn.dat)
      while endfile(data_file) == false loop
        last_output := outputs_port;
        readline(data_file, file_line); -- Ignore event type from data file
        rx_data_file_unlearn
        data_file_skip_till_done
        --
        output_wait_for_no_change(outputs_port, last_output, 1005)
        tx_check_for_no_message(776);
      end loop;
      --
      file_close(data_file);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(0, 0)
      --
      report("test_name: Check events unchanged");
      last_output := outputs_port;
      data_file_open(learnt_events.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        --
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
