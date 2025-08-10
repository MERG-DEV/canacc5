define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(21)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Long poll request 0x0220,0x2112, output 2");
      rx_data(OPC_AREQ, 2, 32, 33, 18) -- AREQ, CBUS long poll request
      tx_wait_for_node_message(OPC_AROF, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short on 0x0201,0x0204, output 2 on");
      rx_data(OPC_ASON, 2, 1, 2, 4) -- ASON, CBUS short on
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      --
      report("test_name: Long poll request 0x0220,0x2112, output 2");
      rx_data(OPC_AREQ, 2, 32, 33, 18) -- AREQ, CBUS long poll request
      tx_wait_for_node_message(OPC_ARON, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short poll request 0x0220,0x6546, output 6");
      rx_data(OPC_ASRQ, 2, 32, 101, 70) -- ASRQ, CBUS short poll request
      tx_wait_for_node_message(OPC_ARSOF, 4, 2, 101, EN high, 70, EN low) -- ARSOF, CBUS short off poll response
      --
      report("test_name: Short off 0x0909,0x0402, output 6 & 7 on");
      rx_data(OPC_ASOF, 9, 9, 4, 2) -- ASOF, CBUS short off
      output_wait_for_change(outputs_port, 64, 70, "test_name: Outputs 6 and 7 on")
      --
      report("test_name: Short poll request 0x2002,0x6546, output 6");
      rx_data(OPC_ASRQ, 32, 2, 101, 70) -- ASRQ, CBUS short poll request
      tx_wait_for_node_message(OPC_ARSON, 4, 2, 101, EN high, 70, EN low) -- ARSOF, CBUS short off poll response
end_of_test
