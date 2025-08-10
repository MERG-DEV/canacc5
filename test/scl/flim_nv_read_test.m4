set_test_name()dnl

beginning_of_test(14863)
    data_file_variables
    variable nn_high  : integer;
    variable nn_low   : integer;
    variable nv_index : integer;
    variable nv_value : integer;
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
        rx_data(OPC_NVRD, nn_high, nn_low, 1) -- NVRD, CBUS read node variable by index
        tx_check_no_message(2)
        --
      end loop;
      --
      file_close(data_file);
      --
      report("test_name: Read Node Variables");
      data_file_open(nvs.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(nv_index)
        data_file_read(nv_value)
        rx_data(OPC_NVRD, 4, 2, nv_index) -- NVRD, CBUS read node variable by index
        tx_wait_for_node_message(OPC_NVANS, 4, 2, nv_index, NV index, nv_value, NV value) -- NVANS, CBUS node variable response
      end loop;
      --
      report("test_name: Test past number of Node Variables");
      nv_index := nv_index + 1;
      rx_data(OPC_NVRD, 4, 2, nv_index) --NVRD, CBUS read node variable by index
      tx_wait_for_node_message(OPC_NVANS, 4, 2, 0, 0) -- NVANS, CBUS node variable response
end_of_test
