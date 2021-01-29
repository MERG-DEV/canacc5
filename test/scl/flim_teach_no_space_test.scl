configuration for "PIC18F2480" is
  shared variable Datmode;
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 50 ms;
      report("flim_teach_no_space_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  flim_teach_no_space_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    begin
      report("flim_teach_no_space_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB6 == '1'; -- Booted into FLiM
      report("flim_teach_no_space_test: Yellow LED (FLiM) on");
      --
      report("flim_teach_no_space_test: Enter learn mode");
      RXB0D0 <= 16#53#;    -- NNLRN, CBUS enter learn mode
      RXB0D1 <= 4;         -- NN high
      RXB0D2 <= 2;         -- NN low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      if Datmode != 24 then
        wait until Datmode == 24;
      end if;
      --
      report("flim_teach_no_space_test: Learn event 0x0102, 0x0980");
      RXB0D0 <= 16#D2#;    -- EVLRN, CBUS learn event
      RXB0D1 <= 1;         -- NN high
      RXB0D2 <= 2;         -- NN low
      RXB0D3 <= 9;
      RXB0D4 <= 128;
      RXB0D5 <= 1;         -- Event variable index, trigger bitmap
      RXB0D6 <= 4;         -- Event variable[1], output 6 on
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
      wait until TXB1CON.TXREQ == '1';
      if TXB1D0 != 16#59# then -- WRACK, CBUS write acknowledge response
        report("flim_teach_no_space_test: Sent wrong response");
        test_state := fail;
      end if;
      if TXB1D1 != 4 then
        report("flim_teach_no_space_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 2 then
        report("flim_teach_no_space_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      --
      report("flim_teach_no_space_test: Learnt 128 events");
      --
      report("flim_teach_no_space_test: Cannot learn event 0x0102, 0x0981");
      RXB0D0 <= 16#D2#;    -- EVLRN, CBUS learn event
      RXB0D1 <= 1;         -- NN high
      RXB0D2 <= 2;         -- NN low
      RXB0D3 <= 9;
      RXB0D4 <= 129;
      RXB0D5 <= 1;         -- Event variable index, trigger bitmap
      RXB0D6 <= 4;         -- Event variable[1], output 6 on
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
      wait until TXB1CON.TXREQ == '1';
      if TXB1D0 != 16#6F# then -- CMDERR, CBUS error response
        report("flim_teach_no_space_test: Sent wrong response");
        test_state := fail;
      end if;
      if TXB1D1 != 4 then
        report("flim_teach_no_space_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 2 then
        report("flim_teach_no_space_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 4 then -- No event space left
        report("flim_teach_no_space_test: Sent wrong error number");
        test_state := fail;
      end if;
      --
      -- FIXME yellow LED should flash
      --if RB6 == '0' then
      --  wait until RB6 == '1';
      --end if;
      --wait until RB6 == '1';
      --
      report("flim_teach_no_space_test: Cannot learn event 0x0000, 0x0982");
      RXB0D0 <= 16#D2#;    -- EVLRN, CBUS learn event
      RXB0D1 <= 0;         -- NN high
      RXB0D2 <= 0;         -- NN low
      RXB0D3 <= 9;
      RXB0D4 <= 130;
      RXB0D5 <= 1;         -- Event variable index, trigger bitmap
      RXB0D6 <= 4;         -- Event variable[1], output 6 on
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
      wait until TXB1CON.TXREQ == '1';
      if TXB1D0 != 16#6F# then -- CMDERR, CBUS error response
        report("flim_teach_no_space_test: Sent wrong response");
        test_state := fail;
      end if;
      if TXB1D1 != 4 then
        report("flim_teach_no_space_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 2 then
        report("flim_teach_no_space_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 4 then -- No event space left
        report("flim_teach_no_space_test: Sent wrong error number");
        test_state := fail;
      end if;
      --
      -- FIXME yellow LED should flash
      --if RB6 == '0' then
      --  wait until RB6 == '1';
      --end if;
      --wait until RB6 == '1';
      --
      if test_state == pass then
        report("flim_teach_no_space_test: PASS");
      else
        report("flim_teach_no_space_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process flim_teach_no_space_test;
end testbench;
