set_test_name()dnl

beginning_of_test(907)
    data_file_variables
    variable nn_high     : integer;
    variable nn_low      : integer;
    variable param_index : integer;
    variable param_value : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Ignore requests not addressed to node");
      data_file_open(slim_ignore.dat)
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
      report("test_name: Read Node Parameters");
      param_index := 0;
      data_file_open(slim_params.dat)
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(param_value)
        rx_data(OPC_RQNPN, 0, 0, param_index) -- RQNPN, CBUS read node parameter by index
        --
        tx_wait_for_node_message(OPC_PARAN, 0, 0, param_index, Parameter index, param_value, Parameter value) -- PARAN, CBUS individual parameter response
        --
        param_index := param_index + 1;
      end loop;
      --
      report("test_name: Test past number of parameters");
      rx_data(OPC_RQNPN, 0, 0, param_index) -- RQNPN, CBUS read node parameter by index
      tx_wait_for_cmderr_message(0, 0, CMDERR_INV_PARAM_IDX)
end_of_test
