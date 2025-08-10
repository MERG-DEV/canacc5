set_test_name()dnl

beginning_of_test(1654)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Receive RTR");
      rx_rtr
      tx_check_no_rtr_response(776)
      --
end_of_test
