#
# Common Makefile for the PX4 bootloaders
#

#
# Paths to common dependencies
#
export LIBOPENCM3	?= $(wildcard ./libopencm3)
ifeq ($(LIBOPENCM3),)
$(error Cannot locate libopencm3 - set LIBOPENCM3 to the root of a built version and try again)
endif

#
# Tools
#
export CC	 	 = arm-none-eabi-gcc
export OBJCOPY		 = arm-none-eabi-objcopy

#
# Common configuration
#
export FLAGS		 = -std=gnu99 \
			   -Os \
			   -g \
			   -Wall \
			   -fno-builtin \
			   -I$(LIBOPENCM3)/include \
			   -ffunction-sections \
			   -nostartfiles \
			   -lnosys \
	   		   -Wl,-gc-sections

export COMMON_SRCS	 = bl.c

#
# Bootloaders to build
#
#TARGETS			 = px4fmu_bl px4fmuv2_bl px4flow_bl stm32f4discovery_bl px4io_bl aerocore_bl
TARGETS				= stmstick_bl

# px4io_bl px4flow_bl

all:	$(TARGETS)

clean:
	rm -f *.elf *.bin

#
# Specific bootloader targets.
#
# Pick a Makefile from Makefile.f1, Makefile.f4
# Pick an interface supported by the Makefile (USB, UART, I2C)
# Specify the board type.
#

dragonfly_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=dragonfly INTERFACE=USB BOARD=DRAGONFLY USBDEVICESTRING="\\\"PX4 BL DRAGONFLY v1.x\\\"" USBPRODUCTID="0x0020"

stmstick_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=stmstick INTERFACE=USB BOARD=STMSTICK USBDEVICESTRING="\\\"PX4 BL STMSTICK v1.x\\\"" USBPRODUCTID="0x0021"


px4fmu_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=fmu INTERFACE=USB BOARD=FMU USBDEVICESTRING="\\\"PX4 BL FMU v1.x\\\"" USBPRODUCTID="0x0010"

px4fmuv2_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=fmuv2 INTERFACE=USB BOARD=FMUV2 USBDEVICESTRING="\\\"PX4 BL FMU v2.x\\\"" USBPRODUCTID="0x0011"

stm32f4discovery_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=discovery INTERFACE=USB BOARD=DISCOVERY USBDEVICESTRING="\\\"PX4 BL DISCOVERY\\\"" USBPRODUCTID="0x0001"

px4flow_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=flow INTERFACE=USB BOARD=FLOW USBDEVICESTRING="\\\"PX4 FLOW v1.3\\\"" USBPRODUCTID="0x0015"

aerocore_bl: $(MAKEFILE_LIST)
	make -f Makefile.f4 TARGET=aerocore INTERFACE=USB BOARD=AEROCORE USBDEVICESTRING="\\\"Gumstix BL AEROCORE\\\"" USBPRODUCTID="0x1001"

# Default bootloader delay is *very* short, just long enough to catch
# the board for recovery but not so long as to make restarting after a
# brownout problematic.
#
px4io_bl: $(MAKEFILE_LIST)
	make -f Makefile.f1 TARGET=io INTERFACE=USART BOARD=IO PX4_BOOTLOADER_DELAY=200
