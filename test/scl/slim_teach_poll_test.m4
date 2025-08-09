define(test_name, slim_teach_poll_test)dnl

beginning_of_test(1575)
    begin_test
      --
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Long poll request 0x0220,0x2112, output 2");
      rx_data(OPC_AREQ, 2, 32, 33, 18) -- AREQ, CBUS long poll request
      tx_check_for_no_message(5, output 2 poll response)
      --
      report("test_name: Short poll request 0x0220,0x6446, output 6");
      rx_data(OPC_ASRQ, 2, 32, 101, 70) -- ASRQ, CBUS short poll request
      tx_check_for_no_message(5, output 6 poll response)
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Set output 2 feedback, on 0x0220,0x2112");
      rx_data(OPC_EVLRN, 2, 32, 33, 18, 3, 16#98#) -- EVLRN, CBUS learn event, event variable 3, feedback normal for output 2
      tx_check_no_message(776);
      --
      report("test_name: Set output 6 feedback, off 0x0000,0x6546");
      rx_data(OPC_EVLRN, 0, 0, 101, 70, 3, 16#C8#) -- EVLRN, CBUS learn event, event variable 3, feedback inverted for output 6
      tx_check_no_message(776);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(0, 0) -- Node 0x0000
      --
      report("test_name: Short off 0x0201,0x0204, output 2 off");
      rx_data(OPC_ASOF, 2, 1, 2, 4)
      --
      report("test_name: Long poll request 0x0220,0x2112, output 2");
      rx_data(OPC_AREQ, 2, 32, 33, 18) -- AREQ, CBUS long poll request
      tx_check_for_no_message(5, output 2 poll response)
      --
      report("test_name: Short poll request 0x0220,0x6446, output 6");
      rx_data(OPC_ASRQ, 2, 32, 101, 70) -- ASRQ, CBUS short poll request
      tx_check_for_no_message(5, output 6 poll response)
      --
end_of_test
