# MAX6675

Toit driver for the MAX6675, a cold junction compensated K-thermocouple to digital converter.


# Installation

```bash
jag pkg install github.com/krzychb/toit-max6675
```

# Usage

```toit
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
```

See [max6675.toit](examples/max6675.toit) for an example of reading the temparature from MX6675 using SPI interface of ESP32.


## Resources

- [MAX6675 Cold-Junction-Compensated K-Thermocouple-to-Digital Converter (datasheet)](https://datasheets.maximintegrated.com/en/ds/MAX6675.pdf)