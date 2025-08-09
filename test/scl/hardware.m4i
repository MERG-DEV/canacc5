divert(-1)
define(slim_idle_datmode, 0)
define(flim_idle_datmode, 8)
define(learn_datmode, 16)
define(wait_until_idle,
       if Datmode != idle_datmode then
         wait until Datmode == idle_datmode;
       end if;)

define(enter_learn_mode,
       if idle_datmode != slim_idle_datmode then
         idle_datmode := idle_datmode + learn_datmode;
       end if;
       rx_data(OPC_NNLRN, $1, $2) -- NNLRN, CBUS enter learn mode
       wait_until_idle)

define(exit_learn_mode,
       if idle_datmode != slim_idle_datmode then
         idle_datmode := idle_datmode - learn_datmode;
       end if;
       rx_data(OPC_NNULN, $1, $2) -- NNULN, CBUS exit learn mode
       wait_until_idle)

define(flim_led, RB6)
define(wait_until_flim,
       wait until flim_led == '1';
       idle_datmode := flim_idle_datmode;
       report("test_name: Yellow LED (FLiM) on");)

define(slim_led, RB7)
define(wait_until_slim,
       wait until slim_led == '1';
       idle_datmode := slim_idle_datmode;
       report("test_name: Green LED (SLiM) on");)

define(setup_button, RA2)
define(set_setup_off, setup_button <= '1';)
define(set_setup_on, setup_button <= '0';)

define(dolearn_switch, RA1)
define(set_dolearn_off, dolearn_switch <= '1';)
define(set_dolearn_on, dolearn_switch <= '0';)

define(unlearn_switch, RA0)
define(set_unlearn_off, unlearn_switch <= '1';)
define(set_unlearn_on, unlearn_switch <= '0';)

define(polarity_switch, RB5)
define(set_polarity_normal, polarity_switch <= '1';)
define(set_polarity_inverted, polarity_switch <= '0';)

define(outputs_port, PORTC)
define(sel0_switch, RB0)
define(sel1_switch, RB1)
define(sel2_switch, RB4)

define(select_output_1,
       sel0_switch <= 1; -- Sel 0 off
       sel1_switch <= 1; -- Sel 1 off
       sel2_switch <= 1; -- Sel 2 off
)

define(select_output_2,
       sel0_switch <= 0; -- Sel 0 on
       sel1_switch <= 1; -- Sel 1 off
       sel2_switch <= 1; -- Sel 2 off
)

define(select_output_3,
       sel0_switch <= 1; -- Sel 0 off
       sel1_switch <= 0; -- Sel 1 on
       sel2_switch <= 1; -- Sel 2 off
)

define(select_output_4,
       sel0_switch <= 0; -- Sel 0 on
       sel1_switch <= 0; -- Sel 1 on
       sel2_switch <= 1; -- Sel 2 off
)

define(select_output_5,
       sel0_switch <= 1; -- Sel 0 off
       sel1_switch <= 1; -- Sel 1 off
       sel2_switch <= 0; -- Sel 2 on
)

define(select_output_6,
       sel0_switch <= 0; -- Sel 0 on
       sel1_switch <= 1; -- Sel 1 off
       sel2_switch <= 0; -- Sel 2 on
)

define(select_output_7,
       sel0_switch <= 1; -- Sel 0 off
       sel1_switch <= 0; -- Sel 1 on
       sel2_switch <= 0; -- Sel 2 on
)

define(select_output_8,
       sel0_switch <= 0; -- Sel 0 on
       sel1_switch <= 0; -- Sel 1 on
       sel2_switch <= 0; -- Sel 2 on
)

define(data_file_select_output_and_polarity,
       readline(data_file, file_line);
       read(file_line, sel0_switch);
       readline(data_file, file_line);
       read(file_line, sel1_switch);
       readline(data_file, file_line);
       read(file_line, sel2_switch);
       readline(data_file, file_line);
       read(file_line, polarity_switch);
)
divert(0)dnl
