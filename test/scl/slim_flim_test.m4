define(test_name, slim_flim_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(30000, label main, label setup)
    variable test_sidl : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      set_setup_on
      report("test_name: Setup button pressed");
      wait until slim_led == '0';
      report("test_name: FLiM setup started");
      set_setup_off
      report("test_name: Setup button released");
      --
      report("test_name: Awaiting RTR");
      tx_rtr
      tx_check_can_id(default, 16#BF#, 16#E0#)
      --
      test_sidl := 16#20#;
      while test_sidl < 16#100# loop
        rx_sid(0, test_sidl)
        test_sidl := test_sidl + 16#20#;
      end loop;
      test_sidl := 0;
      while test_sidl < 16#80# loop
        rx_sid(1, test_sidl)
        test_sidl := test_sidl + 16#20#;
      end loop;
      rx_sid(1, 16#A0#)
      report("test_name: RTR, first free CAN Id is 12");
      --
      report("test_name: Awaiting Node Number request");
      tx_wait_for_node_message(OPC_RQNN, 0, 0) -- RQNN, CBUS request Node Number, node 0 0
      report("test_name: RQNN request");
      tx_check_can_id(new, 16#B1#, 16#80#)
      --
      wait until flim_led == '1';
      wait until flim_led == '0';
      wait until flim_led == '1';
      wait until flim_led == '0';
      report("test_name: Yellow LED (FLiM) flashing");
      --
      report("test_name: Request Node Parameters");
      rx_data(OPC_RQNP, 0, 0)
      --
      report("test_name: Awaiting Node Parameters");
      tx_wait_for_message(node parameters, OPC_PARAMS, opcode, 165, manufacturer id, 86, minor version, 2, module id, 128, number of events allowed, 3, number of variables per event, 12, number of node variables, 2, major version)
      --
      report("test_name: Request Module Name");
      rx_data(OPC_RQMN, 0, 0)
      --
      report("test_name: Awaiting Module Name");
      tx_wait_for_message(module name, OPC_NAME, opcode, 65, name [0], 67, name [1], 67, name [2], 53, name [3], 32, name [4], 32, name [5], 32, name [6])
-- 'ACC5   '
      --
      report("test_name: Set Node Number");
      rx_data(OPC_SNN, 4, 2) -- SNN, CBUS set node number, node 4 2
      --
      report("test_name: Awaiting Node Number acknowledge");
      tx_wait_for_node_message(OPC_NNACK, 4, 2) -- NNACK, CBUS node number acknowledge, node 4 2
      report("test_name: Node number response");
      tx_check_can_id(acknowledge, 16#B1#, 16#80#)
      --
      if flim_led == '0' then
        report("test_name: Awaiting yellow LED (FLiM)");
        wait until flim_led == '1';
      end if;
      report("test_name: Yellow LED (FLiM) on");
      --
      if slim_led == '1' then
        report("test_name: Green LED (SLiM) on");
        test_state := fail;
      end if;
      --
      report("test_name: Restart");
      wait until PC == main;
      PC <= setup;
      --
      if flim_led == '1' then
        wait until flim_led == '0';
      end if;
      wait until flim_led == '1';
      report("test_name: Yellow LED (FLiM) back on");
      --
      report("test_name: Check Node Number and event space after restart");
      rx_data(OPC_NNEVN, 4, 2) -- CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123, available event space) -- EVLNF, CBUS available event space response node 4 2
end_of_test
