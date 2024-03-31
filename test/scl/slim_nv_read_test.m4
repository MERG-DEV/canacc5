configuration for "PIC18F2480" is
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 14863 ms;
      report("slim_nv_read_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  slim_nv_read_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    file     data_file  : text;
    variable file_stat  : file_open_status;
    variable file_line  : string;
    variable nv_index   : integer;
    begin
      report("slim_nv_read_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
      --
      wait until RB7 == '1'; -- Booted into SLiM
      report("slim_nv_read_test: Green LED (SLiM) on");
      --
      file_open(file_stat, data_file, "./data/nvs.dat", read_mode);
      if file_stat != open_ok then
        report("slim_nv_read_test: Failed to open node variable data file");
        report("slim_nv_read_test: FAIL");
        PC <= 0;
        wait;
      end if;
      --
      report("slim_nv_read_test: Read Node Variables");
      while endfile(data_file) == false loop
        readline(data_file, file_line);
        report(file_line);
        readline(data_file, file_line);
        read(file_line, nv_index);
        readline(data_file, file_line);
        --
        RXB0D0 <= 16#71#;      -- NVRD, CBUS read node variable by index
        RXB0D1 <= 0;           -- NN high
        RXB0D2 <= 0;           -- NN low
        RXB0D3 <= nv_index;
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
          report("slim_nv_read_test: Unexpected response");
          test_state := fail;
        end if;
      end loop;
      --
      report("slim_nv_read_test: Test past number of Node Variables");
      nv_index := nv_index + 1;
      RXB0D0 <= 16#71#;    -- NVRD, CBUS read node variable by index
      RXB0D1 <= 0;         -- NN high
      RXB0D2 <= 0;         -- NN low
      RXB0D3 <= nv_index;  -- Node Variable index
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
        report("slim_nv_read_test: Unexpected response");
        test_state := fail;
      end if;
      --
      if test_state == pass then
        report("slim_nv_read_test: PASS");
      else
        report("slim_nv_read_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process slim_nv_read_test;
end testbench;
