define(test_name, slim_boot_test)dnl

beginning_of_test(847)
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
        data_file_skip_till_done
        wait_until_idle
        output_check_for_no_change(outputs_port, 0)
      end loop;
      --
      if flim_led == '1' then
        report("test_name: Yellow LED (FLiM) on");
        test_state := fail;
      end if;
      --
end_of_test
