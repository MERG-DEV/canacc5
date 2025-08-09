define(test_name, flim_enumerate_test)dnl

beginning_of_test(1186)
    variable test_sidl : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Check initial CAN Id");
      rx_data(OPC_QNN) -- QNN, CBUS Query node request)
      tx_wait_for_message(anything)
      tx_check_can_id(initial, 16#B1#, 16#80#)
      --
      report("test_name: Request enumerate");
      rx_data(OPC_ENUM, 4, 2) -- CBUS enumerate request to node 4 2
      --
      tx_rtr
      tx_check_can_id(default, 16#BF#, 16#E0#)
      --
      test_sidl := 16#20#;
      while test_sidl < 16#60# loop
        rx_sid(0, test_sidl)
        test_sidl := test_sidl + 16#20#;
      end loop;
      rx_sid(0, 16#80#)
      report("test_name: RTR, first free CAN Id is 3");
      --
      tx_wait_for_node_message(OPC_NNACK, 4, 2) -- NNACK, CBUS node number acknowledge
      tx_check_can_id(new, 16#B0#, 16#60#)
      --
end_of_test
