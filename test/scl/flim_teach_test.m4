define(test_name, flim_teach_test)dnl

beginning_of_test(1227)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(4, 2) -- Node 0x0402
      --
      report("test_name: Event Variable index too low long 0x0102,0x0402");
      rx_data(OPC_REQEV, 1, 2, 4, 2, 0) -- REQEV, CBUS Read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Event Variable index too high long 0x0102,0x0402");
      rx_data(OPC_REQEV, 1, 2, 4, 4, 4) -- REQEV, CBUS Read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Teach events");
      data_file_open(teach.dat)
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
      report("test_name: Do not learn event");
      rx_data(OPC_EVLRN, 9, 9, 8, 8, 1, 4) -- EVLRN, CBUS learn event, event variable 1, output 6 normal
      --
      -- FIXME SHould reject request as not in learn mode
      --TXB1CON.TXREQ <= '0';
      --wait until TXB1CON.TXREQ == '1';
      --if TXB1D0 != 16#6F# then -- CMDERR, CBUS error response
      --  report("test_name: Sent wrong response");
      --  test_state := fail;
      --end if;
      --if TXB1D1 != 4 then
      --  report("test_name: Sent wrong Node Number (high)");
      --  test_state := fail;
      --end if;
      --if TXB1D2 != 2 then
      --  report("test_name: Sent wrong Node Number (low)");
      --  test_state := fail;
      --end if;
      --if TXB1D3 != 2 then -- Not in learn event mode
      --  report("test_name: Sent wrong error number");
      --  test_state := fail;
      --end if;
      --
      report("test_name: Recheck available event space");
      rx_data(OPC_NNEVN, 4, 2) -- NNEVN, CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123, available event space) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Recheck number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- RQEVN, CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 5, number of stored events) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Check events");
      data_file_open(learnt_events.dat)
      last_output := outputs_port;
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
