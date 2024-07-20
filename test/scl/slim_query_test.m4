define(test_name, slim_query_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(811)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Query node");
      rx_data(OPC_QNN) -- QNN, CBUS Query node request
      tx_check_no_message(776)
end_of_test
