define(test_name, flim_index_events_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(1623)
    data_file_variables
    variable event_index : integer;
    variable ev_node_hi  : integer;
    variable ev_node_lo  : integer;
    variable ev_ev_hi    : integer;
    variable ev_ev_lo    : integer;
    begin_test
      set_setup_off
      set_dolearn_on
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Ignore read events request not addressed to node");
      rx_data(OPC_NERD, 0, 0) -- NERD, CBUS Read events request, node 0 0
      tx_check_no_message(776)  -- Test if unexpected response sent
      --
      report("test_name: Read events");
      data_file_open(stored_events.dat)
      rx_data(OPC_NERD, 4, 2) -- NERD, CBUS Read events request, node 4 2
      --
      event_index := 1;
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(ev_node_hi)
        data_file_read(ev_node_lo)
        data_file_read(ev_ev_hi)
        data_file_read(ev_ev_lo)
        tx_wait_for_node_message(OPC_ENRSP, 4, 2, ev_node_hi, event node high, ev_node_lo, event node low, ev_ev_hi, event event high, ev_ev_lo, event event low, event_index, event index) -- ENRSP, CBUS stored event response
        --
        data_file_skip_till_done
        event_index := event_index + 1;
      end loop;
      --
      tx_check_no_message(776) -- Test if response sent
      --
end_of_test
