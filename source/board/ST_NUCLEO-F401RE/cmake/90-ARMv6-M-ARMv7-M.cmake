#
# file: cmake/90-ARMv6-M-ARMv7-M.cmake
#
# author: Copyright (C) 2018-2019 Kamil Szczygiel http://www.distortec.com http://www.freddiechopin.info
#
# This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
# distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Automatically generated file - do not edit!
#

set(DISTORTOS_RAW_LINKER_SCRIPT "source/board/ST_NUCLEO-F401RE/ST_NUCLEO-F401RE.ld")

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_ASCENDING_STACK
		OFF)

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_EMPTY_STACK
		OFF)

distortosSetFixedConfiguration(INTEGER
		DISTORTOS_ARCHITECTURE_STACK_ALIGNMENT
		8)

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_ARM
		ON)

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_ARMV7_M
		ON)

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_ARM_CORTEX_M4
		ON)

distortosSetFixedConfiguration(BOOLEAN
		DISTORTOS_ARCHITECTURE_ARM_CORTEX_M4_R0P1
		ON)

distortosSetConfiguration(INTEGER
		distortos_Architecture_00_Interrupt_stack_size
		1024
		MIN 8
		HELP "Size (in bytes) of \"main\" stack used by core exceptions and interrupts in Handler mode."
		OUTPUT_NAME DISTORTOS_ARCHITECTURE_MAIN_STACK_SIZE)

distortosSetConfiguration(INTEGER
		distortos_Architecture_01_Interrupt_priority_disabled_in_critical_sections
		0
		MIN 0
		MAX 15
		HELP "Interrupt priority disabled in critical sections.

		Minimal numerical priority (inclusive) of interrupt handlers that can use system's functions.

		During critical sections all interrupts with numerical priority above or equal to this value will be disabled.
		Interrupts with numerical priority below this value are never disabled, but they may not use any system's
		functions.

		Note - \"lower\" logical priority has \"higher\" numeric value! If this option is set to \"x\", then interrupts
		with priorities between \"x\" and 255 (both inclusive) may use system's functions, while interrupts with
		priorities between 0 and \"x - 1\" (both inclusive) may not. If 0 is chosen, then all interrupts (except
		HardFault and NMI) are disabled during critical sections, so they may use system's functions."
		OUTPUT_NAME DISTORTOS_ARCHITECTURE_KERNEL_BASEPRI)

distortosSetConfiguration(STRING
		distortos_Memory_regions_00_text_vectorTable
		"flash"
		HELP "Memory region for .text.vectorTable section in linker script"
		OUTPUT_NAME DISTORTOS_LD_TEXT_VECTOR_TABLE_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_01_text
		"flash"
		HELP "Memory region for .text section in linker script"
		OUTPUT_NAME DISTORTOS_LD_TEXT_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_02_ARM_exidx
		"flash"
		HELP "Memory region for .ARM.exidx section in linker script"
		OUTPUT_NAME DISTORTOS_LD_ARM_EXIDX_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_03_Main_stack
		"SRAM"
		HELP "Memory region for main stack in linker script"
		OUTPUT_NAME DISTORTOS_LD_MAIN_STACK_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_04_bss
		"SRAM"
		HELP "Memory region for .bss section in linker script"
		OUTPUT_NAME DISTORTOS_LD_BSS_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_05_data_VMA
		"SRAM"
		HELP "VMA memory region for .data section in linker script"
		OUTPUT_NAME DISTORTOS_LD_DATA_VMA_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_06_data_LMA
		"flash"
		HELP "LMA memory region for .data section in linker script"
		OUTPUT_NAME DISTORTOS_LD_DATA_LMA_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_07_noinit
		"SRAM"
		HELP "Memory region for .noinit section in linker script"
		OUTPUT_NAME DISTORTOS_LD_NOINIT_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_08_SRAM_data_LMA
		"flash"
		HELP "LMA memory region for .SRAM.data section in linker script"
		OUTPUT_NAME DISTORTOS_LD_SRAM_DATA_LMA_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_09_Process_stack
		"SRAM"
		HELP "Memory region for process stack in linker script"
		OUTPUT_NAME DISTORTOS_LD_PROCESS_STACK_REGION
		OUTPUT_TYPES BOOLEAN)

distortosSetConfiguration(STRING
		distortos_Memory_regions_10_Heap
		"SRAM"
		HELP "Memory region for heap in linker script"
		OUTPUT_NAME DISTORTOS_LD_HEAP_REGION
		OUTPUT_TYPES BOOLEAN)

if(ARCHITECTURE_NVIC_WWDG_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_WWDG_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_WWDG_ENABLE)

if(ARCHITECTURE_NVIC_PVD_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_PVD_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_PVD_ENABLE)

if(ARCHITECTURE_NVIC_TAMP_STAMP_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TAMP_STAMP_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TAMP_STAMP_ENABLE)

if(ARCHITECTURE_NVIC_RTC_WKUP_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_RTC_WKUP_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_RTC_WKUP_ENABLE)

