define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(3665)
    variable last_output : integer;
    begin_test
      last_output := 0;
      --
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Test long on 0x0102,0x0402");
      rx_data(OPC_ACON, 1, 2, 4, 2) -- ACON, CBUS long on
      output_wait_for_no_change(outputs_port, last_output, 1005)
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Teach long 0x0102,0x0402");
      rx_data(OPC_EVLRN, 1, 2, 4, 2, 1, 4) -- EVLRN, CBUS learn event, event variable 1, normal output 6
      tx_check_for_no_message(776);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Test long on 0x0102,0x0402");
      rx_data(OPC_ACON, 1, 2, 4, 2) -- ACON, CBUS long on
      output_wait_for_no_change(outputs_port, last_output, 1005)
      --
end_of_test
