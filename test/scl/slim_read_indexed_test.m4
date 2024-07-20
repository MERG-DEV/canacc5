define(test_name, slim_read_indexed_test)dnl
include(common.inc)dnl
include(data_file.inc)dnl
include(rx_tx.inc)dnl
include(io.inc)dnl
include(hardware.inc)dnl
include(cbusdefs.inc)dnl

beginning_of_test(65)
    data_file_variables
    variable event_index : integer;
    variable ev_index    : integer;
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_slim -- Booted into SLiM
      --
      report("test_name: Enter learn mode");
      rx_data(OPC_NNLRN, 0, 0) -- NNLRN, CBUS enter learn mode to node 0 0
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
          rx_data(OPC_REVAL, 0, 0, event_index, ev_index) -- REVAL, CBUS Indexed read event variable request
          tx_check_for_no_message(2)
          --
          readline(data_file, file_line); -- Skip event variable value
          readline(data_file, file_line); -- Get next event variable index
        end loop;
        --
        event_index := event_index + 1;
      end loop;
      --
      event_index := event_index - 1;
      report("test_name: Event Variable index too low");
      rx_data(OPC_REVAL, 0, 0, event_index, 0) -- REVAL, CBUS Indexed read event variable request
      tx_check_for_no_message(2)
      --
      report("test_name: Event Variable index too high");
      rx_data(OPC_REVAL, 0, 0, event_index, 4) -- REVAL, CBUS Indexed read event variable request
      tx_check_for_no_message(2)
      --
      report("test_name: Event index too low");
      rx_data(OPC_REVAL, 0, 0, 0, 1) -- REVAL, CBUS Indexed read event variable request
      tx_check_for_no_message(2)
      --
      report("test_name: Event index too high");
      event_index := event_index + 1;
      rx_data(OPC_REVAL, 0, 0, event_index, 1) -- REVAL, CBUS Indexed read event variable request
      tx_check_for_no_message(2)
      --
end_of_test
