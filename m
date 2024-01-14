Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A6DDDB5
	for <linux-trace-devel@vger.kernel.org>; Sun, 14 Jan 2024 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=benjarobin.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=benjarobin.fr
Received: from mxplan5.mail.ovh.net (unknown [10.109.139.23])
	by mo529.mail-out.ovh.net (Postfix) with ESMTPS id BB5BC20446;
	Sun, 14 Jan 2024 17:17:33 +0000 (UTC)
Received: from benjarobin.fr (37.59.142.108) by DAG6EX2.mxp5.local
 (172.16.2.52) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 14 Jan
 2024 18:17:33 +0100
Authentication-Results: garm.ovh; auth=pass (GARM-108S00274600ba3-6170-4ac6-b3ef-a0e252b6fdad,
                    5BE38D5D59959AD767059B58A5CDE138DFC9D9F8) smtp.auth=dev@benjarobin.fr
X-OVh-ClientIp: 92.161.126.4
From: Benjamin ROBIN <dev@benjarobin.fr>
To: <y.karadz@gmail.com>
CC: <linux-trace-devel@vger.kernel.org>, Benjamin ROBIN <dev@benjarobin.fr>
Subject: [PATCH 00/34] Fix kernelshark issues introduced by the migration to Qt6
Date: Sun, 14 Jan 2024 18:16:49 +0100
Message-ID: <20240114171723.14092-1-dev@benjarobin.fr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DAG1EX2.mxp5.local (172.16.2.2) To DAG6EX2.mxp5.local
 (172.16.2.52)
X-Ovh-Tracer-GUID: 57ab7046-705b-457d-968d-3c2dbaf87ca2
X-Ovh-Tracer-Id: 1669991039374876570
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvkedrvdeiledgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvfevufffkffoggfgtghisehtkeertdertddtnecuhfhrohhmpeeuvghnjhgrmhhinhcutffquefkpfcuoeguvghvsegsvghnjhgrrhhosghinhdrfhhrqeenucggtffrrghtthgvrhhnpeeghfegjeefledvieevgeffiedvgfelieeugedtteegffejtedvhfehtddvkeevudenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtkedpledvrdduiedurdduvdeirdegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeouggvvhessggvnhhjrghrohgsihhnrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohephidrkhgrrhgrugiisehgmhgrihhlrdgtohhmpdhlihhnuhigqdhtrhgrtggvqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdelpdhmohguvgepshhmthhpohhuth

There were 3 majors issues:
 - A segfault when loading a trace file (patch 0001)
 - The trace table height was very small (patch 0032)
 - The trace table columns width were reducing when clicking
   Marker A or B (patch 0032)

Also fix most of the warnings reported by Clang-Tidy and Clazy, and by
gcc with -Wextra.


Benjamin ROBIN (34):
  kernelshark: Fix modelReset() signaling, rename update to updateGeom
  kernelshark: Add .gitignore
  kernelshark: Remove function param when not used, whenever possible
  kernelshark: Do not create a temporary container for looping over QMap
  kernelshark: Prevent potential detach of QMap container
  kernelshark: Fix used after free of QByteArray raw data
  kernelshark: Fix potential memory leak in KsGLWidget
  kernelshark: Use lambda parameter instead of captured local variable
  kernelshark: Keep overridden method protected instead of public
  kernelshark: Use sliced() or first() instead of mid/right/left()
  kernelshark: Prevent potential divide by zero in Shape::center()
  kernelshark: Fix potential access to uninitialized variable
  kernelshark: Remove unused locals variables
  kernelshark: Fix range-loop-reference Clazy warning
  kernelshark: Fix moving a temp object prevents copy elision warning
  kernelshark: Add receiver object to connect() call
  kernelshark: Return by reference the list of header in KsModels
  kernelshark: Fix detaching-temporary Clazy warning
  kernelshark: Fix qfileinfo-exists Clazy warning
  kernelshark: Fix potential memory leaks in libkshark-configio
  kernelshark: Fix potential access to uninitialized variable
  kernelshark: Fix potential double free of histo->map, histo->bin_count
  kernelshark: Fix 'const' type qualifier on return type has no effect
  kernelshark: Fix potential memory leaks in libkshark-tepdata
  kernelshark: Fix typo in comment of KsGLWidget::resizeGL()
  kernelshark: Remove unused KsDataWidget::wipPtr() and broken function
  kernelshark: In KsTimeOffsetDialog() constructor use parent param
  kernelshark: Fixed loop counter incremented suspiciously twice
  kernelshark: Fix tepdata_dump_entry() for event_id = KS_EVENT_OVERFLOW
  kernelshark: Use static_cast instead of C cast in KsMainWindow
  kernelshark: Fix comparison of integers of different signs warnings
  kernelshark: Fix KsTableView columns width, and KsTraceViewer size
  kernelshark: Allow to reduce a bit more the graph height
  kernelshark: Cleanup of KsDualMarker methods

 .gitignore                     | 15 ++++++
 examples/configio.c            |  3 +-
 examples/datafilter.c          | 15 +++---
 examples/datahisto.c           |  2 +-
 src/KsAdvFilteringDialog.cpp   | 24 ++++------
 src/KsAdvFilteringDialog.hpp   |  2 +-
 src/KsDualMarker.hpp           | 10 +---
 src/KsGLWidget.cpp             | 48 +++++++++----------
 src/KsGLWidget.hpp             | 43 ++++++++---------
 src/KsMainWindow.cpp           |  8 ++--
 src/KsModels.hpp               | 11 +++--
 src/KsPlotTools.cpp            | 14 +++---
 src/KsPlotTools.hpp            |  2 +-
 src/KsSession.cpp              |  4 +-
 src/KsTraceGraph.cpp           |  7 ++-
 src/KsTraceViewer.cpp          | 71 ++++++++--------------------
 src/KsTraceViewer.hpp          | 11 +++--
 src/KsUtils.cpp                |  9 ++--
 src/KsUtils.hpp                |  4 +-
 src/KsWidgetsLib.cpp           |  2 +-
 src/KsWidgetsLib.hpp           | 15 ++----
 src/libkshark-collection.c     | 14 +++---
 src/libkshark-configio.c       | 84 +++++++++++++++++++---------------
 src/libkshark-hash.c           |  5 +-
 src/libkshark-model.c          | 19 ++++----
 src/libkshark-tepdata.c        | 31 ++++++++-----
 src/libkshark.c                | 17 +++----
 src/libkshark.h                | 20 ++++----
 src/plugins/KVMComboDialog.cpp |  7 +--
 src/plugins/sched_events.c     |  2 +-
 tests/test-input.c             |  4 +-
 tests/test-input_ctrl.c        |  4 +-
 32 files changed, 257 insertions(+), 270 deletions(-)
 create mode 100644 .gitignore

--
2.43.0

