configuration for "PIC18F2480" is
  shared variable Datmode;
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 28609 ms;
      report("slim_modify_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  slim_modify_test: process is
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
      report("slim_modify_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB7 == '1'; -- Booted into SLiM
      report("slim_modify_test: Green LED (SLiM) on");
      --
      report("slim_modify_test: Enter learn mode");
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
        report("slim_modify_test: Failed to open learn data file");
        report("slim_modify_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("slim_modify_test: Modify events");
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
        wait until TXB1CON.TXREQ == '1' for 776 ms; -- Test if response sent
        if TXB1CON.TXREQ == '1' then
          report("slim_modify_test: Unexpected response");
          test_state := fail;
        end if;
        --
        wait until PORTC != 0 for 1005 ms;
        if PORTC != 0 then
          report("slim_modify_test: Unexpected output");
          test_state := fail;
          wait until PORTC == 0;
        end if;
      end loop;
      --
      file_close(event_file);
      --
      report("slim_modify_test: Exit learn mode");
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
      file_open(file_stat, event_file, "./data/learnt_events.dat", read_mode);
      if file_stat != open_ok then
        report("slim_modify_test: Failed to open event data file");
        report("slim_modify_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("slim_modify_test: Check events are unchanged");
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
            if Datmode != 0 then
              wait until Datmode == 0;
            end if;
            --
            if PORTC == last_portc then
              report(report_line);
            else
              report("slim_modify_test: Unexpected output change");
              test_state := fail;
            end if;
          else
            wait until PORTC != last_portc;
            if PORTC == trigger_val then
              report(report_line);
            else
              report("slim_modify_test: Wrong output");
              test_state := fail;
            end if;
          end if;
          --
          last_portc := PORTC;
          readline(event_file, report_line);
        end loop;
      end loop;
      --
      if test_state == pass then
        report("slim_modify_test: PASS");
      else
        report("slim_modify_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process slim_modify_test;
end testbench;
