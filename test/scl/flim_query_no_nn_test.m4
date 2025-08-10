define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(788)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Query node");
      rx_data(OPC_QNN) -- QNN, CBUS Query node request
      tx_check_no_message(781)
end_of_test
