TARGET = main


# Define the linker script location and chip architecture.
LD_SCRIPT = ".\ld\STM32F410RB.ld"
MCU_SPEC  = cortex-m4

# Toolchain definitions (ARM bare metal defaults)

CC = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-gcc.exe"
AS = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-as.exe"
LD = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-ld.exe"
OC = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-objcopy.exe"
OD = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-objdump.exe"
OS = "C:\Program Files (x86)\GNU Arm Embedded Toolchain\10_2021.10\bin\arm-none-eabi-size.exe"

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
# (Set error messages to appear on a single line.)
ASFLAGS += -fmessage-length=0

# C compilation directives
CFLAGS += -mcpu=$(MCU_SPEC)
CFLAGS += -mthumb
CFLAGS += -Wall
CFLAGS += -g
# (Set error messages to appear on a single line.)
CFLAGS += -fmessage-length=0
# (Set system to ignore semihosted junk)
CFLAGS += --specs=nosys.specs

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -T$(LSCRIPT)

AS_SRC   =  ./src/core.S
AS_SRC   += ./src/vector_table.S
C_SRC    =  ./src/main.c
#C_SRC    += ./src/nvic.c

INCLUDE  =  -I./
INCLUDE  += -I./device_headers

OBJS  = $(AS_SRC:.S=.o)
OBJS += $(C_SRC:.c=.o)

.PHONY: all
all: $(TARGET).bin

%.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) -c $(CFLAGS) $(INCLUDE) $< -o $@

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OC) -S -O binary $< $@
	$(OS) $<

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin
