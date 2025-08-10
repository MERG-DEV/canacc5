set_test_name()dnl

beginning_of_test(1615)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      set_setup_on
      report("test_name: Setup button pressed");
      wait for 1 sec;
      set_setup_off
      report("test_name: Setup button released");
      --
      report("test_name: Awaiting RTR");
      tx_rtr
      tx_check_can_id(default, 16#BF#, 16#E0#)
      --
      report("test_name: Awaiting Node Number request");
      tx_wait_for_node_message(OPC_RQNN, 4, 2) -- RQNN, CBUS request Node Number, node 4 2
      report("test_name: RQNN request");
      tx_check_can_id(new, 16#B0#, 16#20#)
      --
      report("test_name: Set Node Number");
      rx_data(OPC_SNN, 9, 8) -- SNN, CBUS set node number, node 9 8
      --
      report("test_name: Awaiting Node Number acknowledge");
      tx_wait_for_node_message(OPC_NNACK, 9, 8) -- NNACK, CBUS node number acknowledge, node 9 8
      report("test_name: Node number response");
      tx_check_can_id(acknowledge, 16#B0#, 16#20#)
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
end_of_test
