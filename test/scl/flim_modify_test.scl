configuration for "PIC18F2480" is
  shared variable Datmode;
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 94 ms;
      report("flim_modify_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  flim_modify_test: process is
    type test_result is (pass, fail);
    variable test_state   : test_result;
    file     event_file   : text;
    variable file_stat    : file_open_status;
    variable file_line    : string;
    variable report_line  : string;
    variable trigger_line : string;
    variable trigger_val  : integer;
    variable last_portc   : integer;
    begin
      report("flim_modify_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB6 == '1'; -- Booted into FLiM
      report("flim_modify_test: Yellow LED (FLiM) on");
      --
      report("flim_modify_test: Enter learn mode");
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
      file_open(file_stat, event_file, "./data/modify.dat", read_mode);
      if file_stat != open_ok then
        report("flim_modify_test: Failed to open learn data file");
        report("flim_modify_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("flim_modify_test: Modify events");
      while endfile(event_file) == false loop
        readline(event_file, report_line);
        report(report_line);
        --
        RXB0D0 <= 16#D2#;    -- EVLRN, CBUS learn event
        read(event_file, RXB0D1, 1);
        read(event_file, RXB0D2, 1);
        read(event_file, RXB0D3, 1);
        read(event_file, RXB0D4, 1);
        read(event_file, RXB0D5, 1);
        read(event_file, RXB0D6, 1);
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
          report("flim_modify_test: Sent wrong response");
          test_state := fail;
        end if;
        if TXB1D1 != 4 then
          report("flim_modify_test: Sent wrong Node Number (high)");
          test_state := fail;
        end if;
        if TXB1D2 != 2 then
          report("flim_modify_test: Sent wrong Node Number (low)");
          test_state := fail;
        end if;
      end loop;
      --
      file_close(event_file);
      --
      report("flim_modify_test: Exit learn mode");
      RXB0D0 <= 16#54#;    -- NNULN, exit learn mode
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
      report("flim_modify_test: Check available event space");
      RXB0D0 <= 16#56#;    -- NNEVN, CBUS request available event space
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
      TXB1CON.TXREQ <= '0';
      wait until TXB1CON.TXREQ == '1';
      if TXB1D0 != 16#70# then -- EVLNF, CBUS available event space response
        report("flim_modify_test: Sent wrong response");
        test_state := fail;
      end if;
      if TXB1D1 != 4 then
        report("flim_modify_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 2 then
        report("flim_modify_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 123 then
        report("flim_modify_test: Sent wrong available event space");
        test_state := fail;
      end if;
      --
      report("flim_modify_test: Check number of stored events");
      RXB0D0 <= 16#58#;    -- RQEVN, CBUS request number of stored events
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
      TXB1CON.TXREQ <= '0';
      wait until TXB1CON.TXREQ == '1';
      if TXB1D0 != 16#74# then -- NNEVN, CBUS number of stored events response
        report("flim_modify_test: Sent wrong response");
        test_state := fail;
      end if;
      if TXB1D1 != 4 then
        report("flim_modify_test: Sent wrong Node Number (high)");
        test_state := fail;
      end if;
      if TXB1D2 != 2 then
        report("flim_modify_test: Sent wrong Node Number (low)");
        test_state := fail;
      end if;
      if TXB1D3 != 5 then
        report("flim_modify_test: Sent wrong number of stored events");
        test_state := fail;
      end if;
      --
      file_open(file_stat, event_file, "./data/modified_events.dat", read_mode);
      if file_stat != open_ok then
        report("flim_modify_test: Failed to open event data file");
        report("flim_modify_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("flim_modify_test: Check modified events");
      last_portc := PORTC;
      while endfile(event_file) == false loop
        readline(event_file, report_line);
        report(report_line);
        read(event_file, RXB0D0, 1);
        read(event_file, RXB0D1, 1);
        read(event_file, RXB0D2, 1);
        read(event_file, RXB0D3, 1);
        read(event_file, RXB0D4, 1);
        RXB0CON.RXFUL <= '1';
        RXB0DLC.DLC3 <= '1';
        COMSTAT <= 16#80#;
        CANSTAT <= 16#0C#;
        PIR3.RXB0IF <= '1';
        --
        wait until RXB0CON.RXFUL == '0';
        COMSTAT <= 0;
        --
        readline(event_file, report_line);
        while match(report_line, "Done") == false loop
          readline(event_file, trigger_line);
          read(trigger_line, trigger_val);
          --
          if match(report_line, "No change") then
            if Datmode != 8 then
              wait until Datmode == 8;
            end if;
            --
            if PORTC == last_portc then
              report(report_line);
            else
              report("flim_modify_test: Unexpected output change");
              test_state := fail;
            end if;
          else
            wait until PORTC != last_portc;
            if PORTC == trigger_val then
              report(report_line);
            else
              report("flim_modify_test: Wrong output");
              test_state := fail;
            end if;
          end if;
          --
          last_portc := PORTC;
          readline(event_file, report_line);
        end loop;
      end loop;
      --
      file_close(event_file);
      --
      if test_state == pass then
        report("flim_modify_test: PASS");
      else
        report("flim_modify_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process flim_modify_test;
end testbench;
