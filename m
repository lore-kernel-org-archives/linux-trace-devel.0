Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31CE1714A8
	for <linux-trace-devel@vger.kernel.org>; Sun,  6 Oct 2024 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728209711; cv=none; b=qR71MzZRjsww/xsK1X3LGGduL/d9ZuRFY2yVP43JZEdEyaU/3GpP8LNEjw/iBjCcagKVSFhB1eKSmwysLNIyJW5kT1PvwtrljK3CdeUr2BsT7a/q7Lk/BIWEVg4IISbkJrvMmIDCRN1+a1f/hj1Y1nGRFS9/1K4WHg8EpSPq89o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728209711; c=relaxed/simple;
	bh=w4HL+E2Uy/idqzDd67kdgLqO72m2fiO02zmsn1T/Ry8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SfV35UX6i37E3n8HaiGNEbp7D0hsMD1mXhMtQaCJSqw1YF51OyX2g3kebFZq9K4JbpqxDGm/xXZD5LiCOwkoBJ1vpoTJTO7L91Uq/djglBqfDk+HNnLjekWJ+oj6aPU0x8mjbo2l6gKpVD8cBjSuo4pO1D2K8kb5qByL4j6OnQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=TlPmgqUl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TlPmgqUl"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4965lKkZ027238;
	Sun, 6 Oct 2024 10:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=w08j6vQLxZLyeNm8YXgOrlhS8cF3p
	M+Tmtfa7IFrIoY=; b=TlPmgqUlI4grRlCvA/N8QzK885NhDsJQ38Zzk5aRQI9n7
	+wtHXbBqee6IdKol6twijbhm63wKpDiKePmh26eJrD6VKAc4kdVwoelCFkvFN8GA
	lyZL+o80O30Dt+CEFK1e2/DELpOEpsCfNVMbRbeAPS44hXq+wHV3qS3TF84mdsyn
	+Dp/t8MYW89zNzSVV1qOP/+NHJHcXCCduE6/Gz9B6r6CKJ5oFM/Li+LwD2OrLVTo
	inYNtIyergWivqHmyJqS7FmsoaXeGMlFm6S4lIUD9MlKR8jd9fN9b7Wh5sChOQCR
	Qry+VZpujTuYMYsOCFROKLzyDFFRoakflgDDneVgA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42300ds3js-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Oct 2024 10:15:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4965lHhT004852;
	Sun, 6 Oct 2024 10:15:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 422uw4thru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Oct 2024 10:15:07 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 496AAUHa002866;
	Sun, 6 Oct 2024 10:15:06 GMT
Received: from clb-2-bm-ad2.osdevelopmeniad.oraclevcn.com (clb-2-bm-ad2.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.254.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 422uw4thrh-1;
	Sun, 06 Oct 2024 10:15:06 +0000
From: Libo Chen <libo.chen@oracle.com>
To: y.karadz@gmail.com
Cc: libo.chen@oracle.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] kernel-shark: Multi-thread the computaion of stream/combo plots
Date: Sun,  6 Oct 2024 03:15:06 -0700
Message-ID: <20241006101506.3339142-1-libo.chen@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-06_06,2024-10-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0 spamscore=0
 mlxlogscore=921 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2410060073
X-Proofpoint-GUID: FvqzzzeLzHDdzPn_9pJfDGNrnSXAJuBF
X-Proofpoint-ORIG-GUID: FvqzzzeLzHDdzPn_9pJfDGNrnSXAJuBF

Parallelize _newCPUGraph() and _newTaskGraph() calls to dramatically
speed up graph rendering particularly for traces from very large systems.

OpenMP technically is a new dependency here, but it's deeply embedded
with GCC toolchains, as long as your GCC is not older than v4.9, the
libgomp library that comes with it will work.

Signed-off-by: Libo Chen <libo.chen@oracle.com>
---
 CMakeLists.txt     |  6 ++++++
 src/KsGLWidget.cpp | 25 +++++++++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c36d757..8d1090a 100644
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
2.46.2

