define(test_name, slim_clear_test)dnl

beginning_of_test(24046)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Enter learn mode");
      rx_data(OPC_NNLRN, 0, 0) -- NNLRN, CBUS enter learn mode to node 0 0
      wait for 1 ms; -- FIXME Next packet lost if previous not yet processed
      --
      report("test_name: Clear events");
      rx_data(OPC_NNCLR, 0, 0) -- NNCLR, CBUS clear events to node 0 0
      tx_check_for_no_message(776)
      --
      report("test_name: Exit learn mode");
      rx_data(OPC_NNULN, 0, 0) -- NNULN, exit learn mode to node 0 0
      --
      report("test_name: Check events");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
