define(test_name, slim_reboot_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(902, label _CANInit, label _CANMain)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Reboot request addressed to node 0x0402");
      rx_data(OPC_BOOT, 4, 2) -- BOOTM, CBUS bootload mode request
      --
      wait until slim_led == '0' for 6 ms; -- Wait for LED output reset on reboot
      if slim_led == '0' then
        report("test_name: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("test_name: Reboot request addressed to node 0x0400");
      rx_data(OPC_BOOT, 4, 0) -- BOOTM, CBUS bootload mode request
      --
      wait until slim_led == '0' for 6 ms; -- Wait for LED output reset on reboot
      if slim_led == '0' then
        report("test_name: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("test_name: Reboot request addressed to node 0x0002");
      rx_data(OPC_BOOT, 0, 2) -- BOOTM, CBUS bootload mode request
      --
      wait until slim_led == '0' for 6 ms; -- Wait for LED output reset on reboot
      if slim_led == '0' then
        report("test_name: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("test_name: Reboot request addressed to node 0x0000");
      rx_data(OPC_BOOT, 0, 0) -- BOOTM, CBUS bootload mode request
      --
      wait until slim_led == '0'; -- Wait for LED output reset on reboot
      report("test_name: Reboot");
      --
      wait until PC == 0;
      PC <= _CANInit;
      --
      wait until PC == _CANMain;
      report("test_name: Reached _CANMain, in bootloader");
      --
end_of_test
