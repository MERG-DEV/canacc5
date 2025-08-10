set_test_name()dnl

beginning_of_test(23285)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      set_dolearn_on
      --
      report("test_name: Do not learn events");
      data_file_open(learn.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_select_output_and_polarity
        rx_data_file_event
        --
        wait_until_idle
      end loop;
      --
      file_close(data_file);
      --
      set_dolearn_off
      --
      report("test_name: Check available event space");
      rx_data(OPC_NNEVN, 4, 2) -- CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 128, available event space) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Check number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 0, number of stored events) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Check events were not learnt");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        data_file_skip_till_done
        --
        output_wait_for_no_change(outputs_port, 0, 1005)
      end loop;
      --
end_of_test
