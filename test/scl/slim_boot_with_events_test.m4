define(test_name, slim_boot_with_events_test)dnl
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
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
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
      report("test_name: Request available event space");
      rx_data(OPC_NNEVN, 0, 0) -- CBUS request available event space to node 4 2
      tx_check_for_no_message(776)
      --
      report("test_name: Request number of stored events");
      rx_data(OPC_RQEVN, 0, 0) -- CBUS request number of stored events to node 4 2
      tx_check_for_no_message(776)
      --
end_of_test
