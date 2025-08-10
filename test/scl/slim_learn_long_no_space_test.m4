set_test_name()dnl

beginning_of_test(333)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SliM
      --
      -- Learn events for output 2
      set_dolearn_on
      select_output_2
      set_polarity_normal -- On event => A, Off event => B
      --
      report("test_name: Long On 0x0102, 0x0180");
      rx_data(OPC_ACON, 1, 2, 1, 128)
      wait_until_idle
      tx_check_no_message -- Test if unexpected response sent
      --
      report("test_name: Learnt 128 events");
      --
      report("test_name: Long On 0x0102, 0x0281");
      rx_data(OPC_ACON, 1, 2, 2, 129)
      wait_until_idle
      --
      report("test_name: Checking for CMDERR");
      tx_wait_for_cmderr_message(0, 0, 4)
      --
      -- FIXME yellow LED should flash
      --if flim_led == '0' then
      --  wait until flim_led == '1';
      --end if;
      --wait until flim_led == '1';
      --
end_of_test
