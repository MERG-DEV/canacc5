set_test_name()dnl

beginning_of_test(37)
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
      report("test_name: Short on 0x0201, 0x0204, output 2 on");
      rx_data(OPC_ASON, 2, 1, 2, 4)
      --
      output_wait_for_change(outputs_port, last_output, 64, "Output 2 on")
      last_output := outputs_port;
      --
      tx_wait_for_message(output 2 feedback (ACON), OPC_ACON, Opcode, 2, Node Number (high), 32, Node Number (low), 33, Event Number (high), 18, Event Number (low))
      --
      report("test_name: Long off 0x0201, 0x0604, output 7 on");
      rx_data(OPC_ACOF, 2, 1, 6, 4)
      --
      output_wait_for_change(outputs_port, last_output, 66, "Outputs 2 & 7 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 7 feedback event);
      --
      report("test_name: Short off 0x0909, 0x0402, output 6 & 7 on");
      rx_data(OPC_ASOF, 9, 9, 4, 2)
      --
      output_wait_for_change(outputs_port, last_output, 64, "Output 2 on")
      last_output := outputs_port;
      output_wait_for_change(outputs_port, last_output, 70, "Outputs 2 6 & 7 on")
      last_output := outputs_port;
      --
      tx_wait_for_message(output 6 feedback (ASOF), OPC_ASOF, Opcode, 0, Node Number (high), 0, Node Number (low), 101, Event Number (high), 70, Event Number (low))
      --
      report("test_name: Short on 0x0909, 0x0402, output 6 & 7 off");
      rx_data(OPC_ASON, 9, 9, 4, 2)
      --
      output_wait_for_change(outputs_port, last_output, 64, "Output 2 on")
      --
-- FIXME feedback should be inverted      tx_wait_for_message(output 6 feedback (ASON), OPC_ASON, Opcode, 4, Node Number (high), 2, Node Number (low), 101, Event Number (high), 70, Event Number (low))
      tx_wait_for_message(output 6 feedback (ASOF), OPC_ASOF, Opcode, 0, Node Number (high), 0, Node Number (low), 101, Event Number (high), 70, Event Number (low))
      --
end_of_test
