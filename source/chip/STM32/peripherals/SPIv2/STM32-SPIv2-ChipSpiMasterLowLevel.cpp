/**
 * \file
 * \brief ChipSpiMasterLowLevel class implementation for SPIv2 in STM32
 *
 * \author Copyright (C) 2016-2018 Kamil Szczygiel http://www.distortec.com http://www.freddiechopin.info
 *
 * \par License
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
 * distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

#include "distortos/chip/ChipSpiMasterLowLevel.hpp"

#include "distortos/chip/getBusFrequency.hpp"

#include "distortos/devices/communication/SpiMasterBase.hpp"

#include "distortos/assert.h"

#include <cerrno>

namespace distortos
{

namespace chip
{

/*---------------------------------------------------------------------------------------------------------------------+
| public types
+---------------------------------------------------------------------------------------------------------------------*/

/// parameters for construction of SPI master low-level drivers
class ChipSpiMasterLowLevel::Parameters
{
public:

	/**
	 * \brief Parameters's constructor
	 *
	 * \param [in] spiBase is a base address of SPI peripheral
	 */

	constexpr explicit Parameters(const uintptr_t spiBase) :
			spiBase_{spiBase},
			peripheralFrequency_{getBusFrequency(spiBase)}
	{

	}

	/**
	 * \return peripheral clock frequency, Hz
	 */

	uint32_t getPeripheralFrequency() const
	{
		return peripheralFrequency_;
	}

	/**
	 * \return reference to SPI_TypeDef object
	 */

	SPI_TypeDef& getSpi() const
	{
		return *reinterpret_cast<SPI_TypeDef*>(spiBase_);
	}

	/**
	 * \return current word length, bits, [4; 16] or
	 * [ChipSpiMasterLowLevel::minWordLength; ChipSpiMasterLowLevel::maxWordLength]
	 */

	uint8_t getWordLength() const
	{
		return getWordLength(getSpi().CR2);
	}

	/**
	 * \param [in] cr2 is the current value of CR2 register in SPI module
	 *
	 * \return current word length, bits, [4; 16] or
	 * [ChipSpiMasterLowLevel::minWordLength; ChipSpiMasterLowLevel::maxWordLength]
	 */

	static uint8_t getWordLength(const uint32_t cr2)
	{
		return ((cr2 & SPI_CR2_DS) >> SPI_CR2_DS_Pos) + 1;
	}

private:

	/// base address of SPI peripheral
	uintptr_t spiBase_;

	/// peripheral clock frequency, Hz
	uint32_t peripheralFrequency_;
};

