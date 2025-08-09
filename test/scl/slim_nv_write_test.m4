define(test_name, slim_nv_write_test)dnl

beginning_of_test(1012)
    data_file_variables
    variable nv_index : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Test output 2");
      rx_data(OPC_ASON, 2, 1, 2, 4) -- ASON, CBUS short on 0x0201,0x0204
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      output_wait_for_no_change(outputs_port, 64, 105) -- Check no change in > 100 milliseconds
      rx_data(OPC_ASOF, 2, 1, 2, 4) -- ASOF, CBUS short off 0x0201,0x0204
      output_wait_for_change(outputs_port, 64, 0, "test_name: Output 2 off")
      --
      report("flim_nv_write_test: Set output 2 for 100 millisecond pulse");
      rx_data(OPC_NVSET, 0, 0, 7, 1) -- NVSET, CBUS node variable set, index 7, value 1
      tx_check_no_message(776) -- Cannot set NV in SLiM so no WRACK
      --
      report("test_name: Test output 2 doesn't pulse");
      rx_data(OPC_ASON, 2, 1, 2, 4) -- ASON, CBUS short on 0x0201,0x0204
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      output_wait_for_no_change(outputs_port, 64, 113) -- Check no change in > 100 milliseconds
end_of_test
