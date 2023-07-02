/*
Example of reading temperature using MAX6675 using bit banging of ESP32 pins.
*/

import gpio
import max6675

//          ESP32 GPIO #  // MAX6675 Function (Pin)
cs_gpio ::=  gpio.Pin 12  // Chip select      (CS)
so_gpio ::=  gpio.Pin 13  // Serial output    (SO)
sck_gpio ::= gpio.Pin 14  // Serial clock     (SCK)


main:
  device := max6675.DriverBitBang
    --cs=cs_gpio
    --so=so_gpio
    --sck=sck_gpio

  max6675 := max6675.Driver device

  while true:
    print "Temperature: $(%0.1f max6675.read.temperature)°C"
    sleep --ms=500
