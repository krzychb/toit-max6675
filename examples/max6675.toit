/*
Example of reading temperature using MAX6675 over SPI interface of ESP32.
*/

import gpio
import spi
import max6675

//          ESP32 GPIO #  // MAX6675 Function (Pin)
cs_gpio ::=  gpio.Pin 12  // Chip select      (CS)
so_gpio ::=  gpio.Pin 13  // Serial output    (SO)
sck_gpio ::= gpio.Pin 14  // Serial clock     (SCK)


main:
  bus := spi.Bus
    --miso=so_gpio
    --clock=sck_gpio

  device := bus.device
    --cs=cs_gpio
    --frequency=4_000_000

  max6675 := max6675.Driver device

  while true:
    print "Temperature: $(%0.1f max6675.read.temperature)°C"
    sleep --ms=500
