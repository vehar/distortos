/**
 * \file
 * \brief semaphoreTestCases object definition
 *
 * \author Copyright (C) 2014-2015 Kamil Szczygiel http://www.distortec.com http://www.freddiechopin.info
 *
 * \par License
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
 * distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * \date 2015-05-16
 */

#include "semaphoreTestCases.hpp"

#include "SemaphorePriorityTestCase.hpp"
#include "SemaphoreOperationsTestCase.hpp"

#include "TestCaseGroup.hpp"

namespace distortos
{

namespace test
{

namespace
{

/*---------------------------------------------------------------------------------------------------------------------+
| local objects
+---------------------------------------------------------------------------------------------------------------------*/

/// SemaphorePriorityTestCase::Implementation instance
const SemaphorePriorityTestCase::Implementation priorityTestCaseImplementation;

/// SemaphorePriorityTestCase instance
const SemaphorePriorityTestCase priorityTestCase {priorityTestCaseImplementation};

/// SemaphoreOperationsTestCase instance
const SemaphoreOperationsTestCase operationsTestCase;

/// array with references to TestCase objects related to semaphores
const TestCaseGroup::Range::value_type semaphoreTestCases_[]
{
		TestCaseGroup::Range::value_type{priorityTestCase},
		TestCaseGroup::Range::value_type{operationsTestCase},
};

}	// namespace

/*---------------------------------------------------------------------------------------------------------------------+
| global objects
+---------------------------------------------------------------------------------------------------------------------*/

const TestCaseGroup semaphoreTestCases {TestCaseGroup::Range{semaphoreTestCases_}};

}	// namespace test

}	// namespace distortos
