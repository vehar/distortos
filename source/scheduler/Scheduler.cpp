/**
 * \file
 * \brief Scheduler class implementation
 *
 * \author Copyright (C) 2014 Kamil Szczygiel http://www.distortec.com http://www.freddiechopin.info
 *
 * \par License
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
 * distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * \date 2014-08-09
 */

#include "distortos/scheduler/Scheduler.hpp"

#include "distortos/scheduler/idleThreadControlBlock.hpp"
#include "distortos/scheduler/SoftwareTimer.hpp"

#include "distortos/architecture/InterruptMaskingLock.hpp"
#include "distortos/architecture/InterruptUnmaskingLock.hpp"

#include "distortos/distortosConfiguration.h"

namespace distortos
{

namespace scheduler
{

/*---------------------------------------------------------------------------------------------------------------------+
| public functions
+---------------------------------------------------------------------------------------------------------------------*/

Scheduler::Scheduler() :
		currentThreadControlBlock_{},
		runnableList_{ThreadControlBlock::State::Runnable},
		softwareTimerControlBlockSupervisor_{},
		tickCount_{0}
{

}

void Scheduler::add(ThreadControlBlock &thread_control_block)
{
	architecture::InterruptMaskingLock lock;
	runnableList_.sortedEmplace(thread_control_block);
}

void Scheduler::block(ThreadControlBlockList &container)
{
	{
		architecture::InterruptMaskingLock interrupt_masking_lock;
		container.sortedSplice(runnableList_, currentThreadControlBlock_);
	}

	architecture::InterruptUnmaskingLock interrupt_unmasking_lock;
	requestContextSwitch_();
}

uint64_t Scheduler::getTickCount() const
{
	architecture::InterruptMaskingLock lock;
	return tickCount_;
}

void Scheduler::sleepFor(const uint64_t ticks)
{
	sleepUntil(getTickCount() + ticks + 1);
}

void Scheduler::sleepUntil(const uint64_t tick_value)
{
	architecture::InterruptMaskingLock interrupt_masking_lock;
	ThreadControlBlockList sleeping_list {ThreadControlBlock::State::Sleeping};
	auto software_timer =
			makeSoftwareTimer(&Scheduler::unblockInternal_, this, std::ref(sleeping_list), currentThreadControlBlock_);
	software_timer.start(TickClock::time_point{TickClock::duration{tick_value}});

	block(sleeping_list);
}

void Scheduler::start()
{
	add(idleThreadControlBlock);

	currentThreadControlBlock_ = runnableList_.begin();

	getCurrentThreadControlBlock().getRoundRobinQuantum().reset();

	architecture::startScheduling();
}

void * Scheduler::switchContext(void *stack_pointer)
{
	architecture::InterruptMaskingLock lock;

	getCurrentThreadControlBlock().getStack().setStackPointer(stack_pointer);

	// if the object is on the "runnable" list and it used its round-robin quantum - do the rotation
	// move current thread to the end of same-priority group to implement round-robin scheduling
	if (getCurrentThreadControlBlock().getState() == ThreadControlBlock::State::Runnable &&
			getCurrentThreadControlBlock().getRoundRobinQuantum().get() == 0)
		runnableList_.sortedSplice(runnableList_, currentThreadControlBlock_);

	currentThreadControlBlock_ = runnableList_.begin();

	getCurrentThreadControlBlock().getRoundRobinQuantum().reset();

	return getCurrentThreadControlBlock().getStack().getStackPointer();
}

bool Scheduler::tickInterruptHandler()
{
	architecture::InterruptMaskingLock lock;

	++tickCount_;

	getCurrentThreadControlBlock().getRoundRobinQuantum().decrement();

	softwareTimerControlBlockSupervisor_.tickInterruptHandler(TickClock::time_point{TickClock::duration{tickCount_}});

	return isContextSwitchRequired_();
}

void Scheduler::unblock(ThreadControlBlockList &container, const ThreadControlBlockList::iterator iterator)
{
	architecture::InterruptMaskingLock interrupt_masking_lock;

	unblockInternal_(container, iterator);
	yield();
}

void Scheduler::yield() const
{
	if (isContextSwitchRequired_() == true)
		requestContextSwitch_();
}

/*---------------------------------------------------------------------------------------------------------------------+
| private functions
+---------------------------------------------------------------------------------------------------------------------*/

bool Scheduler::isContextSwitchRequired_() const
{
	if (getCurrentThreadControlBlock().getState() != ThreadControlBlock::State::Runnable)
		return true;

	if (runnableList_.size() == 1)	// single thread available?
		return false;				// no context switch possible

	if (runnableList_.begin() != currentThreadControlBlock_)	// is there a higher-priority thread available?
		return true;

	if (getCurrentThreadControlBlock().getRoundRobinQuantum().get() == 0)
	{
		const auto next_thread = ++runnableList_.begin();
		const auto next_thread_priority = next_thread->get().getPriority();
		// thread with same priority available?
		if (getCurrentThreadControlBlock().getPriority() == next_thread_priority)
			return true;	// switch context to do round-robin scheduling
	}

	return false;
}

void Scheduler::requestContextSwitch_() const
{
	architecture::requestContextSwitch();
}

void Scheduler::unblockInternal_(ThreadControlBlockList &container, const ThreadControlBlockList::iterator iterator)
{
	runnableList_.sortedSplice(container, iterator);
}

}	// namespace scheduler

}	// namespace distortos
