divert(-1)

define(data_file_variables,
       file     data_file     : text;
       variable file_stat     : file_open_status;
       variable file_line     : string;
       variable output_report : string;
       variable output_value  : integer;
       variable last_output   : integer;)

define(data_file_open,
       file_open(file_stat, data_file, "./data/$1", read_mode);
       if file_stat != open_ok then
         report("test_name: Failed to open unlearn $1");
         report("test_name: FAIL");
         PC <= 0;
         wait;
       end if;)

define(data_file_report_line,
       readline(data_file, file_line);
       report(file_line);)

define(data_file_read,
       readline(data_file, file_line);
       read(file_line, $1);)

define(data_file_skip_till_done,
       readline(data_file, file_line);
       while match(file_line, "Done") == false loop
         readline(data_file, file_line);
       end loop;)

divert(0)dnl
