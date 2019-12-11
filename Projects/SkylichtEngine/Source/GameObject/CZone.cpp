/*
!@
MIT License

Copyright (c) 2019 Skylicht Technology CO., LTD

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
(the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

This file is part of the "Skylicht Engine".
https://github.com/skylicht-lab/skylicht-engine
!#
*/

#include "pch.h"
#include "CZone.h"

#include "Utils/CStringImp.h"

namespace Skylicht
{

	CZone::CZone()
	{
	}

	CZone::~CZone()
	{
	}

	void CZone::updateObject()
	{
		updateAddRemoveObject();

		int numObject = (int)m_childs.size();
		CGameObject **objects = m_childs.data();

		for (int i = 0; i < numObject; i++)
		{
			CGameObject *pObject = objects[i];
			if (pObject->isEnable())
				pObject->updateObject();
		}		
	}

	void CZone::postUpdateObject()
	{
		ArrayGameObjectIter it = m_childs.begin(), end = m_childs.end();
		while (it != end)
		{
			CGameObject *pObject = (CGameObject*)(*it);
			if (pObject->isEnable())
			{
				pObject->postUpdateObject();
			}
			++it;
		}
	}

	void CZone::endUpdate()
	{
		ArrayGameObjectIter it = m_childs.begin(), end = m_childs.end();
		while (it != end)
		{
			CGameObject *pObject = (CGameObject*)(*it);
			if (pObject->isEnable())
			{
				pObject->endUpdate();
			}
			++it;
		}
	}
}