define(test_name, flim_teach_poll_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(157)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into fLiM
      --
      report("test_name: Yellow LED (FLiM) on");
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
      enter_learn_mode(4, 2) -- Node 0x0402
      --
      report("test_name: Set output 2 feedback, on 0x0220,0x2112");
      rx_data(OPC_EVLRN, 2, 32, 33, 18, 3, 16#98#) -- EVLRN, CBUS learn event, event variable 3, feedback normal for output 2
      tx_wait_for_node_message(OPC_WRACK, 4, 2)
      --
      report("test_name: Set output 6 feedback, off 0x0000,0x6546");
      rx_data(OPC_EVLRN, 0, 0, 101, 70, 3, 16#C8#) -- EVLRN, CBUS learn event, event variable 3, feedback inverted for output 6
      tx_wait_for_node_message(OPC_WRACK, 4, 2)
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(4, 2) -- Node 0x0402
      --
      report("test_name: Long poll request 0x0220,0x2112, output 2");
      rx_data(OPC_AREQ, 2, 32, 33, 18) -- AREQ, CBUS long poll request
      tx_wait_for_node_message(OPC_AROF, 2, 32, 33, 18) -- AROF, CBUS long off poll response
      --
      report("test_name: Short poll request 0x0220,0x6446, output 6");
      rx_data(OPC_ASRQ, 2, 32, 101, 70) -- ASRQ, CBUS short poll request
      tx_wait_for_node_message(OPC_ARSOF, 4, 2, 101, 70) -- ARSOF, CBUS short off poll response
      --
end_of_test
