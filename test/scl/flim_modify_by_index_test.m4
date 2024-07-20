define(test_name, flim_modify_by_index_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(33372)
    data_file_variables
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(4, 2)
      --
      report("test_name: Modify events");
      data_file_open(modify_indexed.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_indexed_learn
        data_file_skip_till_done
        -- CANACC5 does not implement learn by index so no WRACK expected
        tx_check_no_message(776)
      end loop;
      --
      file_close(data_file);
      --
      report("test_name: Exit learn mode");
      exit_learn_mode(4, 2)
      --
      report("test_name: Check available event space");
      rx_data(OPC_NNEVN, 4, 2) -- NNEVN, CBUS request available event space to node 4 2
      tx_wait_for_node_message(OPC_EVNLF, 4, 2, 123) -- EVLNF, CBUS available event space response
      --
      report("test_name: Check number of stored events");
      rx_data(OPC_RQEVN, 4, 2) -- RQEVN, CBUS request number of stored events to node 4 2
      tx_wait_for_node_message(OPC_NUMEV, 4, 2, 5, number of stored events) -- NNEVN, CBUS number of stored events response
      --

      -- CANACC5 does not implement learn by index so events are unmodified
      report("test_name: Check events are unchanged");
      data_file_open(learnt_events.dat)
      --
      while endfile(data_file) == false loop
        data_file_report_line
        rx_data_file_event
        output_wait_for_data_file_output(outputs_port)
      end loop;
      --
end_of_test
