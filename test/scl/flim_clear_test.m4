define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(16934)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Reject clear events request");
      rx_data(OPC_NNCLR, 4, 2) -- NNCLR, CBUS clear events to node 4 2
      tx_wait_for_node_message(OPC_CMDERR, 4, 2, 2, error number) -- CMDERR, CBUS error response
      --
      report("test_name: Check available event space");
      rx_data(OPC_NNEVN, 4, 2) -- NNEVN, CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123) -- EVLNF, CBUS available event space response
      --
      report("test_name: Check number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- RQEVN, CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 5, number of stored events) -- NNEVN, CBUS number of stored events response
      --
      report("test_name: Enter learn mode");
      rx_data(OPC_NNLRN, 4, 2) -- NNLRN, CBUS enter learn mode to node 4 2
      wait for 1 ms; -- FIXME Next packet lost if previous not yet processed
      --
      report("test_name: Clear events");
      rx_data(OPC_NNCLR, 4, 2) -- NNCLR, CBUS clear events to node 4 2
      tx_wait_for_node_message(OPC_WRACK, 4, 2) -- WRACK, CBUS write acknowledge response
      --
      report("test_name: Exit learn mode");
      rx_data(OPC_NNULN, 4, 2) -- NNULN, exit learn mode to node 4 2
      --
      report("test_name: Reheck available event space");
      rx_data(OPC_NNEVN, 4, 2) -- NNEVN, CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 128) -- EVLNF, CBUS available event space response
      --
      report("test_name: Recheck number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- RQEVN, CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 0, number of stored events) -- NNEVN, CBUS number of stored events response
      --
      report("test_name: Check events are now ignored");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        data_file_skip_till_done
        output_wait_for_no_change(outputs_port, 0, 1005)
      end loop;
      --
end_of_test
