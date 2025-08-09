divert(-1)

define(tx_check_data,
       if $1 != $2 then
         report("test_name: $3 != $2");
         test_state := fail;
       end if;)

define(tx_test_data,
       {ifelse( $2, {}, {--}, tx_check_data($1,  $2,   $3))})

define(tx2_wait_if_not_ready,
       if TXB2CON.TXREQ == '0' then
         {ifelse($1, {}, report("test_name: Awaiting Tx2");, report("test_name: Awaiting Tx2 for $1 ms");)}
         {ifelse($1, {}, wait until TXB2CON.TXREQ == '1';, wait until TXB2CON.TXREQ == '1' for $1 ms;)}
       end if;
       if TXB2CON.TXREQ == '1' then
         report("test_name: Tx2");
       else
         {ifelse($1, {}, report("test_name: No Tx2");, report("test_name: No Tx2 in $1 ms");)}
       end if;)

define(tx_wait_for_rtr_response,
       tx2_wait_if_not_ready
       TXB2CON.TXREQ <= '0';
       report("test_name: RTR response sent");
       {tx_check_data(TXB2SIDH,  $1,   RTR SIDH)}
       {tx_check_data(TXB2SIDL,  $2,   RTR SIDL)}
       {tx_check_data(TXB2DLC,    0,   RTR data length)})

define(tx_check_no_rtr_response,
       {tx2_wait_if_not_ready($1)}
       if TXB2CON.TXREQ == '1' then
         report("test_name: Unexpected RTR response sent");
         test_state := fail;
         TXB2CON.TXREQ <= '0';
       else
         report("test_name: No RTR response sent in $1 ms");
       end if;)

define(tx_wait_if_not_ready,
       if TXB1CON.TXREQ == '0' then
         {ifelse($1, {}, report("test_name: Awaiting Tx");, report("test_name: Awaiting Tx for $1 ms");)}
         {ifelse($1, {}, wait until TXB1CON.TXREQ == '1';, wait until TXB1CON.TXREQ == '1' for $1 ms;)}
       end if;
       if TXB1CON.TXREQ == '1' then
         report("test_name: Tx");
       else
         {ifelse($1, {}, report("test_name: No Tx");, report("test_name: No Tx in $1 ms");)}
       end if;)

define(tx_check_for_no_message,
       report("test_name: Checking no Tx of $2 for $1 ms");
       if TXB1CON.TXREQ == '0' then
         wait until TXB1CON.TXREQ == '1' for $1 ms;
       end if;
       if TXB1CON.TXREQ == '1' then
         report("test_name: Unexpected Tx");
         test_state := fail;
         TXB1CON.TXREQ <= '0';
       end if;)

define(tx_check_no_message,
       {ifelse($1, {}, {--}, tx_wait_if_not_ready($1))}
       if TXB1CON.TXREQ == '1' then
         report("test_name: Unexpected message sent");
         test_state := fail;
         TXB1CON.TXREQ <= '0';
       else
         {ifelse($1, {}, report("test_name: No message sent");, report("test_name: No message sent in $1 ms");)}
       end if;)

define(tx_wait_for_message,
       report("test_name: Waiting for Tx of $1");
       tx_wait_if_not_ready
       TXB1CON.TXREQ <= '0';
       {tx_test_data(TXB1D0,  $2,   $3)}
       {tx_test_data(TXB1D1,  $4,   $5)}
       {tx_test_data(TXB1D2,  $6,   $7)}
       {tx_test_data(TXB1D3,  $8,   $9)}
       {tx_test_data(TXB1D4, $10,  $11)}
       {tx_test_data(TXB1D5, $12,  $13)}
       {tx_test_data(TXB1D6, $14,  $15)}
       {tx_test_data(TXB1D7, $16,  $17)})

define(tx_wait_for_node_message,
       {tx_wait_for_message(node message, $1, Opcode, $2, Node Number (high), $3, Node Number (low), $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)})

define(tx_wait_for_cmderr_message,
       {tx_wait_for_message(command error, OPC_CMDERR, Opcode, $1, Node Number (high), $2, Node Number (low), $3, error number)})

define(tx_rtr,
       tx_wait_if_not_ready
       TXB1CON.TXREQ <= '0';
       if TXB1DLC.TXRTR == '1' then
         report("test_name: RTR request");
       else
         report("test_name: not RTR request");
         test_state := fail;
       end if;)

