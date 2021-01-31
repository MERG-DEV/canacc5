# Test CBUS node variable requests ignored in SLiM.

Device PIC18F2480
Hwtool SIM
Program "../dist/default/production/canacc5.production.cof"
Stim "./scl/slim_nv_read_test.scl"
Break *0 1

# Set free event space and number of events
Write /e 0x04 0x7b 0x05

# Set output pulse times
Write /e 0xE6 8 7 6 5 1 2 3 4

Run
Wait
Quit
