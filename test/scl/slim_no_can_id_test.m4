define(test_name, slim_no_can_id_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(23000)
    variable test_sidh : integer;
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
      tx_check_can_id(initial, 16#BF#, 16#E0#)
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
      tx_wait_for_cmderr_message(0, 0, CMDERR_INVALID_EVENT)
      tx_check_can_id(unchanged, 16#BF#, 16#E0#)
      --
end_of_test
