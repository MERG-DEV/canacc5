define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(7)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Receive RTR");
      rx_rtr
      tx_wait_for_rtr_response(16#B1#, 16#80#)
      --
end_of_test
