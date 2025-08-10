define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(1182)
    variable test_sidh : integer;
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
      test_sidh := 0;
      test_sidl := 16#20#;
      while test_sidh < 16#10# loop
        while test_sidl < 16#100# loop
          rx_sid(test_sidh, test_sidl)
          test_sidl := test_sidl + 16#20#;
        end loop;
        test_sidh := test_sidh + 1;
        test_sidl := 0;
      end loop;
      report("test_name: RTR, all CAN Ids taken");
      --
      report("test_name: Awaiting CMDERR");
      tx_wait_for_cmderr_message(4, 2, CMDERR_INVALID_EVENT)
      tx_check_can_id(unchanged, 16#B1#, 16#80#)
      --
end_of_test
