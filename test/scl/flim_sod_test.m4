define(test_name, flim_sod_test)dnl
include(common.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(1000)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
     --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Long on 0x0220,0x2112, SoD");
      rx_data(OPC_ACON, 2, 32, 33, 18)
-- FIXME feedback should be inverted       tx_wait_for_node_message(OPC_ASON, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ASOF, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ACOF, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short on 0x0201,0x0204, output 2 on");
      rx_data(OPC_ASON, 2, 1, 2, 4)
      output_wait_for_output(outputs_port, 64, "test_name: Output 2 on")
      --
      report("test_name: Long off 0x0220,0x2112, SoD");
      rx_data(OPC_ACOF, 2, 32, 33, 18)
-- FIXME feedback should be inverted       tx_wait_for_node_message(OPC_ASON, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ASOF, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ACON, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short on 0x0220,0x6546, SoD");
      rx_data(OPC_ASON, 2, 32, 101, 70)
-- FIXME feedback should be inverted       tx_wait_for_node_message(OPC_ASON, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ASOF, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ACON, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short off 0x0909,0x0402, output 6 & 7 on");
      rx_data(OPC_ASOF, 9, 9, 4, 2)
      output_wait_for_change(outputs_port, 64, 70, "test_name: Outputs 2 6 & 7 on")
      --
      report("test_name: Short off 0x0220,0x6546, SoD");
      rx_data(OPC_ASOF, 2, 32, 101, 70)
      tx_wait_for_node_message(OPC_ASOF, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ACON, 2, 32, 33, EN high, 18, EN low)
      --
      report("test_name: Short on 0x0909,0x0402, output 6 & 7 off");
      rx_data(OPC_ASON, 9, 9, 4, 2)
      output_wait_for_change(outputs_port, 70, 64, "test_name: Outputs 2 on")
      --
      report("test_name: Short on 0x0220,0x6546, SoD");
      rx_data(OPC_ASON, 2, 32, 101, 70)
-- FIXME feedback should be inverted       tx_wait_for_node_message(OPC_ASON, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ASOF, 4, 2, 101, EN high, 70, EN low)
      tx_wait_for_node_message(OPC_ACON, 2, 32, 33, EN high, 18, EN low)
end_of_test
