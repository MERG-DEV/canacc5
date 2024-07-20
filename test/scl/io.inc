divert(-1)

define(output_check_changed_to,
       if $1 == $2 then
         report($3);
       else
         report("test_name: Output not changed to expected value");
         test_state := fail;
       end if;)

define(output_check_changed_from,
       if $1 != $2 then
         report($3);
       else
         report("test_name: Output not changed");
         test_state := fail;
       end if;)

define(output_wait_for_change,
       {ifelse($5, {}, {--}, report("test_name: Waiting $5 milliseconds for output change");)}
       {ifelse($5, {}, wait until $1 != $2;, wait until $1 != $2 for $5 ms;)}
       {output_check_changed_to($1, $3, $4)})

define(output_check_for_no_change,
       if $1 == $2 then
         report("test_name: Output unchanged");
       else
         report("test_name: Unexpected output change");
         test_state := fail;
       end if;)

define(output_wait_for_no_change,
       report("test_name: Waiting $3 milliseconds for no output change");
       wait until $1 != $2 for $3 ms;
       {output_check_for_no_change($1, $2)})

define(output_wait_for_output,
       {output_wait_for_change($1, 0, $2, $3, $4)})

define(output_wait_for_data_file_output,
       readline(data_file, output_report);
       while match(output_report, "Done") == false loop
         data_file_read(output_value)

         if match(output_report, "No change") then
           wait_until_idle
           --
           if $1 == last_output then
             report(output_report);
           else
             report("test_name: Unexpected output change");
             test_state := fail;
           end if;
         else
           output_wait_for_change($1, last_output, output_value, output_report)
         end if;
         --
         last_output := $1;
         readline(data_file, output_report);
       end loop;)

divert(0)dnl
