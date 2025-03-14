Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4478B154BE2
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Mar 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741990045; cv=none; b=V+LVYrTCPM+KZL5rHEVCffK4foBnmyC1Bt6YlF3l6BjSE5KdYC/JXeWEsDqgT2SI1R5U0uheN/z/6aFuTkg3C35PnqD+LOF7lKqXCvieAhPuYGCXtit+9PAcj7G3FRydvmj3ANlk4Q/Y6rNrHdFS6tqzcqHukc3jv62mBoURb9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741990045; c=relaxed/simple;
	bh=rXoIWxnq/p2e969S2A9jRuVVgxwxdDOjR0qav543KaM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r8+ScX+6hkp2qzePaYwGj+LcQ1HdQRguJs/KYIB0I5hBJkof1+jQYnVu5sYQcqLiT82OAdRwIDycg5ywVCKkrZsi1R2+gszk1fP4QIesK+HsPMECf+HZDAZHpe3xTry7M5rdUwSxkvAkzTtzSVf5/orTBALTA9eEf0axTWowDkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eCcIhHnh; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eCcIhHnh"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52EKtS04009759;
	Fri, 14 Mar 2025 22:07:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=eFF/EV8ChTj0GI+e9Jh9JZoBEMFub
	Ba25DGGuFC6BOM=; b=eCcIhHnhmQ9GU3wTijNb8P/SrEqwx+W+/D1sH0kTccEfM
	FvBiLQ+FVsxIiobL0kVpQMLymJaHhGMRgSWt/TDvpucdJj+qH4+DSjR9OxKcEo7D
	eQMcVcM4QWqN4AveQOKpAILQ5X99pwVl++TeE/Bty3RuHdn70eehy/u41hLK4nZZ
	tbhQZ1cbFOBeo5pcPI1+kvErnRWJArpQP3oi8YmKYY25k45a8y+sElXcFE10MozK
	A09Hnu3quVwoohh96ZOAqkC/9i3BdXd/qWdHjUTFasI4mgzzARjoM24wEfyarMfR
	XRGGup8m4wEXn5Hm7hUM5ehf8XDAZJZIyRDkcHcCQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dya4y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Mar 2025 22:07:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52ELgTRa003824;
	Fri, 14 Mar 2025 22:07:20 GMT
Received: from clb-2-bm-ad2.osdevelopmeniad.oraclevcn.com (clb-2-bm-ad2.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.254.172])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45atn4160t-1;
	Fri, 14 Mar 2025 22:07:20 +0000
From: Libo Chen <libo.chen@oracle.com>
To: y.karadz@gmail.com
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH RESEND v2] kernel-shark: Multi-thread the computaion of stream/combo plots
Date: Fri, 14 Mar 2025 15:07:19 -0700
Message-ID: <20250314220719.1065523-1-libo.chen@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-14_09,2025-03-14_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=937 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503140170
X-Proofpoint-GUID: n38vk0XQqnjioEnL-OtuCA6Ww6BF-1GU
X-Proofpoint-ORIG-GUID: n38vk0XQqnjioEnL-OtuCA6Ww6BF-1GU

Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
speed up graph rendering particularly for traces from very large systems.

OpenMP technically is a new dependency here, but it's part of GCC, so long
as your GCC >= v4.9, the libgomp library will make the code compiled.

Signed-off-by: Libo Chen <libo.chen@oracle.com>
---
 CMakeLists.txt     |  6 ++++++
 src/KsGLWidget.cpp | 25 +++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

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
index 9311d98..004d64b 100644
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
@@ -688,25 +691,43 @@ void KsGLWidget::_makeGraphs()
 		return graph;
 	};
 
+	omp_set_num_threads(omp_get_num_procs());
 	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
 		sd = it.key();
+		QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
+		QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
+
 		/* Create CPU graphs according to the cpuList. */
 		it.value()._cpuGraphs = {};
+		#pragma omp parallel for
 		for (auto const &cpu: it.value()._cpuList) {
-			g = lamAddGraph(sd, _newCPUGraph(sd, cpu), _vSpacing);
+			int idx = it.value()._cpuList.indexOf(cpu);
+			cpuGraphs[idx] = _newCPUGraph(sd, cpu);
+		}
+		QVectorIterator<KsPlot::Graph *> itCpuGraphs(cpuGraphs);
+		while (itCpuGraphs.hasNext()) {
+			g = lamAddGraph(sd, itCpuGraphs.next(), _vSpacing);
 			it.value()._cpuGraphs.append(g);
 		}
 
 		/* Create Task graphs according to the taskList. */
 		it.value()._taskGraphs = {};
+		#pragma omp parallel for
 		for (auto const &pid: it.value()._taskList) {
-			g = lamAddGraph(sd, _newTaskGraph(sd, pid), _vSpacing);
+			int idx = it.value()._taskList.indexOf(pid);
+			taskGraphs[idx] = _newTaskGraph(sd, pid);
+		}
+		QVectorIterator<KsPlot::Graph *> itTaskGraphs(taskGraphs);
+		while (itTaskGraphs.hasNext()) {
+			g = lamAddGraph(sd, itTaskGraphs.next(), _vSpacing);
 			it.value()._taskGraphs.append(g);
 		}
+
 	}
 
 	for (auto &c: _comboPlots) {
 		int n = c.count();
+		#pragma omp parallel for
 		for (int i = 0; i < n; ++i) {
 			sd = c[i]._streamId;
 			if (c[i]._type & KSHARK_TASK_DRAW) {
-- 
2.43.5

