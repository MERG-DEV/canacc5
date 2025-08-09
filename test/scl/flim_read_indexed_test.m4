define(test_name, flim_read_indexed_test)dnl

beginning_of_test(25)
    data_file_variables
    variable event_index : integer;
    variable ev_index    : integer;
    variable ev_value    : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      --
      report("test_name: Enter learn mode");
      rx_data(OPC_NNLRN, 4, 2) -- NNLRN, CBUS enter learn mode to node 4 2
      wait for 1 ms; -- FIXME Next packet lost if previous not yet processed
     --
      report("test_name: Read events");
      data_file_open(stored_events.dat)
       --
      event_index := 1;
      while endfile(data_file) == false loop
        data_file_report_line
        --
        -- Skip node and event numbers
        readline(data_file, file_line); -- NN high
        readline(data_file, file_line); -- NN low
        readline(data_file, file_line); -- EN high
        readline(data_file, file_line); -- EN low
        --
        readline(data_file, file_line);
        while match(file_line, "Done") == false loop
          report(file_line);
          read(file_line, ev_index);
          rx_data(OPC_REVAL, 4, 2, event_index, ev_index) -- REVAL, CBUS Indexed read event variable request
          --
          data_file_report_line
          read(file_line, ev_value);
          tx_wait_for_node_message(OPC_NEVAL, 4, 2, event_index, Event Index, ev_index, Event Variable Index, ev_value, Event Variable value) -- NEVAL, CBUS Indexed event variable response
          --
          readline(data_file, file_line); -- Get next event variable index
        end loop;
        --
        event_index := event_index + 1;
      end loop;
      --
      event_index := event_index - 1;
      report("test_name: Event Variable index too low");
      rx_data(OPC_REVAL, 4, 2, event_index, 0) -- REVAL, CBUS Indexed read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Event Variable index too high");
      rx_data(OPC_REVAL, 4, 2, event_index, 4) -- REVAL, CBUS Indexed read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INV_EV_IDX)
      --
      report("test_name: Event index too low");
      rx_data(OPC_REVAL, 4, 2, 0, 1) -- REVAL, CBUS Indexed read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INVALID_EVENT)
      --
      report("test_name: Event index too high");
      event_index := event_index + 1;
      rx_data(OPC_REVAL, 4, 2, event_index, 1) -- REVAL, CBUS Indexed read event variable request
      tx_wait_for_cmderr_message(4, 2, CMDERR_INVALID_EVENT)
      --
end_of_test
