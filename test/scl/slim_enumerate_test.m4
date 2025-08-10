define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(1654)
    variable test_sidl : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Request enumerate");
      rx_data(OPC_ENUM, 0, 0) -- CBUS enumerate request to node 0 0
      tx_check_for_no_message(776)
      --
end_of_test