define(tx_check_can_id,
       if TXB1SIDH != $2 then
         report("test_name: Incorrect $1 CAN Id SIDH");
         test_state := fail;
       end if;
       if TXB1SIDL != $3 then
         report("test_name: Incorrect $1 CAN Id SIDL");
         test_state := fail;
       end if;
       if test_state != fail then
         report("test_name: Correct $1 CAN Id");
       end if;)

define(tx_can_id,
       tx_wait_if_not_ready
       TXB1CON.TXREQ <= '0';
       tx_check_can_id($1, $2, $3))

define(rx_wait_if_not_ready,
       if RXB0CON.RXFUL != '0' then
         report("test_name: Waiting to Rx");
         wait until RXB0CON.RXFUL == '0';
         report("test_name: Ready to Rx");
       end if;)

define(rx_frame,
       RXB0CON.RXFUL <= '1';
       RXB0DLC <= 16#0$1#;
       COMSTAT <= 16#80#;
       CANSTAT <= 16#0C#;
       PIR3.RXB0IF <= '1';
       rx_wait_if_not_ready
       COMSTAT <= 0;
       report("test_name: Rx");)

define(rx_rtr,
       rx_frame(40))

define(rx_sid,
       RXB0SIDH <= $1;
       RXB0SIDL <= $2;
       rx_frame(0))

define(rx_load_data,
       {ifelse($2, {}, $1 <= 0;, $1 <= $2;)})

define(rx_data,
       {rx_load_data(RXB0D0, $1)}
       {rx_load_data(RXB0D1, $2)}
       {rx_load_data(RXB0D2, $3)}
       {rx_load_data(RXB0D3, $4)}
       {rx_load_data(RXB0D4, $5)}
       {rx_load_data(RXB0D5, $6)}
       {rx_load_data(RXB0D6, $7)}
       {rx_load_data(RXB0D7, $8)}
       {rx_frame($#)})

define(rx_data_file_event,
       read(data_file, RXB0D0, 1); -- Opcode
       read(data_file, RXB0D1, 1); -- Node high
       read(data_file, RXB0D2, 1); -- Node low
       read(data_file, RXB0D3, 1); -- Event high
       read(data_file, RXB0D4, 1); -- Event low
       rx_frame(5))

define(rx_data_file_unlearn,
       RXB0D0 <= OPC_EVULN; -- Opcode
       read(data_file, RXB0D1, 1); -- Node high
       read(data_file, RXB0D2, 1); -- Node low
       read(data_file, RXB0D3, 1); -- Event high
       read(data_file, RXB0D4, 1); -- Event low
       rx_frame(7))

define(rx_data_file_learn,
       RXB0D0 <= OPC_EVLRN; -- Opcode
       read(data_file, RXB0D1, 1); -- Node high
       read(data_file, RXB0D2, 1); -- Node low
       read(data_file, RXB0D3, 1); -- Event high
       read(data_file, RXB0D4, 1); -- Event low
       read(data_file, RXB0D5, 1); -- Event variable index
       read(data_file, RXB0D6, 1); -- Event variable value
       rx_frame(7))

define(rx_data_file_indexed_learn,
       RXB0D0 <= OPC_EVLRNI; -- Opcode
       read(data_file, RXB0D1, 1); -- Node high
       read(data_file, RXB0D2, 1); -- Node low
       read(data_file, RXB0D3, 1); -- Event high
       read(data_file, RXB0D4, 1); -- Event low
       read(data_file, RXB0D5, 1); -- Event index
       read(data_file, RXB0D6, 1); -- Event variable index
       read(data_file, RXB0D7, 1); -- Event variable value
       rx_frame(8))

define(rxb1_wait_if_not_ready,
       if RXB1CON.RXFUL != '0' then
         report("test_name: Waiting to RxB1");
         wait until RXB1CON.RXFUL == '0';
         report("test_name: Ready to RxB1");
       end if;)

define(rxb1_frame,
       RXB1DLC <= 16#0$1#;
       RXB1CON.RXFUL <= '1';
       CANSTAT <= 16#0A#;
       PIR3.RXB1IF <= '1';
       rxb1_wait_if_not_ready
       report("test_name: RxB1");)

define(rxb1_data,
       {rx_load_data(RXB1D0, $1)}
       {rx_load_data(RXB1D1, $2)}
       {rx_load_data(RXB1D2, $3)}
       {rx_load_data(RXB1D3, $4)}
       {rx_load_data(RXB1D4, $5)}
       {rx_load_data(RXB1D5, $6)}
       {rx_load_data(RXB1D6, $7)}
       {rx_load_data(RXB1D7, $8)}
       {rxb1_frame($#)})

divert(0)dnl
