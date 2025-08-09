define(test_name, flim_tx_arbitration_test)dnl

beginning_of_test(160)
    data_file_variables
    variable tx_count   : integer;
    variable sidh_val   : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Request Node Parameter");
      rx_data(OPC_RQNPN, 4, 2, 0) -- RQNPN, CBUS read node parameter by index
      --
      report("test_name: Loosing arbitration raises Tx priority");
      data_file_open(flim_sidh.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(tx_count)
        data_file_read(sidh_val)
        --
        while tx_count > 0 loop
          tx_wait_if_not_ready
          if TXB1SIDH == sidh_val then
            --
          else
            report("test_name: Wrong SIDH");
            test_state := fail;
          end if;
          TXB1CON.TXLARB <= '1';
          CANSTAT <= 16#02#;
          PIR3.ERRIF <= '1';
          wait until INTCON < 128;
          wait until INTCON > 127;
          tx_count := tx_count - 1;
        end loop;
      end loop;
      --
end_of_test
