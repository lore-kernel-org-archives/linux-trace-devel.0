Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014744C6D
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Mar 2025 00:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743034898; cv=none; b=e6oNwPz858vjgYbSm52+sd4OIzWZ4JjD4mFMgQ9rOzTqBb4uDyyOa1d8zrdCzwZgcLw/ntYs7d6Ir8CQwJyw3LFSXKrwuPN0d4SJnqnZw0aHq2t+XVHnf9JPuVz5zWXMYkI4XxxqbpdG7n78HVBkMywJ1TY6WKm9zgupLxbkO7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743034898; c=relaxed/simple;
	bh=jcf106+59fhzYOv8I1A2CO/hHtqyY3i+xIE7t+mRlYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pAs5tdxN9RAFcJkWgeYAA+N36sCCF/ia2k4M4gwZIXzWJ8kFkUIA22iA4oXLbc/PDZ4tGLj8dZjQ9FwotWB+R64QTCRkjRodw3Z6sblzQOT3uHm2dAVC6veTvSlZDqXZ1nUnGH3/nFfuBWfM9QlHMyzlncbzJTFBPygXtrzdcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P8qspjmr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P8qspjmr"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0ZXh005118;
	Thu, 27 Mar 2025 00:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=6ZsAW7pnV1pxKJRpbJFNkFuKVLQrY
	8kwcAnixjeMpvs=; b=P8qspjmreAFzJjUWeHHmaZhMUEl9XWXJTOOWIbXBrLHZ7
	Nha+Wlntacp7n3CBr6kN0Y2F66KRlZj5sIwEftnmhDrwcSLaVV2i1m0pnCs651Gc
	Qrzrm0JrAHgLGm5a/AkXzUKlc0oRVJXQh/t5F3ar78Ldge/NoDIeMz+xTaO2xEFv
	e9RofMw/B2GMoPBw1+Yi7k5ZcAUL1idpaVUeR5uyuu/+sbmCohL6xgTGY349RprT
	b5+r9qaRDegpCvxHtySMRGoxMjHQhTxquRUqEmbm3HUO3DDIcKMvzJ2hmTuvF3N3
	3XF8KUz+GlYjJwefMeDU+3mx+uPMiEs4GOKBBp0BA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnrsk1m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 00:21:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QMaAEB023035;
	Thu, 27 Mar 2025 00:21:33 GMT
Received: from clb-2-bm-ad2.osdevelopmeniad.oraclevcn.com (clb-2-bm-ad2.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.254.172])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45jjcfx5th-1;
	Thu, 27 Mar 2025 00:21:33 +0000
From: Libo Chen <libo.chen@oracle.com>
To: y.karadz@gmail.com
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] kernel-shark: Multi-thread the computaion of stream/combo plots
Date: Wed, 26 Mar 2025 17:21:33 -0700
Message-ID: <20250327002133.135719-1-libo.chen@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=838 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503270001
X-Proofpoint-GUID: yXitMOB3y5H0931XfIjhvLrjADP1LD-Z
X-Proofpoint-ORIG-GUID: yXitMOB3y5H0931XfIjhvLrjADP1LD-Z

Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
speed up graph rendering particularly for traces from very large systems.

OpenMP technically is a new dependency here, but it's part of GCC, so long
as your GCC >= v4.9, the libgomp library will make the code compiled.

Signed-off-by: Libo Chen <libo.chen@oracle.com>
---
 CMakeLists.txt     |  6 ++++++
 src/KsGLWidget.cpp | 30 ++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 988bfd6..7847177 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -84,6 +84,12 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
 
+find_package(OpenMP 3.2.5)
+if (OPENMP_FOUND)
+    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
+    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
+endif(OPENMP_FOUND)
+
 set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)
 set(CMAKE_CXX_EXTENSIONS OFF)
diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 9311d98..7f2001c 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -13,6 +13,9 @@
 #include <GL/glut.h>
 #include <GL/gl.h>
 
+// OpenMP
+#include <omp.h>
+
 // KernelShark
 #include "libkshark-plugin.h"
 #include "KsGLWidget.hpp"
@@ -54,6 +57,7 @@ KsGLWidget::KsGLWidget(QWidget *parent)
 
 	connect(&_model,	&QAbstractTableModel::modelReset,
 		this,		qOverload<>(&KsGLWidget::update));
+	omp_set_num_threads(omp_get_num_procs());
 }
 
 void KsGLWidget::_freeGraphs()
@@ -690,23 +694,41 @@ void KsGLWidget::_makeGraphs()
 
 	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
 		sd = it.key();
+		size_t nCpus = it.value()._cpuList.count();
+		size_t nTasks = it.value()._taskList.count();
+		QVector<KsPlot::Graph *> cpuGraphs(nCpus);
+		QVector<KsPlot::Graph *> taskGraphs(nTasks);
+
 		/* Create CPU graphs according to the cpuList. */
 		it.value()._cpuGraphs = {};
-		for (auto const &cpu: it.value()._cpuList) {
-			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
+		#pragma omp parallel for
+		for (size_t idx = 0; idx < nCpus; ++idx) {
+			int cpu = it.value()._cpuList[idx];
+			cpuGraphs[idx] = _newCPUGraph(sd, cpu);
+		}
+		QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
+		while (itCpuGraphs.hasNext()) {
+			g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
 			it.value()._cpuGraphs.append(g);
 		}
 
 		/* Create Task graphs according to the taskList. */
 		it.value()._taskGraphs = {};
-		for (auto const &pid: it.value()._taskList) {
-			g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
+		#pragma omp parallel for
+		for (size_t idx = 0; idx < nTasks; ++idx) {
+			int pid = it.value()._taskList[idx];
+			taskGraphs[idx] = _newTaskGraph(sd, pid);
+		}
+		QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
+		while (itTaskGraphs.hasNext()) {
+			g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
 			it.value()._taskGraphs.append(g);
 		}
 	}
 
 	for (auto &c: _comboPlots) {
 		int n = c.count();
+		#pragma omp parallel for
 		for (int i = 0; i < n; ++i) {
 			sd = c[i]._streamId;
 			if (c[i]._type & KSHARK_TASK_DRAW) {
-- 
2.43.5

