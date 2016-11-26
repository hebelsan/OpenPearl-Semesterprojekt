# read system configuration setting from menuconfig
include ../../configuration/.config

phony = all clean
_all: all


include makefile.conf

CC := $(CROSS)$(CC)
CXX := $(CROSS)$(CXX)
AR := $(CROSS)$(AR)

# make silent compilations
COMPILE.c = @echo compile $<; $(CC) $(CFLAGS) $(TARGET_ARCH) -c
#COMPILE.cc = @echo [compile] $<; $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.cc = echo [compile] $<; $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
LINK.o = $(LINK.cc)
#LINK = @echo [link] $@; $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@
LINK = @echo [link] $@; $(CXX) $(PURECFLAGS) -DTARGET=3 $(CXXFLAGS) $(CPPFLAGS) $(LFLAGS) $(LDFLAGS) $^ -o $@



IC_DIR = ../includeComposer
IC = $(IC_DIR)/ic
DWS = $(IC_DIR)/dws

INCS = .
CXXSRCS =
CRCS =

targets := OpenPEARLstm32f7_board.o libOpenPEARLstm32f7.a

# -------------------- add CMSIS support to project
INCS += ../cortexM/CMSIS/Include

# -------------------- add FreeRTOS support to project
include ../FreeRTOS/FreeRTOS/Files
CSRC += $(addprefix ../FreeRTOS/FreeRTOS/,$(RTOSCSRC))
INCS += $(addprefix ../FreeRTOS/FreeRTOS/,$(RTOSINCS))

# -------------------- add FreeRTOS addOn files to project
include ../FreeRTOS/addOns/Files
CSRC += $(addprefix ../FreeRTOS/addOns/,$(ADDONCSRC))
CHECK_FILES += $(addprefix ../FreeRTOS/addOns/,$(ADDONCSRC))
INCS += $(addprefix ../FreeRTOS/addOns/,$(ADDONINCS))

# ------------------- add FreeRTOS specific PEARL classes to project
include ../FreeRTOS/PEARL/Files
CXXSRCS += $(addprefix ../FreeRTOS/PEARL/,$(PEARL_FREERTOS_SRC))
CHECK_FILES += $(addprefix ../FreeRTOS/PEARL/,$(PEARL_FREERTOS_SRC))
INCS += $(addprefix ../FreeRTOS/PEARL/,$(PEARL_FREERTOS_INC))

# -------------------- add cortex-M clock to project
CXXSRCS += ../FreeRTOS/addOns/CortexMClock.cc
CHECK_FILES += ../FreeRTOS/addOns/CortexMClock.cc

# ------------------- add plattform independent PEARL classes to project
include ../common/Files.common
CXXSRCS += $(addprefix ../common/,$(CXX_COMMON))
CHECK_FILES += $(addprefix ../common/,$(CXX_COMMON))
INCS += ../common

#---------------------------------
# required parts of stm32f7 HAL
# directory, includes directories HAL
STM32F7HAL= ../cortexM/stm32f7xx.h
INCS += $(STM32F7HAL)
#
#LPCOpen_CSRC += $(LPCOpen)/uart_17xx_40xx.c
#LPCOpen_CSRC += $(LPCOpen)/chip_17xx_40xx.c
#LPCOpen_CSRC += $(LPCOpen)/clock_17xx_40xx.c
#LPCOpen_CSRC += $(LPCOpen)/rtc_17xx_40xx.c
##LPCOpen_CSRC += $(LPCOpen)/iocon_17xx_40xx.c
#
#CSRC += Hy32.cc Hy32LowLevel.cc SmallFont.c BigFont.c
#CHECK_FILES +=  Hy32.cc Hy32LowLevel.cc SmallFont.c BigFont.ca \
#	Hy32.h Hy32LowLevel.h
# ------- add board specific stuff to project
#BOARDSUPPORT := 
#BOARDSUPPORT += lpc17_uart_retarget.c
#BOARDSUPPORT += lpc17_oscillators.c
BOARDSUPPORT += system_stm32f7xx.c
#BOARDSUPPORT += Lpc17xxRTC.cc
#BOARDSUPPORT += Post.cc
#BOARDSUPPORT += SystemConsole.cc
#BOARDSUPPORT += Lpc17xxTimer0.cc
BOARDSUPPORT += Stm32f7xxClock.cc
#BOARDSUPPORT += Lpc17xxDigitalIn.cc
#BOARDSUPPORT += Lpc17xxDigitalOut.cc
#BOARDSUPPORT += Lpc17xxInterrupt.cc
#BOARDSUPPORT += Lpc17xxUartInternal.cc
#BOARDSUPPORT += Lpc17xxUart.cc
#CHECK_FILES += $(BOARDSUPPORT)
#CHECK_FILES += $(addsuffix .h,$(basename $(BOARDSUPPORT)))
BOARDSUPPORT += startup_stm32f4xx.S 

