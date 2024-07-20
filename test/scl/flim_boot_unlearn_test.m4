define(test_name, flim_boot_unlearn_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(23285)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_on
      --
      wait_until_flim -- Booted into FLiM
      --
      set_unlearn_off
      --
      report("test_name: Check available event space");
      rx_data(OPC_NNEVN, 4, 2) -- CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123, available event space) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Check number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 5, number of stored events) -- EVLNF, CBUS available event space response node 4 2
      --
      report("test_name: Check events");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
