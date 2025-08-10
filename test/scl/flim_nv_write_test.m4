set_test_name()dnl

beginning_of_test(247)
    data_file_variables
    variable nn_high  : integer;
    variable nn_low   : integer;
    variable nv_index : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Ignore requests not addressed to node");
      data_file_open(flim_ignore.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(nn_high)
        data_file_read(nn_low)
        rx_data(OPC_NVSET, nn_high, nn_low, 1, 1) -- NVRD, CBUS read node variable by index
        tx_check_no_message(2)
        --
      end loop;
      --
      file_close(data_file);
      --
      report("test_name: Read output 2 pulse duration (0 == continuous)");
      rx_data(OPC_NVRD, 4, 2, 7) -- NVRD, CBUS read node variable by index
      tx_wait_for_node_message(OPC_NVANS, 4, 2, 7, NV index, 0, NV value) -- NVANS, CBUS node variable response
      --
      report("test_name: Test output 2");
      rx_data(OPC_ASON, 2, 1, 2, 4) -- ASON, CBUS short on 0x0201,0x0204
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      output_wait_for_no_change(outputs_port, 64, 105) -- Check no change in > 100 milliseconds
      rx_data(OPC_ASOF, 2, 1, 2, 4) -- ASOF, CBUS short off 0x0201,0x0204
      output_wait_for_change(outputs_port, 64, 0, "test_name: Output 2 off")
      --
      report("test_name: Set output 2 for 100 millisecond pulse");
      rx_data(OPC_NVSET, 4, 2, 7, 1) -- NVSET, CBUS node variable set, index 7, value 1
      tx_wait_for_node_message(OPC_WRACK, 4, 2) -- WRACK, CBUS write acknowledge response
      --
      report("test_name: Read modified output 2 pulse duration");
      rx_data(OPC_NVRD, 4, 2, 7) -- NVRD, CBUS read node variable by index
      tx_wait_for_node_message(OPC_NVANS, 4, 2, 7, NV index, 1, NV value) -- NVANS, CBUS node variable response
      --
      report("test_name: Test output 2 doesn't pulse");
      rx_data(OPC_ASON, 2, 1, 2, 4) -- ASON, CBUS short on 0x0201,0x0204
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      output_wait_for_no_change(outputs_port, 64, 95) -- Check no change in < 100 milliseconds
      output_wait_for_change(outputs_port, 64, 0, "test_name: Output 2 pulsed", 18) -- Check no change in > 100 milliseconds
      --
      report("test_name: Node variable index too high");
      rx_data(OPC_NVSET, 4, 2, 13, 1) -- NVSET, CBUS node variable set, index 13, value 1
      -- FIXME tx_wait_for_cmderr_message(OPC_NVANS, 4, 2, CMDERR_INV_NV_IDX)
      tx_check_no_message(2)
      --
      report("test_name: Node variable index too low");
      rx_data(OPC_NVSET, 4, 2, 0, 1) -- NVSET, CBUS node variable set, index 0, value 1
      -- FIXME tx_wait_for_cmderr_message(OPC_NVANS, 4, 2, CMDERR_INV_NV_IDX)
      tx_check_no_message(2)
end_of_test




-- configuration for "PIC18F2480" is
-- end configuration;
-- --
-- testbench for "PIC18F2480" is
-- begin
--   test_timeout: process is
--     begin
--       wait for 163 ms;
--       report("test_name: TIMEOUT");
--       report(PC); -- Crashes simulator, MDB will report current source line
--       PC <= 0;
--       wait;
--     end process test_timeout;
--     --
--   test_name: process is
--     type test_result is (pass, fail);
--     variable test_state  : test_result;
--     file     data_file   : text;
--     variable file_stat   : file_open_status;
--     variable file_line   : string;
--     begin
--       report("test_name: START");
--       test_state := pass;
--       RA2 <= '1'; -- Setup button not pressed
--       RA1 <= '1'; -- Learn off
--       RA0 <= '1'; -- Unlearn off
--       --
--       wait until RB6 == '1'; -- Booted into FLiM
--       report("test_name: Yellow LED (FLiM) on");
--       --
--       file_open(file_stat, data_file, "./data/flim_ignore.dat", read_mode);
--       if file_stat != open_ok then
--         report("test_name: Failed to open ignored addresses data file");
--         report("test_name: FAIL");
--         PC <= 0;
--         wait;
--       end if;
--       --
--       report("test_name: Ignore requests not addressed to node");
--       while endfile(data_file) == false loop
--         readline(data_file, file_line);
--         report(file_line);
--         RXB0D0 <= 16#96#;           -- NVSET, CBUS set node variable by index
--         read(data_file, RXB0D1, 1); -- NN high
--         read(data_file, RXB0D2, 1); -- NN low
--         RXB0D3 <= 1;                -- Index
--         RXB0D4 <= 1;                -- Value
--         RXB0CON.RXFUL <= '1';
--         RXB0DLC.DLC3 <= '1';
--         COMSTAT <= 16#80#;
--         CANSTAT <= 16#0C#;
--         PIR3.RXB0IF <= '1';
--         --
--         TXB1CON.TXREQ <= '0';
--         --
--         wait until RXB0CON.RXFUL == '0';
--         COMSTAT <= 0;
--         --
--         wait until TXB1CON.TXREQ == '1' for 2 ms; -- Test if response sent
--         if TXB1CON.TXREQ == '1' then
--           report("test_name: Unexpected response");
--           test_state := fail;
--         end if;
--       end loop;
--       --
--       file_close(data_file);
--       --
--       report("test_name: Check original output 2 pulse duration");
--       RXB0D0 <= 16#71#;      -- NVRD, CBUS read node variable by index
--       RXB0D1 <= 4;           -- NN high
--       RXB0D2 <= 2;           -- NN low
--       RXB0D3 <= 7;           -- Output 2 pulse duration
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       TXB1CON.TXREQ <= '0';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       wait until TXB1CON.TXREQ == '1';
--       if TXB1D0 != 16#97# then -- NVANS, CBUS node variable response
--         report("test_name: Sent wrong response");
--         test_state := fail;
--       end if;
--       if TXB1D1 != 4 then
--         report("test_name: Sent wrong Node Number (high)");
--         test_state := fail;
--       end if;
--       if TXB1D2 != 2 then
--         report("test_name: Sent wrong Node Number (low)");
--         test_state := fail;
--       end if;
--       if TXB1D3 != 7 then
--         report("test_name: Wrong node variable index");
--         test_state := fail;
--       end if;
--       if TXB1D4 != 0 then
--         report("test_name: Unexpected pulse duration value");
--         test_state := fail;
--       end if;
--       --
--       report("test_name: Change output 2 pulse duration");
--       RXB0D0 <= 16#96#;      -- NVSET, CBUS set node variable by index
--       RXB0D1 <= 4;           -- NN high
--       RXB0D2 <= 2;           -- NN low
--       RXB0D3 <= 7;           -- Output 2 pulse duration
--       RXB0D4 <= 1;           -- 10 milliseconds
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       TXB1CON.TXREQ <= '0';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       wait until TXB1CON.TXREQ == '1';
--       if TXB1D0 != 16#59# then -- WRACK, CBUS write acknowledge response
--         report("test_name: Sent wrong response");
--         test_state := fail;
--       end if;
--       if TXB1D1 != 4 then
--         report("test_name: Sent wrong Node Number (high)");
--         test_state := fail;
--       end if;
--       if TXB1D2 != 2 then
--         report("test_name: Sent wrong Node Number (low)");
--         test_state := fail;
--       end if;
--       --
--       report("test_name: Read back new output 2 pulse duration");
--       RXB0D0 <= 16#71#;      -- NVRD, CBUS read node variable by index
--       RXB0D1 <= 4;           -- NN high
--       RXB0D2 <= 2;           -- NN low
--       RXB0D3 <= 7;           -- Output 2 pulse duration
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       TXB1CON.TXREQ <= '0';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       wait until TXB1CON.TXREQ == '1';
--       if TXB1D0 != 16#97# then -- NVANS, CBUS node variable response
--         report("test_name: Sent wrong response");
--         test_state := fail;
--       end if;
--       if TXB1D1 != 4 then
--         report("test_name: Sent wrong Node Number (high)");
--         test_state := fail;
--       end if;
--       if TXB1D2 != 2 then
--         report("test_name: Sent wrong Node Number (low)");
--         test_state := fail;
--       end if;
--       if TXB1D3 != 7 then
--         report("test_name: Wrong node variable index");
--         test_state := fail;
--       end if;
--       if TXB1D4 != 1 then
--         report("test_name: Incorrect pulse duration value");
--         test_state := fail;
--       end if;
--       --
--       report("test_name: Short on 0x0201,0x0204, trigger output 2");
--       RXB0D0 <= 16#98#;      -- ASON, CBUS short on
--       RXB0D1 <= 2;           -- NN high
--       RXB0D2 <= 1;           -- NN low
--       RXB0D3 <= 2;           -- Event number high
--       RXB0D4 <= 4;           -- Event number low
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       wait until PORTC != 0;
--       if PORTC == 64 then
--         report("test_name: Triggered output 2");
--       else
--         report("test_name: Wrong output");
--         test_state := fail;
--       end if;
--       wait until PORTC == 0 for 141 ms;
--       if PORTC == 64 then
--         report("test_name: Output 2 not pulsed");
--         test_state := fail;
--       end if;
--       --
--       report("test_name: Node variable index too low");
--       RXB0D0 <= 16#96#;      -- NVSET, CBUS set node variable by index
--       RXB0D1 <= 4;           -- NN high
--       RXB0D2 <= 2;           -- NN low
--       RXB0D3 <= 0;
--       RXB0D4 <= 0;
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       -- FIXME No CMDERR
--       --TXB1CON.TXREQ <= '0';
--       --wait until TXB1CON.TXREQ == '1';
--       --if TXB1D0 != 16#6F# then -- CMDERR, CBUS error response
--       --  report("flim_param_test: Sent wrong response");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D1 != 4 then
--       --  report("flim_param_test: Sent wrong Node Number (high)");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D2 != 2 then
--       --  report("flim_param_test: Sent wrong Node Number (low)");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D3 != 10 then -- Invalid node variable index
--       --  report("flim_param_test: Sent wrong error number");
--       --  test_state := fail;
--       --end if;
--       --
--       report("test_name: Node variable index too high");
--       RXB0D0 <= 16#96#;      -- NVSET, CBUS set node variable by index
--       RXB0D1 <= 4;           -- NN high
--       RXB0D2 <= 2;           -- NN low
--       RXB0D3 <= 13;
--       RXB0D4 <= 0;
--       RXB0CON.RXFUL <= '1';
--       RXB0DLC.DLC3 <= '1';
--       COMSTAT <= 16#80#;
--       CANSTAT <= 16#0C#;
--       PIR3.RXB0IF <= '1';
--       --
--       wait until RXB0CON.RXFUL == '0';
--       COMSTAT <= 0;
--       --
--       -- FIXME No CMDERR
--       --TXB1CON.TXREQ <= '0';
--       --wait until TXB1CON.TXREQ == '1';
--       --if TXB1D0 != 16#6F# then -- CMDERR, CBUS error response
--       --  report("flim_param_test: Sent wrong response");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D1 != 4 then
--       --  report("flim_param_test: Sent wrong Node Number (high)");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D2 != 2 then
--       --  report("flim_param_test: Sent wrong Node Number (low)");
--       --  test_state := fail;
--       --end if;
--       --if TXB1D3 != 10 then -- Invalid node variable index
--       --  report("flim_param_test: Sent wrong error number");
--       --  test_state := fail;
--       --end if;
--       --
--      if test_state == pass then
--         report("test_name: PASS");
--       else
--         report("test_name: FAIL");
--       end if;
--       PC <= 0;
--       wait;
--     end process test_name;
-- end testbench;
