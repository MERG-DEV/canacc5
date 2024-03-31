configuration for "PIC18F2480" is
  shared variable Datmode;
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 25687 ms;
      report("flim_unlearn_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  flim_unlearn_test: process is
    type test_result is (pass, fail);
    variable test_state   : test_result;
    file     event_file   : text;
    variable file_stat    : file_open_status;
    variable report_line  : string;
    variable trigger_line : string;
    variable trigger_val  : integer;
    variable last_portc   : integer;
    begin
      report("flim_unlearn_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- DOLEARN off
      RA0 <= '1'; -- UNLEARN off
      --
      wait until RB6 == '1'; -- Booted into FLiM
      report("flim_unlearn_test: Yellow LED (FLiM) on");
      --
      RA1 <= '0'; -- DOLEARN on
      RA0 <= '0'; -- UNLEARN on
      --
      file_open(file_stat, event_file, "./data/unlearn.dat", read_mode);
      if file_stat != open_ok then
        report("slim_unlearn_test: Failed to open unlearn data file");
        report("flim_unlearn_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("flim_unlearn_test: Unlearn events");
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
        if Datmode != 8 then
          wait until Datmode == 8;
        end if;
      end loop;
      --
      file_close(event_file);
      --
      RA1 <= '1'; -- DOLEARN off
      RA0 <= '1'; -- UNLEARN off
      --
      file_open(file_stat, event_file, "./data/not_unlearnt.dat", read_mode);
      if file_stat != open_ok then
        report("slim_unlearn_test: Failed to open event data file");
        report("flim_unlearn_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("flim_unlearn_test: Check events are unchanged");
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
              report("flim_unlearn_test: Unexpected output change");
              test_state := fail;
            end if;
          else
            wait until PORTC != last_portc;
            if PORTC == trigger_val then
              report(report_line);
            else
              report("flim_unlearn_test: Wrong output");
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
        report("flim_unlearn_test: PASS");
      else
        report("flim_unlearn_test: FAIL");
        report(PC); -- Crashes simulator, MDB will report current source line
      end if;          
      PC <= 0;
      wait;
    end process flim_unlearn_test;
end testbench;
