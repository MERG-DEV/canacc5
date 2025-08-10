define(test_name, patsubst(__file__, {.m4},))dnl

beginning_of_test(65)
    data_file_variables
    variable node_hi  : integer;
    variable node_lo  : integer;
    variable event_hi : integer;
    variable event_lo : integer;
    variable ev_index : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Enter learn mode");
      rx_data(OPC_NNLRN, 0, 0) -- NNLRN, CBUS enter learn mode to node 0 0
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
          tx_check_for_no_message(2)
          --
          readline(data_file, file_line); -- Skip event variable value
          readline(data_file, file_line); -- Get next event variable index
        end loop;
      end loop;
      --
      report("test_name: Event Variable index too low");
      rx_data(OPC_REQEV, node_hi, node_lo, event_hi, event_lo, 0) -- REQEV, CBUS Read event variable request
      tx_check_for_no_message(2)
      --
      report("test_name: Event Variable index too high");
      rx_data(OPC_REQEV, node_hi, node_lo, event_hi, event_lo, 4) -- REQEV, CBUS Read event variable request
      tx_check_for_no_message(2)
      --
end_of_test
