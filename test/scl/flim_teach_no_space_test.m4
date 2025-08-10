set_test_name()dnl

beginning_of_test(50)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into fLiM
      --
      report("test_name: Yellow LED (FLiM) on");
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(4, 2) -- Node 0x0402
      --
      report("test_name: Learn event 0x0102, 0x0980");
      rx_data(OPC_EVLRN, 1, 2, 9, 128, 1, 64) -- EVLRN, CBUS learn event, event variable 1, output 2 normal
      tx_wait_for_node_message(OPC_WRACK, 4, 2)
      --
      report("test_name: Learnt 128 events");
      --
      report("test_name: Cannot learn event 0x0102, 0x0981");
      rx_data(OPC_EVLRN, 1, 2, 9, 129, 1, 4) -- EVLRN, CBUS learn event, event variable 1, output 6 normal
      tx_wait_for_cmderr_message(4, 2, CMDERR_TOO_MANY_EVENTS)
      --
      -- FIXME yellow LED should flash
      --if RB6 == '0' then
      --  wait until RB6 == '1';
      --end if;
      --wait until RB6 == '1';
      --
      report("test_name: Cannot learn event 0x0000, 0x0982");
      rx_data(OPC_EVLRN, 0, 0, 9, 130, 1, 4) -- EVLRN, CBUS learn event, event variable 1, output 6 normal
      tx_wait_for_cmderr_message(4, 2, CMDERR_TOO_MANY_EVENTS)
      --
      -- FIXME yellow LED should flash
      --if RB6 == '0' then
      --  wait until RB6 == '1';
      --end if;
      --wait until RB6 == '1';
      --
end_of_test
