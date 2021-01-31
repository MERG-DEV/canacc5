configuration for "PIC18F2480" is
  shared label    _CANInit;
  shared label    _CANMain;
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 30 ms;
      report("flim_reboot_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  flim_reboot_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    begin
      report("flim_reboot_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB6 == '1'; -- Booted into FLiM
      report("flim_reboot_test: Yellow LED (FLiM) on");
      --
      report("flim_reboot_test: Ignore request addressed to Node 00");
      RXB0D0 <= 16#5C#; -- BOOTM, CBUS bootload mode request
      RXB0D1 <= 0;      -- NN high
      RXB0D2 <= 0;      -- NN low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait until RB6 == '0' for 6 ms; -- Wait for LED output reset on reboot
      if RB6 == '0' then
        report("flim_reboot_test: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("flim_reboot_test: Ignore request addressed to Node 0x40");
      RXB0D0 <= 16#5C#; -- BOOTM, CBUS bootload mode request
      RXB0D1 <= 4;      -- NN high
      RXB0D2 <= 0;      -- NN low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait until RB6 == '0' for 6 ms; -- Wait for LED output reset on reboot
      if RB6 == '0' then
        report("flim_reboot_test: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("flim_reboot_test: Ignore request addressed to Node 0x02");
      RXB0D0 <= 16#5C#; -- BOOTM, CBUS bootload mode request
      RXB0D1 <= 0;      -- NN high
      RXB0D2 <= 2;      -- NN low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait until RB6 == '0' for 6 ms; -- Wait for LED output reset on reboot
      if RB6 == '0' then
        report("flim_reboot_test: Unexpected reboot");
        test_state := fail;
      end if;
      --
      report("flim_reboot_test: Reboot request");
      RXB0D0 <= 16#5C#; -- BOOTM, CBUS bootload mode request
      RXB0D1 <= 4;      -- NN high
      RXB0D2 <= 2;      -- NN low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait until RB6 == '0'; -- Wait for LED output reset on reboot
      report("flim_reboot_test: Rebooting");
      --
      wait until PC == 0;
      PC <= _CANInit;
      --
      wait until PC == _CANMain;
      report("flim_reboot_test: Reached _CANMain, in bootloader");
      --
      if test_state == pass then
        report("flim_reboot_test: PASS");
      else
        report("flim_reboot_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process flim_reboot_test;
end testbench;
