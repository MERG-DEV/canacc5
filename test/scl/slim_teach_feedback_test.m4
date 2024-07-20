define(test_name, slim_teach_feedback_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(1615)
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
      report("test_name: Short on 0x0201,0x0204, output 2 on");
      rx_data(OPC_ASON, 2, 1, 2, 4)
      --
      output_wait_for_change(outputs_port, last_output, 64, "test_name: Output 2 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 2 feedback)
      --
      report("test_name: Long off 0x0201, 0x0604, output 7 on");
      rx_data(OPC_ACOF, 2, 1, 6, 4)
      --
      output_wait_for_change(outputs_port, last_output, 66, "test_name: Outputs 2 7 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 7 feedback);
      --
      report("test_name: Short off 0x0909, 0x0402, outputs 6 7 on");
      rx_data(OPC_ASOF, 9, 9, 4, 2)
      --
      output_wait_for_change(outputs_port, last_output, 64, "test_name: Output 2 on 7 off")
      last_output := outputs_port;
      output_wait_for_change(outputs_port, last_output, 70, "test_name: Outputs 2 6 7 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 6 or 7 feedback);
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Set output 2 feedback, on 0x0220,0x02112");
      rx_data(OPC_EVLRN, 2, 32, 33, 18, 3, 16#98#) -- EVLRN, CBUS learn event, event variable 3, feedback normal for output 2
      tx_check_no_message(776);
      --
      report("test_name: Set output 6 feedback, off 0x0660,0x6546");
      rx_data(OPC_EVLRN, 6, 96, 101, 70, 3, 16#C8#) -- EVLRN, CBUS learn event, event variable 3, feedback inverted for output 6
      tx_check_no_message(776);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Short off 0x0201,0x0204, output 2 off");
      rx_data(OPC_ASOF, 2, 1, 2, 4)
      --
      output_wait_for_change(outputs_port, last_output, 6, "test_name: Output 2 off 6 7 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 2 feedback)
      --
      report("test_name: Long on 0x0201,0x0604, output 7 off");
      rx_data(OPC_ACON, 2, 1, 6, 4)
      --
      output_wait_for_change(outputs_port, last_output, 4, "test_name: Output 7 off 6 on")
      last_output := outputs_port;
      --
      tx_check_for_no_message(5, output 7 feedback)
      --
      report("test_name: Short on 0x0909,0x0402, outputs 6 7 off");
      rx_data(OPC_ASON, 9, 9, 4, 2)
      --
      output_wait_for_change(outputs_port, last_output, 0, "test_name: Output 6 off")
     --
      tx_check_for_no_message(5, output 6 or 7 feedback)
      --
end_of_test
