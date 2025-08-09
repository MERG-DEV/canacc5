define(test_name, flim_boot_maximum_events_test)dnl

beginning_of_test(88)
    begin_test
      set_setup_off
      set_dolearn_off
      set_unlearn_off
      --
      wait_until_flim -- Booted into FLiM
      --
      report("test_name: Long on 0x0102, 0x0180");
      rx_data(OPC_ACON, 1, 2, 1, 128) -- ACON, CBUS accessory on
      --
      output_wait_for_output(outputs_port, 64, "2 on")
      --
end_of_test
