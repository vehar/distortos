#
# file: Rules.mk
#
# author: Copyright (C) 2015-2016 Kamil Szczygiel http://www.distortec.com http://www.freddiechopin.info
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
# distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#-----------------------------------------------------------------------------------------------------------------------
# subdirectories
#-----------------------------------------------------------------------------------------------------------------------

SUBDIRECTORIES += architecture
SUBDIRECTORIES += board
SUBDIRECTORIES += chip/STM32/STM32F4
SUBDIRECTORIES += clocks
SUBDIRECTORIES += devices/io
SUBDIRECTORIES += memory
SUBDIRECTORIES += scheduler
SUBDIRECTORIES += synchronization
SUBDIRECTORIES += syscalls
SUBDIRECTORIES += threads

#-----------------------------------------------------------------------------------------------------------------------
# archives
#-----------------------------------------------------------------------------------------------------------------------

LIBDISTORTOS_A_$(d) := $(OUTPUT)libdistortos.a

#-----------------------------------------------------------------------------------------------------------------------
# add archives to list of generated files
#-----------------------------------------------------------------------------------------------------------------------

GENERATED := $(GENERATED) $(LIBDISTORTOS_A_$(d))

#-----------------------------------------------------------------------------------------------------------------------
# standard footer
#-----------------------------------------------------------------------------------------------------------------------

include $(DISTORTOS_PATH)footer.mk

#-----------------------------------------------------------------------------------------------------------------------
# libdistortos.a dependencies - all objects from this folder tree and this Rules.mk
#-----------------------------------------------------------------------------------------------------------------------

$(LIBDISTORTOS_A_$(d)): $(OBJECTS_$(d)) $(SUBDIRECTORIES_OBJECTS_$(d)) $(d)Rules.mk
