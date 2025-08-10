set_test_name()dnl

beginning_of_test(94)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(4, 2)
      --
      report("test_name: Modify events");
      data_file_open(modify.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_learn
        tx_wait_for_node_message(OPC_WRACK, 4, 2) -- WRACK, CBUS write acknowledge response
      end loop;
      --
      file_close(data_file);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(4, 2)
      --
      report("test_name: Check available event space");
      rx_data(OPC_NNEVN, 4, 2) -- NNEVN, CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123) -- EVLNF, CBUS available event space response
      --
      report("test_name: Check number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- RQEVN, CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 5, number of stored events) -- NNEVN, CBUS number of stored events response
      --
      report("test_name: Check modified events");
      data_file_open(modified_events.dat)
      last_output := outputs_port;
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
