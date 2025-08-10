set_test_name()dnl

beginning_of_test(19855)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      set_setup_on
      report("test_name: Setup button pressed");
      wait until flim_led == '0';
      report("test_name: SLiM setup started");
      --
      tx_wait_for_node_message(OPC_NNREL, 4, 2) --NNREL, CBUS release node number
      tx_check_can_id(release, 16#B1#, 16#80#)
      --
      set_setup_off
      report("test_name: Setup button released");
      --
      if slim_led != '1' then
        report("test_name: Awaiting green LED (SLiM)");
        wait until slim_led == '1'; -- Booted into SLiM
      end if;
      report("test_name: Green LED (SLiM) on");
      --
      if flim_led == '1' then
        report("test_name: Yellow LED (FLiM) on");
        test_state := fail;
      end if;
      --
end_of_test
