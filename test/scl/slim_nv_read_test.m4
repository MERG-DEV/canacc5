set_test_name()dnl

beginning_of_test(14863)
    data_file_variables
    variable nv_index : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Read Node Variables");
      data_file_open(nvs.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(nv_index)
        rx_data(OPC_NVRD, 0, 0, nv_index) -- NVRD, CBUS read node variable by index
        tx_check_no_message(776)
        --
        readline(data_file, file_line);
      end loop;
      --
      report("test_name: Test past number of Node Variables");
      nv_index := nv_index + 1;
      rx_data(OPC_NVRD, 0, 0, nv_index) -- NVRD, CBUS read node variable by index
      tx_check_no_message(776)
end_of_test