#$(warning BOARDSUPPORT = $(BOARDSUPPORT))

# ---------------- add remaining board depending modules
# ----------------- add test applications
TESTOBJ:=
#ifeq ($(CONFIG_STM32F7_tests),y)
  include tests/Makefile.inc
  CHECK_FILES += $(GTEST_SRC) $(GTEST_DATION_SRC) $(TEST_SRC)
  OBJ := $(addsuffix .o,$(basename $(CXX_COMMON_TESTS)))
  OBJ := $(addprefix ../common/tests/,$(OBJ))
  #$(warning OBJ=$(OBJ))
#  $(warning targets=$(targets))
#endif

# ------------------------ finalize variables 
INCS:=$(addprefix -I ,$(INCS))
PURECXXFLAGS := $(CXXFLAGS)

PURECFLAGS := $(CFLAGS)
CFLAGS += $(INCS)
CXXFLAGS += $(INCS)
CXXFLAGS += -DTARGET=3

# ----------------- all input sources for dependencies
SRCS = $(BOARDSUPPORT)  $(CXXSRCS) $(CSRC) $(LPCOpen_CSRC)

# ------------------- all files not to be added into lib
BOARDSUPPORT_OBJ := \
		 $(addsuffix .o,$(basename $(BOARDSUPPORT))) \
		 $(addsuffix .o,$(basename $(LPCOpen_CSRC)))

INCLUDES := $(addsuffix .h,$(basename $(CXXSRCS)))
PLIB_OBJS := $(addsuffix .o,$(basename $(CXXSRCS)))
PLIB_OBJS += $(addsuffix .o,$(basename $(CSRC)))


CHECK_FILES := $(sort $(CHECK_FILES))

#$(warning BOARDSUPPORT_OBJ=$(BOARDSUPPORT_OBJ))

all: depend $(targets)

startup_stm32f4xx.o: startup_stm32f4xx.S
	@echo "[assemble] startup_stm32f4xx.S"
	@$(CC) $^ $(CFLAGS) -c

OpenPEARLstm32f7_board.o: $(BOARDSUPPORT_OBJ)
	@echo "[create] $@"
	@$(CC) -nostdlib -Xlinker -r $(NOHOST) $(CFLAGS) $(INCS) -o $@ $^

libOpenPEARLstm32f7.a:  $(PLIB_OBJS)
	@echo "[create] $@"
	@rm   -f libOpenPEARLstm32f7.a
	@$(AR) r libOpenPEARLstm32f7.a $(PLIB_OBJS)


phony += depend
depend: ../common/Signals.hh ../common/Signals.hcc $(SRCS)
	@echo "[create] .depend"
	@$(CXX) -MM $(CFLAGS) $(INCS) $^ >.depend

phony += clean
clean:
	@rm -f $(BOARDSUPPORT_OBJ)
	@rm -f $(targets)
	@rm -f $(GTEST_OBJS)
	@rm -f $(GTEST_OBJS1)
	@rm -f $(GTEST_OBJS2)
	@rm -f cc_bin.inc run_bin.inc
	@rm -f .depend pearl.h
	@rm -f $(PLIB_OBJS) $(OBJ)
	@rm -f $(addsuffix .diff,$(CHECK_FILES))
	@rm -f $(addsuffix .new,$(CHECK_FILES))
	@rm -rf html
	@rm -rf latex

phony += doc
doc:
	doxygen doc_stuff/Doxyfile
#	(cd latex; make pdf; cd ..)

phony += prepare
prepare:
	mkdir -p $(CONFIG_INSTALL_Target)/lib/ldscripts
	@touch $(CONFIG_INSTALL_Target)/lib/libOpenPEARLstm32f7.a
	@chmod 666 $(CONFIG_INSTALL_Target)/lib/libOpenPEARLstm32f7.a
	@touch $(CONFIG_INSTALL_Target)/lib/OpenPEARLstm32f7_board.a
	@chmod 666 $(CONFIG_INSTALL_Target)/lib/OpenPEARLstm32f7_board.a
	@touch $(CONFIG_INSTALL_Target)/lib/OpenPEARLstm32f7_board.o
	@chmod 666 $(CONFIG_INSTALL_Target)/lib/OpenPEARLstm32f7_board.o
	@touch $(CONFIG_INSTALL_Target)/lib/ldscripts/OpenPEARLstm32f7.ld
	@chmod 666 $(CONFIG_INSTALL_Target)/lib/ldscripts/OpenPEARLstm32f7.ld

phony += install
install: all cc_bin run_bin
	rm -f pearl2.h
	$(IC) -c $(INCS)  <PearlIncludes.h | $(DWS) >pearl2.h
	cat sysincs.h pearl2.h >pearl.h
	rm -f pearl2.h sysincs.h
	cp libOpenPEARLstm32f7.a $(CONFIG_INSTALL_Target)/lib
	mkdir -p $(CONFIG_INSTALL_Target)/lib/ldscripts
	cp OpenPEARLstm32f7.ld $(CONFIG_INSTALL_Target)/lib/ldscripts
	cp OpenPEARLstm32f7_board.o $(CONFIG_INSTALL_Target)/lib

phony += cc_bin
cc_bin:
	# create cc_bin.inc
	echo '$(CXX) -DTARGET=3 $(PURECXXFLAGS) $(LFLAGS) $(CONFIG_INSTALL_Target)/lib/OpenPEARLstm32f7_board.o -I $(CONFIG_INSTALL_Target)/include $$fn.cc -o $$fn $(CONFIG_INSTALL_Target)/lib/libOpenPEARLstm32f7.a' > cc_bin.inc 

phony += run_bin
run_bin:
	# create run_bin.inc
	echo "# auto generated " > run_bin.inc
	echo 'prl -r not supported for stm32f7' >> run_bin.inc
	echo 'echo please add stlink commands for download' >> run_bin.inc
#	echo 'objcopy -O ihex $$fn $$fn.hex' >>run_bin.inc
#	echo 'lpc21isp -control -term -hex $$fn.hex $$INTERFACE 115200 12000' >>run_bin.inc

# -------------------------------------------------
# additional rules to enable make to build the autogenerated files
#
../common/Signals.hh: ../common/Signals.ods
	@echo create signal definitions from spreadsheet
	@(cd ../common; \
	perl GenerateSignalDefinitions.pl GENERIC LPC1768 2>signals.log;)

../common/Signals.hcc: ../common/Signals.ods
	(cd ../common; perl GenerateSignalDefinitions.pl GENERIC LPC1768; )

../Signals.cc: ../Signals.hh ../Signals.hcc

phony +=  checkformat
checkformat:
	@$(foreach f,$(CHECK_FILES),../codestyle/check.sh $(f);)

-include .depend

phony += info
info:
	@echo "Makefile Summary"
	@echo "targets: " $(targets)
	@echo "CFLAGS " $(CFLAGS)
	@echo "INCS " $(INCS)
	@echo "CXXFLAGS " $(CXXFLAGS)
	@echo "LFLAGS " $(LFLAGS)
	@echo "LDFLAGS " $(LDFLAGS)
	@echo "PHONY " $(phony)

.PHONY: $(phony)
