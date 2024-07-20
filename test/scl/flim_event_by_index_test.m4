define(test_name, flim_event_by_index_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(789)
    data_file_variables
    variable event_index : integer;
    variable ev_node_hi  : integer;
    variable ev_node_lo  : integer;
    variable ev_ev_hi    : integer;
    variable ev_ev_lo    : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Ignore read events by index not addressed to node");
      rx_data(OPC_NENRD, 0, 0, 1) -- NENRD, CBUS Read event by index request, node 0, index 1
      --
      tx_check_no_message(776)
      --
      report("test_name: Read events");
      data_file_open(stored_events.dat)
      --
      event_index := 1;
      while endfile(data_file) == false loop
        data_file_report_line
        data_file_read(ev_node_hi)
        data_file_read(ev_node_lo)
        data_file_read(ev_ev_hi)
        data_file_read(ev_ev_lo)
        --
        rx_data(OPC_NENRD, 4, 2, event_index) -- NENRD, CBUS Read event by index request to node 4 2
        tx_wait_for_node_message(OPC_ENRSP, 4, 2, ev_node_hi, event node high, ev_node_lo, event node low, ev_ev_hi, event event high, ev_ev_lo, event event low, event_index, event index) -- ENRSP, CBUS stored event response
        --
        data_file_skip_till_done
        event_index := event_index + 1;
      end loop;
      --
      report("test_name: Reject request with too high event index");
      rx_data(OPC_NENRD, 4, 2, event_index) -- NENRD, CBUS Read event by index request to node 4 2
      tx_wait_for_cmderr_message(4, 2, CMDERR_INVALID_EVENT) -- CBUS error response
      --
      report("test_name: Event index too low");
      rx_data(OPC_NENRD, 4, 2, 0) -- NENRD, CBUS Read event by index request to node 4 2
      tx_wait_for_cmderr_message(4, 2, CMDERR_INVALID_EVENT) -- CBUS error response
      --
end_of_test
