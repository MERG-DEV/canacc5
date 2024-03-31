configuration for "PIC18F2480" is
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 813 ms;
      report("slim_set_can_id_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  slim_set_can_id_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    begin
      report("slim_set_can_id_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- DOLEARN off
      RA0 <= '1'; -- UNLEARN off
      --
      wait until RB7 == '1'; -- Booted into SLiM
      report("slim_set_can_id_test: Green LED (SLiM) on");
      --
      report("slim_set_can_id_test: Check CAN Id");
      RXB0D0 <= 16#73#; -- RQNPN, CBUS read node parameter by index
      RXB0D1 <= 0;      -- NN high
      RXB0D2 <= 0;      -- NN low
      RXB0D3 <= 0;      -- Index, 0 == number of parameters
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      if RXB0CON.RXFUL != '0' then
        wait until RXB0CON.RXFUL == '0';
      end if;
      COMSTAT <= 0;
      --
      TXB1CON.TXREQ <= '0';
      wait until TXB1CON.TXREQ == '1';
      if TXB1SIDH != 16#BF# then
        report("slim_set_can_id_test: Incorrect SIDH");
        test_state := fail;
      end if;
      if TXB1SIDL != 16#E0# then
        report("slim_set_can_id_test: Incorrect SIDL");
        test_state := fail;
      end if;
      --
      report("slim_set_can_id_test: Set CAN Id");
      RXB0D0 <= 16#75#; -- CBUS set CAN Id request
      RXB0D1 <= 0;      -- NN high
      RXB0D2 <= 0;      -- NN low
      RXB0D3 <= 3;      -- New CAN Id
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      if RXB0CON.RXFUL != '0' then
        wait until RXB0CON.RXFUL == '0';
      end if;
      COMSTAT <= 0;
      --
      TXB1CON.TXREQ <= '0';
      wait until TXB1CON.TXREQ == '1' for 776 ms; -- Test if response sent
      if TXB1CON.TXREQ == '1' then
        report("slim_set_can_id_test: Unexpected response");
        test_state := fail;
      end if;
      --
      RXB0D0 <= 16#73#; -- RQNPN, CBUS read node parameter by index
      RXB0D1 <= 0;      -- NN high
      RXB0D2 <= 0;      -- NN low
      RXB0D3 <= 0;      -- Index, 0 == number of parameters
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      if RXB0CON.RXFUL != '0' then
        wait until RXB0CON.RXFUL == '0';
      end if;
      COMSTAT <= 0;
      --
      TXB1CON.TXREQ <= '0';
      wait until TXB1CON.TXREQ == '1';
      if TXB1SIDH != 16#BF# then
        report("slim_set_can_id_test: Incorrect SIDH");
        test_state := fail;
      end if;
      if TXB1SIDL != 16#E0# then
        report("slim_set_can_id_test: Incorrect SIDL");
        test_state := fail;
      end if;
      --
      if test_state == pass then
        report("slim_set_can_id_test: PASS");
      else
        report("slim_set_can_id_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process slim_set_can_id_test;
end testbench;