/*---------------------------------------------------------------------------------------------------------------------+
| public static objects
+---------------------------------------------------------------------------------------------------------------------*/

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI1_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi1Parameters {SPI1_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI1_ENABLE

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI2_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi2Parameters {SPI2_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI2_ENABLE

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI3_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi3Parameters {SPI3_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI3_ENABLE

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI4_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi4Parameters {SPI4_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI4_ENABLE

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI5_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi5Parameters {SPI5_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI5_ENABLE

#ifdef CONFIG_CHIP_STM32_SPIV2_SPI6_ENABLE
const ChipSpiMasterLowLevel::Parameters ChipSpiMasterLowLevel::spi6Parameters {SPI6_BASE};
#endif	// def CONFIG_CHIP_STM32_SPIV2_SPI6_ENABLE

/*---------------------------------------------------------------------------------------------------------------------+
| public functions
+---------------------------------------------------------------------------------------------------------------------*/

ChipSpiMasterLowLevel::~ChipSpiMasterLowLevel()
{
	if (isStarted() == false)
		return;

	// reset peripheral
	parameters_.getSpi().CR1 = {};
	parameters_.getSpi().CR1 = {};
}

std::pair<int, uint32_t> ChipSpiMasterLowLevel::configure(const devices::SpiMode mode, const uint32_t clockFrequency,
		const uint8_t wordLength, const bool lsbFirst, const uint32_t dummyData)
{
	if (wordLength < minWordLength || wordLength > maxWordLength)
		return {EINVAL, {}};

	if (isStarted() == false)
		return {EBADF, {}};

	if (isTransferInProgress() == true)
		return {EBUSY, {}};

	const auto peripheralFrequency = parameters_.getPeripheralFrequency();
	const auto divider = (peripheralFrequency + clockFrequency - 1) / clockFrequency;
	if (divider > 256)
		return {EINVAL, {}};

	const uint32_t br = divider <= 2 ? 0 : 31 - __CLZ(divider - 1);
	auto& spi = parameters_.getSpi();
	spi.CR1 = (spi.CR1 & ~(SPI_CR1_LSBFIRST | SPI_CR1_BR | SPI_CR1_CPOL | SPI_CR1_CPHA)) |
			lsbFirst << SPI_CR1_LSBFIRST_Pos | br << SPI_CR1_BR_Pos |
			(mode == devices::SpiMode::cpol1cpha0 || mode == devices::SpiMode::cpol1cpha1) << SPI_CR1_CPOL_Pos |
			(mode == devices::SpiMode::cpol0cpha1 || mode == devices::SpiMode::cpol1cpha1) << SPI_CR1_CPHA_Pos;
	spi.CR2 = (spi.CR2 & ~(SPI_CR2_FRXTH | SPI_CR2_DS)) | (wordLength <= 8) << SPI_CR2_FRXTH_Pos |
			(wordLength - 1) << SPI_CR2_DS_Pos;

	dummyData_ = dummyData;

	return {{}, peripheralFrequency / (1 << (br + 1))};
}

void ChipSpiMasterLowLevel::interruptHandler()
{
	bool done {};
	auto& spi = parameters_.getSpi();
	const auto sr = spi.SR;
	const auto cr2 = spi.CR2;
	const auto wordLength = Parameters::getWordLength(cr2);

	if ((sr & SPI_SR_OVR) != 0 && (cr2 & SPI_CR2_ERRIE) != 0)	// overrun error?
	{
		spi.DR;
		spi.SR;	// clears OVR flag

		spi.CR2 &= ~SPI_CR2_TXEIE;	// disable TXE interrupt

		if ((sr & SPI_SR_BSY) == 0)
			done = true;
	}
	else if ((sr & SPI_SR_RXNE) != 0 && (cr2 & SPI_CR2_RXNEIE) != 0)	// read?
	{
		const uint16_t word = wordLength <= 8 ? *reinterpret_cast<volatile uint8_t*>(&spi.DR) : spi.DR;
		const auto readBuffer = readBuffer_;
		auto readPosition = readPosition_;
		if (readBuffer != nullptr)
		{
			readBuffer[readPosition++] = word;
			if (wordLength > 8)
				readBuffer[readPosition++] = word >> 8;
		}
		else
			readPosition += (wordLength + 8 - 1) / 8;
		readPosition_ = readPosition;
		if (readPosition == size_)
			done = true;
		else
			spi.CR2 |= SPI_CR2_TXEIE;	// enable TXE interrupt
	}
	else if ((sr & SPI_SR_TXE) != 0 && (cr2 & SPI_CR2_TXEIE) != 0)	// write?
	{
		const auto writeBuffer = writeBuffer_;
		auto writePosition = writePosition_;
		uint16_t word;
		if (writeBuffer != nullptr)
		{
			const uint16_t characterLow = writeBuffer[writePosition++];
			const uint16_t characterHigh = wordLength > 8 ? writeBuffer[writePosition++] : 0;
			word = characterLow | characterHigh << 8;
		}
		else
		{
			writePosition += (wordLength + 8 - 1) / 8;
			word = dummyData_;
		}
		writePosition_ = writePosition;
		if (wordLength <= 8)
			*reinterpret_cast<volatile uint8_t*>(&spi.DR) = word;
		else
			spi.DR = word;

		spi.CR2 &= ~SPI_CR2_TXEIE;	// disable TXE interrupt
	}

	if (done == true)	// transfer finished of failed?
	{
		spi.CR2 &= ~(SPI_CR2_TXEIE | SPI_CR2_RXNEIE | SPI_CR2_ERRIE);	// disable TXE, RXNE and ERR interrupts
		writePosition_ = {};
		const auto bytesTransfered = readPosition_;
		readPosition_ = {};
		size_ = {};
		writeBuffer_ = {};
		readBuffer_ = {};

		const auto spiMasterBase = spiMasterBase_;
		spiMasterBase_ = nullptr;
		assert(spiMasterBase != nullptr);
		spiMasterBase->transferCompleteEvent(bytesTransfered);
	}
}

int ChipSpiMasterLowLevel::start()
{
	if (isStarted() == true)
		return EBADF;

	auto& spi = parameters_.getSpi();
	spi.CR1 = SPI_CR1_SSM | SPI_CR1_SSI | SPI_CR1_SPE | SPI_CR1_BR | SPI_CR1_MSTR;
	spi.CR2 = SPI_CR2_FRXTH | (8 - 1) << SPI_CR2_DS_Pos;
	started_ = true;

	return 0;
}

int ChipSpiMasterLowLevel::startTransfer(devices::SpiMasterBase& spiMasterBase, const void* const writeBuffer,
		void* const readBuffer, const size_t size)
{
	if (size == 0)
		return EINVAL;

	if (isStarted() == false)
		return EBADF;

	if (isTransferInProgress() == true)
		return EBUSY;

	if (size % ((parameters_.getWordLength() + 8 - 1) / 8) != 0)
		return EINVAL;

	spiMasterBase_ = &spiMasterBase;
	readBuffer_ = static_cast<uint8_t*>(readBuffer);
	writeBuffer_ = static_cast<const uint8_t*>(writeBuffer);
	size_ = size;
	readPosition_ = 0;
	writePosition_ = 0;

	parameters_.getSpi().CR2 |= SPI_CR2_TXEIE | SPI_CR2_RXNEIE | SPI_CR2_ERRIE;	// enable TXE, RXNE and ERR interrupts
	return 0;
}

int ChipSpiMasterLowLevel::stop()
{
	if (isStarted() == false)
		return EBADF;

	if (isTransferInProgress() == true)
		return EBUSY;

	// reset peripheral
	parameters_.getSpi().CR1 = {};
	parameters_.getSpi().CR2 = {};
	started_ = false;
	return 0;
}

}	// namespace chip

}	// namespace distortos
