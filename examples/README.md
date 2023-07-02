# Examples

This folder provides the following examples:

- [max6675-bit-bang.toit](max6675-bit-bang.toit) reading temperature in °C from MAX6675 over SPI interface implemented using bit banging of ESP32 pins.
- [max6675.toit](max6675.toit) reading temperature in °C from MAX6675 over the native SPI interface of ESP32.


## Hardware connections

The applications use the following connections between ESP32 and MAX6675 converter.

| Signal Name         | ESP32 Pin | MAX6675 Pin |
| ------------------- | --------- | ------------|
| Chip select (CS)    |        12 |          CS |
| Serial output (SO)  |        13 |          SO |
| Serial clock (SCK)  |        14 |         SCK |
| Ground              |       GND |         GND |
| Power Supply 3.3 V  |           |         VCC |


## Running the application using Jaguar

Jaguar is a small application developed by the Toit team, that runs on your ESP32. It enables live reloading and lets you update and restart your ESP32 code over Wi-Fi.

[Install Jaguar](https://docs.toit.io/getstarted/device) following the documentation by Toit.

Open a terminal and flash the Jaguar image to ESP32 board. Provide SSID and PASSWORD to your Wi-Fi network. If you have more than one ESP32 board connected to your computer, you will be asked to select the port name of the specific ESP32 board to flash the image.

```
jag config wifi set --wifi-ssid SSID --wifi-password PASSWORD
```

Upload `max6675-bit-bang.toit` application to the ESP32 board. Note the upload will be done using the Wi-Fi network specified in the previous step.

```
jag watch max6675-bit-bang.toit
```

By using `watch` we instruct Jaguar to "watch" the application source file for any changes. If a change is detected Jaguar will compile and upload the update to the ESP32.

Open another terminal and run the following command to monitor the application output.

```
jag monitor
```

You should see a similar output in the terminal:

```
Starting serial monitor of port 'COM3' ...
ets Jun  8 2016 00:22:57

rst:0x1 (POWERON_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
ets Jun  8 2016 00:22:57

rst:0x10 (RTCWDT_RTC_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 188777542, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:2
load:0x3fff0030,len:188
ho 0 tail 12 room 4
load:0x40078000,len:12180
load:0x40080400,len:2936
entry 0x400805c8
clearing RTC memory: RTC memory is in inconsistent state
[flash reg] address 0x3f430000, size 0x00200000
[jaguar] INFO: program 1 re-starting from flash @ [0,28672]
Temperature: 33.0°C
[wifi] DEBUG: connecting
Temperature: 32.2°C
Temperature: 32.8°C
Temperature: 32.5°C
Temperature: 32.8°C
[wifi] DEBUG: connected
Temperature: 32.5°C
[wifi] INFO: got ip ip=192.168.1.17
[jaguar] INFO: running Jaguar device 'max6675' (id: 'fd35b832-e0b5-44fb-85e5-0fa22199f56c') on 'http://192.168.1.17:9000'
Temperature: 32.2°C
Temperature: 32.2°C
Temperature: 32.8°C
...
```

To check the driver that is using the native SPI interface of ESP32 upload `max6675.toit` following the same procedure.