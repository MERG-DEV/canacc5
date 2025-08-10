define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(813)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Check initial CAN Id");
      rx_data(OPC_RQNPN, 0, 0, 0) -- RQNPN, CBUS read node parameter by index, 0 == number of parameters
      tx_wait_for_node_message(OPC_PARAN, 0, 0) -- PARAN, CBUS individual parameter response
      tx_check_can_id(initial, 16#BF#, 16#E0#)
      --
      report("test_name: Set CAN Id");
      rx_data(OPC_CANID, 0, 0, 3) -- CANID CBUS set CAN Id request
      tx_check_no_message(776)
      --
      report("test_name: Check CAN Id unchanged");
      rx_data(OPC_RQNPN, 0, 0, 0) -- RQNPN, CBUS read node parameter by index, 0 == number of parameters
      tx_wait_for_node_message(OPC_PARAN, 0, 0) -- PARAN, CBUS individual parameter response
      tx_check_can_id(unchanged, 16#BF#, 16#E0#)
      --
end_of_test
