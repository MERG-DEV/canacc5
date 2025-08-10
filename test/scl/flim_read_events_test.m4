set_test_name()dnl

beginning_of_test(25)
    data_file_variables
    variable node_hi  : integer;
    variable node_lo  : integer;
    variable event_hi : integer;
    variable event_lo : integer;
    variable ev_index : integer;
    variable ev_value : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Enter learn mode");
      enter_learn_mode(4, 2) -- Node 0x0402
      --
      report("test_name: Read events");
      data_file_open(stored_events.dat)
       --
      while endfile(data_file) == false loop
        data_file_report_line
        --
        data_file_read(node_hi)
        data_file_read(node_lo)
        data_file_read(event_hi)
        data_file_read(event_lo)
        --
        readline(data_file, file_line);
        while match(file_line, "Done") == false loop
          report(file_line);
          read(file_line, ev_index);
          rx_data(OPC_REQEV, node_hi, node_lo, event_hi, event_lo, ev_index) -- REQEV, CBUS Read event variable request
          --
          data_file_report_line
          read(file_line, ev_value);
          tx_wait_for_node_message(OPC_EVANS, node_hi, node_lo, event_hi, EN high, event_lo, EN low, ev_index, Event Variable Index, ev_value, Event Variable value)
          --
          readline(data_file, file_line); -- Get next event variable index
        end loop;
      end loop;
      --
      report("test_name: Event Variable index too low");
      rx_data(OPC_REQEV, node_hi, node_lo, event_hi, event_lo, 0) -- REQEV, CBUS Read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Event Variable index too high");
      rx_data(OPC_REQEV, node_hi, node_lo, event_hi, event_lo, 4) -- REQEV, CBUS Read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Read unknown event");
      rx_data(OPC_REQEV, 9, 8, 7, 6, 1) -- REQEV, CBUS Read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_NO_EV)
      --
end_of_test
