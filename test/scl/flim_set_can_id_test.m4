define(test_name, flim_set_can_id_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(813)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Check initial CAN Id");
      rx_data(OPC_RQNPN, 4, 2, 0) -- RQNPN, CBUS read node parameter by index, 0 == number of parameters
      tx_wait_for_node_message(OPC_PARAN, 4, 2) -- PARAN, CBUS individual parameter response
      tx_check_can_id(initial, 16#B1#, 16#80#)
      --
      report("test_name: Ignore set CAN Id not addressed to node");
      rx_data(OPC_CANID, 0, 0, 3) -- CANID CBUS set CAN Id request
      tx_check_no_message(776)
      --
      report("test_name: Check CAN Id unchanged");
      rx_data(OPC_RQNPN, 4, 2, 0) -- RQNPN, CBUS read node parameter by index, 0 == number of parameters
      tx_wait_for_node_message(OPC_PARAN, 4, 2) -- PARAN, CBUS individual parameter response
      tx_check_can_id(unchanged, 16#B1#, 16#80#)
      --
      report("test_name: Set CAN Id");
      rx_data(OPC_CANID, 4, 2, 3) -- CANID CBUS set CAN Id request
      tx_wait_for_node_message(OPC_NNACK, 4, 2) -- NNACK, CBUS node number acknowledge
      tx_check_can_id(modified, 16#B0#, 16#60#)
      --
end_of_test
