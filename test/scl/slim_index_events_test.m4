define(test_name, slim_index_events_test)dnl

beginning_of_test(2400)
    begin_test
      set_setup_off
      set_dolearn_on
      set_unlearn_off
      --
      wait_until_slim -- Booted into SliM
      --
      report("test_name: Request stored events");
      rx_data(OPC_NERD, 0, 0) -- CBUS Read events request node 0 0
      tx_check_no_message(776)  -- Test if unexpected response sent
      --
      report("slim_index_events_test: Request available event space");
      rx_data(OPC_NNEVN, 0, 0) -- CBUS request available event space node 0 0
      tx_check_no_message(776)  -- Test if unexpected response sent
      --
      report("slim_index_events_test: Request number of stored events");
      rx_data(OPC_RQEVN, 0, 0) -- CBUS request number of stored events node 0 0
      tx_check_no_message(776)  -- Test if unexpected response sent
      --
end_of_test
