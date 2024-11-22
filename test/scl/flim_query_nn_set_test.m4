define(test_name, flim_query_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(781)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Query node");
      rx_data(OPC_QNN) -- QNN, CBUS Query node request
      tx_wait_for_node_message(OPC_PNN, 4, 2, 165, Manufacturer id, 2, Module id, 13, Flags)
end_of_test