if(ARCHITECTURE_NVIC_FLASH_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_FLASH_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_FLASH_ENABLE)

if(ARCHITECTURE_NVIC_RCC_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_RCC_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_RCC_ENABLE)

if(ARCHITECTURE_NVIC_EXTI0_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI0_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI0_ENABLE)

if(ARCHITECTURE_NVIC_EXTI1_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI1_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI1_ENABLE)

if(ARCHITECTURE_NVIC_EXTI2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI2_ENABLE)

if(ARCHITECTURE_NVIC_EXTI3_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI3_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI3_ENABLE)

if(ARCHITECTURE_NVIC_EXTI4_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI4_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI4_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM0_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM0_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM0_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM1_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM1_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM1_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM2_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM3_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM3_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM3_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM4_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM4_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM4_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM5_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM5_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM5_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM6_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM6_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM6_ENABLE)

if(ARCHITECTURE_NVIC_ADC_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_ADC_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_ADC_ENABLE)

if(ARCHITECTURE_NVIC_EXTI9_5_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI9_5_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI9_5_ENABLE)

if(ARCHITECTURE_NVIC_TIM1_BRK_TIM9_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM1_BRK_TIM9_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM1_BRK_TIM9_ENABLE)

if(ARCHITECTURE_NVIC_TIM1_UP_TIM10_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM1_UP_TIM10_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM1_UP_TIM10_ENABLE)

if(ARCHITECTURE_NVIC_TIM1_TRG_COM_TIM11_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM1_TRG_COM_TIM11_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM1_TRG_COM_TIM11_ENABLE)

if(ARCHITECTURE_NVIC_TIM1_CC_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM1_CC_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM1_CC_ENABLE)

if(ARCHITECTURE_NVIC_TIM2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM2_ENABLE)

if(ARCHITECTURE_NVIC_TIM3_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM3_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM3_ENABLE)

if(ARCHITECTURE_NVIC_TIM4_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM4_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM4_ENABLE)

if(ARCHITECTURE_NVIC_I2C1_EV_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C1_EV_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C1_EV_ENABLE)

if(ARCHITECTURE_NVIC_I2C1_ER_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C1_ER_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C1_ER_ENABLE)

if(ARCHITECTURE_NVIC_I2C2_EV_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C2_EV_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C2_EV_ENABLE)

if(ARCHITECTURE_NVIC_I2C2_ER_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C2_ER_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C2_ER_ENABLE)

if(ARCHITECTURE_NVIC_SPI1_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_SPI1_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_SPI1_ENABLE)

if(ARCHITECTURE_NVIC_SPI2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_SPI2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_SPI2_ENABLE)

if(ARCHITECTURE_NVIC_USART1_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_USART1_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_USART1_ENABLE)

if(ARCHITECTURE_NVIC_USART2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_USART2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_USART2_ENABLE)

if(ARCHITECTURE_NVIC_EXTI15_10_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_EXTI15_10_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_EXTI15_10_ENABLE)

if(ARCHITECTURE_NVIC_RTC_ALARM_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_RTC_ALARM_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_RTC_ALARM_ENABLE)

if(ARCHITECTURE_NVIC_OTG_FS_WKUP_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_OTG_FS_WKUP_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_OTG_FS_WKUP_ENABLE)

if(ARCHITECTURE_NVIC_DMA1_STREAM7_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA1_STREAM7_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA1_STREAM7_ENABLE)

if(ARCHITECTURE_NVIC_SDIO_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_SDIO_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_SDIO_ENABLE)

if(ARCHITECTURE_NVIC_TIM5_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_TIM5_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_TIM5_ENABLE)

if(ARCHITECTURE_NVIC_SPI3_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_SPI3_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_SPI3_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM0_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM0_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM0_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM1_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM1_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM1_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM2_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM2_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM2_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM3_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM3_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM3_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM4_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM4_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM4_ENABLE)

if(ARCHITECTURE_NVIC_OTG_FS_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_OTG_FS_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_OTG_FS_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM5_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM5_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM5_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM6_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM6_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM6_ENABLE)

if(ARCHITECTURE_NVIC_DMA2_STREAM7_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_DMA2_STREAM7_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_DMA2_STREAM7_ENABLE)

if(ARCHITECTURE_NVIC_USART6_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_USART6_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_USART6_ENABLE)

if(ARCHITECTURE_NVIC_I2C3_EV_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C3_EV_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C3_EV_ENABLE)

if(ARCHITECTURE_NVIC_I2C3_ER_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_I2C3_ER_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_I2C3_ER_ENABLE)

if(ARCHITECTURE_NVIC_FPU_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_FPU_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_FPU_ENABLE)

if(ARCHITECTURE_NVIC_SPI4_ENABLE)
	distortosSetFixedConfiguration(BOOLEAN
			DISTORTOS_ARCHITECTURE_NVIC_SPI4_ENABLE
			ON)
endif(ARCHITECTURE_NVIC_SPI4_ENABLE)

include("${CMAKE_CURRENT_SOURCE_DIR}/source/architecture/ARM/ARMv6-M-ARMv7-M/distortos-sources.cmake")
