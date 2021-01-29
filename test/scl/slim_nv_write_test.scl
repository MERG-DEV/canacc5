configuration for "PIC18F2480" is
end configuration;
--
testbench for "PIC18F2480" is
begin
  test_timeout: process is
    begin
      wait for 873 ms;
      report("slim_nv_write_test: TIMEOUT");
      report(PC); -- Crashes simulator, MDB will report current source line
      PC <= 0;
      wait;
    end process test_timeout;
    --
  slim_nv_write_test: process is
    type test_result is (pass, fail);
    variable test_state : test_result;
    begin
      report("slim_nv_write_test: START");
      test_state := pass;
      RA2 <= '1'; -- Setup button not pressed
      RA1 <= '1'; -- Learn off
      RA0 <= '1'; -- Unlearn off
     --
      wait until RB7 == '1'; -- Booted into SLiM
      report("slim_nv_write_test: Green LED (SLiM) on");
      --
      report("slim_nv_write_test: Change 3A fire time");
      RXB0D0 <= 16#96#;      -- NVSET, CBUS set node variable by index
      RXB0D1 <= 0;           -- NN high
      RXB0D2 <= 0;           -- NN low
      RXB0D3 <= 5;           -- Output 3A fire time
      RXB0D4 <= 2;
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
        report("slim_nv_write_test: Unexpected response");
        test_state := fail;
      end if;
      --
      report("slim_nv_write_test: Test long off 0x0102,0x0204, output 6 on");
      RXB0D0 <= 16#91#;      -- ACOF, CBUS long off
      RXB0D1 <= 1;           -- NN high
      RXB0D2 <= 2;           -- NN low
      RXB0D3 <= 2;           -- Event number high
      RXB0D4 <= 4;           -- Event number low
      RXB0CON.RXFUL <= '1';
      RXB0DLC.DLC3 <= '1';
      COMSTAT <= 16#80#;
      CANSTAT <= 16#0C#;
      PIR3.RXB0IF <= '1';
      --
      wait until RXB0CON.RXFUL == '0';
      COMSTAT <= 0;
      --
      wait until PORTC != 0;
      if PORTC == 4 then
        report("slim_nv_write_test: Output 6 on");
      else
        report("slim_nv_write_test: Wrong output");
        test_state := fail;
      end if;
      --
      if test_state == pass then
        report("slim_nv_write_test: PASS");
      else
        report("slim_nv_write_test: FAIL");
      end if;          
      PC <= 0;
      wait;
    end process slim_nv_write_test;
end testbench;
