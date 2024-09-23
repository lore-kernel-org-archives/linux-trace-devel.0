Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B7D1885AD
	for <linux-trace-devel@vger.kernel.org>; Mon, 23 Sep 2024 09:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727082558; cv=none; b=EXjQLMpK1mSpen+fE9OuM8VKYRIppvcluVRs3F1KJmJy9V5OwfFDzX3A41dYMl/3GhBf5R3YfuiGyo4199K9wMnjHfVCAF4nAzqkg4/qqQtUPvCnSjnirXTNU6e9kihFb5OT58uyyWdHuxkEPEitFXLLl/Pj0rhiue9m0YKTWcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727082558; c=relaxed/simple;
	bh=q+rrU/KjPnf32BAnLw0umTibDIVxgtNwRS6XZ88TgP0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OU8XTR83s3yS6Oxiiarg/O+byqvg/XFo4UgLpsPHg+Iy2p6jvPuae2iYSgCHYaZMPIpZpaEcirVDsRRy9ynreOGy3gCLqW8G7cbk+CksA0+/GC7806kXM6WKPPb0pfUK7OqcaZvXAlzcfzOAsc2EazCWn3f9dQyo6yP4A22aiM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UP/mGCr/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UP/mGCr/"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48N7u2B2009554;
	Mon, 23 Sep 2024 09:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=corp-2023-11-20; bh=KFtOL2/qtFdBLH
	4PruyHpBExzSBSo6YV8l0J4F/oyDA=; b=UP/mGCr//DDO5UBe+IcdGM8SxSEqqn
	kp/yR8l7V/OSTWTofigva3KfnaPRO0hEx1KEg0CfZinqzLz54eyZ+anoAH5zZYHZ
	TMubZK5ppkVeyNGZNttfH1LbVh9DkLf/ZMjOGvIXbQpelw9yEHzYj8k+52p7dA1F
	VyB8A3yOQZ75ZErlwe3CfTQxC33DeAkUZiYQ2GvYuI3tzb3nH9qsu0hgjRleZNzy
	M3Jdv1s8iOX8sEqccIGGtgLaTZ3GHhyD94EKlme58IW8QhAwuUZ4TA00q2gd134M
	vJn0yMZR9pe6eS8TGr1/OSxzCs5hY7nlHnNjXovN6fVeLKcQiwMBX0WQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1ac47t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 09:09:14 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48N7cjYa038759;
	Mon, 23 Sep 2024 09:09:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41tkc448hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 09:09:14 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48N99Dlt031896;
	Mon, 23 Sep 2024 09:09:13 GMT
Received: from clb-2-bm-ad2.osdevelopmeniad.oraclevcn.com (clb-2-bm-ad2.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.254.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41tkc448hb-1;
	Mon, 23 Sep 2024 09:09:13 +0000
From: Libo Chen <libo.chen@oracle.com>
To: y.karadz@gmail.com
Cc: libo.chen@oracle.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH] kernel-shark: Multi-thread the computaion of CPU graph
Date: Mon, 23 Sep 2024 02:09:12 -0700
Message-ID: <20240923090912.1261220-1-libo.chen@oracle.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_05,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=844
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409230067
X-Proofpoint-ORIG-GUID: dEII_qcOar1yQbSzPvEFXysR3A7xpGo2
X-Proofpoint-GUID: dEII_qcOar1yQbSzPvEFXysR3A7xpGo2

Parallelize _newCPUGraph() calls to dramatically speed up
graph rendering particularly for traces from very large systems.

OpenMP technically is a new dependency here, but it's so embedded
with GCC toolchains, as long as your GCC is not older than v4.9,
the libgomp library that comes with it will work.

Signed-off-by: Libo Chen <libo.chen@oracle.com>
---
 CMakeLists.txt     |  5 +++++
 src/KsGLWidget.cpp | 15 ++++++++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index c36d757..8dd9ff9 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -84,6 +84,11 @@ set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
 set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
 set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pthread -fPIC -fno-common")
 
+find_package(OpenMP 3.2.5)
+if (OPENMP_FOUND)
+    set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   ${OpenMP_C_FLAGS}")
+    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
+
 set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)
 set(CMAKE_CXX_EXTENSIONS OFF)
diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 9311d98..00a1951 100644
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
@@ -690,10 +693,20 @@ void KsGLWidget::_makeGraphs()
 
 	for (auto it = _streamPlots.begin(); it != _streamPlots.end(); ++it) {
 		sd = it.key();
+		QVector<KsPlot::Graph *> cpuGraphs(it.value()._cpuList.count());
+		QVector<KsPlot::Graph *> taskGraphs(it.value()._taskList.count());
+
 		/* Create CPU graphs according to the cpuList. */
 		it.value()._cpuGraphs = {};
+		omp_set_num_threads(omp_get_num_procs());
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
 
-- 
2.43.5

