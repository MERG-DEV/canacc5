configuration for "PIC18F2480" is
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 17 ms;
      report("slim_poll_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  slim_poll_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    begin
      report("slim_poll_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB7 == '1'; -- Booted into SLiM
      report("slim_nv_write_test: Green LED (SLiM) on");
      --
      report("slim_poll_test: Long poll request 0x0220,0x2112, output 2");
      RXB0D0 <= 16#92#;      -- AREQ, CBUS long poll request
      RXB0D1 <= 2;           -- NN high
      RXB0D2 <= 32;          -- NN low
      RXB0D3 <= 33;          -- Event number high
      RXB0D4 <= 18;          -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Waiting for output 2 poll response");
        wait until TXB1CON.TXREQ == '1' for 5 ms;
      end if;
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Missing output 2 poll response");
        test_state := fail;
      end if;
      if TXB1D0 != 16#94# then -- AROF, CBUS long off poll response
        report("slim_poll_test: Sent wrong event");
        test_state := fail;
      end if;
      if TXB1D1 != 2 then
        report("slim_poll_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 32 then
        report("slim_poll_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 33 then
        report("slim_poll_test: Sent wrong Event Number (high)");
        test_state := fail;
      end if;
      if TXB1D4 != 18 then
        report("slim_poll_test: Sent wrong Event Number (low)");
        test_state := fail;
      end if;
      --
      report("slim_poll_test: Short on 0x0201,0x0204, output 2 on");
      RXB0D0 <= 16#98#;      -- ASON, CBUS short on
      RXB0D1 <= 2;           -- NN high
      RXB0D2 <= 1;           -- NN low
      RXB0D3 <= 2;           -- Event number high
      RXB0D4 <= 4;           -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait on PORTC;
      --
      report("slim_poll_test: Long poll request 0x0220,0x2112, output 2");
      RXB0D0 <= 16#92#;      -- AREQ, CBUS long poll request
      RXB0D1 <= 2;           -- NN high
      RXB0D2 <= 32;          -- NN low
      RXB0D3 <= 33;          -- Event number high
      RXB0D4 <= 18;          -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Waiting for output 2 poll response");
        wait until TXB1CON.TXREQ == '1' for 5 ms;
      end if;
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Missing output 2 poll response");
        test_state := fail;
      end if;
      if TXB1D0 != 16#93# then -- ARON, CBUS long on poll response
        report("slim_poll_test: Sent wrong event");
        test_state := fail;
      end if;
      if TXB1D1 != 2 then
        report("slim_poll_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 32 then
        report("slim_poll_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 33 then
        report("slim_poll_test: Sent wrong Event Number (high)");
        test_state := fail;
      end if;
      if TXB1D4 != 18 then
        report("slim_poll_test: Sent wrong Event Number (low)");
        test_state := fail;
      end if;
      --
      report("slim_poll_test: Short poll request 0x0220,0x6446, output 6");
      RXB0D0 <= 16#9A#;      -- ASRQ, CBUS short poll request
      RXB0D1 <= 2;           -- NN high
      RXB0D2 <= 32;          -- NN low
      RXB0D3 <= 101;         -- Event number high
      RXB0D4 <= 70;          -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Waiting for output 6 poll response");
        wait until TXB1CON.TXREQ == '1' for 5 ms;
      end if;
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Missing output 6 poll response");
        test_state := fail;
      end if;
      if TXB1D0 != 16#9E# then -- ARSOF, CBUS short off poll response
        report("slim_poll_test: Sent wrong event");
        test_state := fail;
      end if;
      if TXB1D1 != 0 then
        report("slim_poll_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 0 then
        report("slim_poll_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 101 then
        report("slim_poll_test: Sent wrong Event Number (high)");
        test_state := fail;
      end if;
      if TXB1D4 != 70 then
        report("slim_poll_test: Sent wrong Event Number (low)");
        test_state := fail;
      end if;
      --
      report("slim_poll_test: Short off 0x0909,0x0402, output 6 & 7 on");
      RXB0D0 <= 16#99#;      -- ASOF, CBUS short off
      RXB0D1 <= 9;           -- NN high
      RXB0D2 <= 9;           -- NN low
      RXB0D3 <= 4;           -- Event number high
      RXB0D4 <= 2;           -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait on PORTC;
      --
      report("slim_poll_test: Short poll request 0x2002,0x6446, output 6");
      RXB0D0 <= 16#9A#;      -- ASRQ, CBUS short poll request
      RXB0D1 <= 32;          -- NN high
      RXB0D2 <= 2;           -- NN low
      RXB0D3 <= 101;         -- Event number high
      RXB0D4 <= 70;          -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      TXB1CON.TXREQ <= '0';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Waiting for output 6 poll response");
        wait until TXB1CON.TXREQ == '1' for 5 ms;
      end if;
      if TXB1CON.TXREQ != '1' then
        report("slim_poll_test: Missing output 6 poll response");
        test_state := fail;
      end if;
      if TXB1D0 != 16#9D# then -- ARSON, CBUS short on poll response
        report("slim_poll_test: Sent wrong event");
        test_state := fail;
      end if;
      if TXB1D1 != 0 then
        report("slim_poll_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 0 then
        report("slim_poll_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 101 then
        report("slim_poll_test: Sent wrong Event Number (high)");
        test_state := fail;
      end if;
      if TXB1D4 != 70 then
        report("slim_poll_test: Sent wrong Event Number (low)");
        test_state := fail;
      end if;
      --
      if test_state == pass then
        report("slim_poll_test: PASS");
      else
        report("slim_poll_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process slim_poll_test;
end testbench;
