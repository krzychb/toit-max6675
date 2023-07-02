/*
Driver for MAX6675 using SPI interface of ESP32 or bit banging.

Maxim Integrated MAX6675 is a cold junction compensated K-thermocouple to-digital converter
able to read temperatures in range from 0°C to +1024°C.
MAX6675 datasheet: https://datasheets.maximintegrated.com/en/ds/MAX6675.pdf

Copyright (C) 2022 krzychb. All rights reserved.
Use of this source code is governed by a MIT-style license that can be found
in the LICENSE file.
*/

import gpio
import spi
import binary
import serial


// According to MAX6675 datasheet the maximum clock frequency is 4.3 MHz
MAX6675_SCK_FREQUENCY ::= 4_000_000


class Measurement:
  temperature/float
  sensor_health/bool  // false if thermocouple is open

  constructor .temperature .sensor_health:

/**
SPI serial device driver to read raw data from the Maxim Integrated MAX6675.
MAX6675 is a cold junction compensated K-thermocouple to-digital converter
able to read temperatures in range from 0°C to +1024°C.
https://datasheets.maximintegrated.com/en/ds/MAX6675.pdf
*/
class Driver:
  static THERMOCOUPLE_OPEN_BIT ::= 0b0000_0000_0000_0100
  device_/serial.Device ::= ?

  constructor device/serial.Device:
    device_ = device

  /**
  Read temperature in degrees of Celsius (°C)
  */
  read -> Measurement:
    sensor_health/bool := ?

    data := device_.read 2  // MAX6675 provides two bytes to read
    value := binary.BIG_ENDIAN.int16 data 0  // input bytes are swapped
    // Bit D2 is normally low and goes high when the thermocouple input is open.
    if (value & THERMOCOUPLE_OPEN_BIT) == THERMOCOUPLE_OPEN_BIT:
      print "Thermocouple open!"
      sensor_health = false
    else:
      sensor_health = true
    /*
    The first bit, D15, is a dummy sign bit and is always zero.
    Bits D14–D3 contain the converted temperature in the order from MSB to LSB.
    */
    value = value >> 3  // remove not relevant bits
    temperature := value * 0.25
    return Measurement temperature sensor_health


/**
Bit bang SPI serial device driver to read raw data from the Maxim Integrated MAX6675.
MAX6675 is a cold junction compensated K-thermocouple to-digital converter
able to read temperatures in range from 0°C to +1024°C.
https://datasheets.maximintegrated.com/en/ds/MAX6675.pdf
*/
class DriverBitBang implements serial.Device:
  cs_ := ?
  so_ := ?
  sck_ := ?

  constructor --cs --so --sck:
    cs_ = cs
    so_ = so
    sck_ = sck
    cs_.config --output
    so_.config --input
    sck_.config --output

  registers -> none: throw "UNIMPLEMENTED"

  read amount/int:
    if amount != 2: throw "UNIMPLEMENTED"
    data := ByteArray 2
    sck_.set 0
    sleep --ms=1
    cs_.set 0
    sleep --ms=1
    for byte := 0; byte < 2; byte++:
      for bit := 0; bit < 8; bit++:
        data[byte] = data[byte] << 1  // prepare the next cleared bit
        if so_.get == 1:   // set the bit if read high
          data[byte] = data[byte] | 0b0000_0001
        sck_.set 1
        sleep --ms=1
        sck_.set 0   // Data is changed on failing edge
        sleep --ms=1
    cs_.set 1
    return data

  write bytes/ByteArray -> none: throw "UNIMPLEMENTED"
