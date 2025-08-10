define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(811)
    data_file_variables
    variable ev_node_hi  : integer;
    variable ev_node_lo  : integer;
    variable ev_ev_hi    : integer;
    variable ev_ev_lo    : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Read event");
      rx_data(OPC_NENRD, 0, 0, 1) -- NENRD, CBUS Read event by index request, node 0, index 1
      --
      tx_check_no_message(776)
      --
end_of_test
