Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEE7C4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75EFB23AC4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732455AbgLINqs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732187AbgLINqs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:46:48 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AB3C061793
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:07 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id 91so1800210wrj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZlMaVXkpFDSrr5W2Gf2UjmHvjxArgrxOGkBtegIsfk=;
        b=jsSh+PuGQRJfyN1I+hdzlWlgjuyh7j2Ns4ogMSxUodcUEv4zVUyjTOPH1zEdOOMyuU
         AKj73LTBGC3jhqEyTvZSLfKwxG02t3zn1Ef+tT8vPyMR85nigFPz0IJm6Yrookxb3TNd
         7QBhbJuYJQxJMLdfseCuU+IG55JUYWFxzpQBmHUAZ+28TE+yL+4MCg4oVh6FdM3Gp1R0
         HgdW1Ctxxz9gNDX1P3KBXRtCcuHWkWTIZjnn6HvlnvlIh7o2fstH/S2cERjxRI1gsIqC
         LC6g+vsydDgJWnSNH/ikL7/d5ZDteHqTrdDRJgQoSzwx3hBJ5dC/a1c+LtV5gYLKG5cI
         ivlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZlMaVXkpFDSrr5W2Gf2UjmHvjxArgrxOGkBtegIsfk=;
        b=q4gCDceeuhST6Op0zc+WjDBRPepVI3EvTa4uscYFixccRj8AxdftOw9KA3PAqKcQ17
         3fbUgUrT1EWmnE2kekpZtqtrCwP2B86nvpbtJbAsd9Hv/FZpSArW4UJOA33prQRI2ZU3
         SRVWAEDDOhKC7Mjr9kbOcjGqUl9FgSpxCNjn9Sre5Aawcj4Jmv+AJsu1+w2bs+jZz1tB
         nFrbrzxE6owX5QqVqQonm1TzTJFUHlNFvsx+g95VlWmSzoQ78RXabR3TBP0PjLnGTr0R
         HrN+yHW/Uo90Sj+9UdKmrjIBhda5cp0fRD4I8FdTwtcvWG3EKnFu6/7DpD3eatiCf+1F
         zOCA==
X-Gm-Message-State: AOAM532nrFNSiJoiPkNyxvstcRs9Yvj6tzYCYMr8F8k9Q9WZD39Sva8B
        bZIix0I6mDQw5nK31UyVRro=
X-Google-Smtp-Source: ABdhPJwjDMQDvcOhHxg6dngBfmUYEGNZJGf1xKuSuEUPdvQ6IlllcRqtgoe232yvlisQFGZMSMGAnQ==
X-Received: by 2002:adf:df8e:: with SMTP id z14mr2854931wrl.406.1607521566399;
        Wed, 09 Dec 2020 05:46:06 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:05 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 01/10] kernel-shark: Integrate streams with KsPlotTools
Date:   Wed,  9 Dec 2020 15:45:21 +0200
Message-Id: <20201209134530.428368-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The C++ ploting toolls are adapted in order to be able to work with
the new version of the C API. Now we can handle multiple Data streams.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/CMakeLists.txt  |  4 +-
 src/KsPlotTools.cpp | 94 ++++++++++++++++++++++++++++++++-------------
 src/KsPlotTools.hpp |  4 +-
 3 files changed, 71 insertions(+), 31 deletions(-)

diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index cbd45ed..bc12853 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -22,8 +22,8 @@ install(TARGETS kshark LIBRARY DESTINATION ${_LIBDIR}/${KS_APP_NAME})
 if (OPENGL_FOUND)
 
     message(STATUS "libkshark-plot")
-    add_library(kshark-plot  SHARED  libkshark-plot.c)
-#                                      KsPlotTools.cpp)
+    add_library(kshark-plot  SHARED  libkshark-plot.c
+                                     KsPlotTools.cpp)
 
     target_link_libraries(kshark-plot  kshark
                                        ${GLUT_LIBRARY}
diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index fe3008e..113a6c0 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -10,16 +10,13 @@
  */
 
 // C
+#include <cstring>
 #include <math.h>
 
 // C++
 #include <algorithm>
 #include <vector>
 
-// OpenGL
-#include <GL/freeglut.h>
-#include <GL/gl.h>
-
 // KernelShark
 #include "KsPlotTools.hpp"
 
@@ -109,29 +106,45 @@ void Color::setRainbowColor(int n)
 ColorTable getTaskColorTable()
 {
 	struct kshark_context *kshark_ctx(nullptr);
+	int nTasks(0), pid, *pids, i(0), *streamIds;
+	std::vector<int> tempPids;
 	ColorTable colors;
-	int nTasks, pid, *pids, i(0);
 
 	if (!kshark_instance(&kshark_ctx))
 		return colors;
 
-	nTasks = kshark_get_task_pids(kshark_ctx, &pids);
-	if (!nTasks)
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int j = 0; j < kshark_ctx->n_streams; ++j) {
+		nTasks = kshark_get_task_pids(kshark_ctx, streamIds[j], &pids);
+		tempPids.insert(tempPids.end(), pids, pids + nTasks);
+		free(pids);
+	}
+
+	free(streamIds);
+
+	if (!tempPids.size())
 		return colors;
 
-	std::vector<int> temp_pids(pids, pids + nTasks);
-	std::sort(temp_pids.begin(), temp_pids.end());
+	std::sort(tempPids.begin(), tempPids.end());
 
-	free(pids);
+	/* Erase duplicates. */
+	tempPids.erase(unique(tempPids.begin(), tempPids.end()),
+		       tempPids.end());
 
-	if (temp_pids[i] == 0) {
-		/* The "Idle" process (pid = 0) will be plotted in black. */
+	/* Erase negative (error codes). */
+	auto isNegative = [](int i) {return i < 0;};
+	auto it = remove_if(tempPids.begin(), tempPids.end(), isNegative);
+	tempPids.erase(it, tempPids.end());
+
+	nTasks = tempPids.size();
+	if (tempPids[i] == 0) {
+		/* Pid <= 0 will be plotted in black. */
 		colors[i++] = {};
 	}
 
 	for (; i < nTasks; ++i) {
-		pid = temp_pids[i];
-		colors[pid].setRainbowColor(i - 1);
+		pid = tempPids[i];
+		colors[pid].setRainbowColor(i);
 	}
 
 	return colors;
@@ -145,16 +158,26 @@ ColorTable getTaskColorTable()
  */
 ColorTable getCPUColorTable()
 {
-	struct kshark_context *kshark_ctx(nullptr);
+	kshark_context *kshark_ctx(nullptr);
+	int nCPUs, nCPUMax(0), *streamIds;
+	kshark_data_stream *stream;
 	ColorTable colors;
-	int nCPUs;
 
 	if (!kshark_instance(&kshark_ctx))
 		return colors;
 
-	nCPUs =  tep_get_cpus(kshark_ctx->pevent);
-	for (int i = 0; i < nCPUs; ++i)
-		colors[i].setRainbowColor(i);
+	streamIds = kshark_all_streams(kshark_ctx);
+	for (int i = 0; i < kshark_ctx->n_streams; ++i) {
+		stream = kshark_get_data_stream(kshark_ctx, streamIds[i]);
+		nCPUs =  stream->n_cpus;
+		if (nCPUMax < nCPUs)
+			nCPUMax = nCPUs;
+	}
+
+	free(streamIds);
+
+	for (int i = 0; i < nCPUMax; ++i)
+		colors[i].setRainbowColor(i + 8);
 
 	return colors;
 }
@@ -788,9 +811,10 @@ void Graph::setBin(int bin, int pidF, int pidB, const Color &col, uint8_t m)
 /**
  * @brief Process a CPU Graph.
  *
+ * @param sd: Data stream identifier.
  * @param cpu: The CPU core.
  */
-void Graph::fillCPUGraph(int cpu)
+void Graph::fillCPUGraph(int sd, int cpu)
 {
 	struct kshark_entry *eFront;
 	int pidFront(0), pidBack(0);
@@ -804,6 +828,7 @@ void Graph::fillCPUGraph(int cpu)
 		eFront = nullptr;
 
 		pidFront = ksmodel_get_pid_front(_histoPtr, bin,
+							    sd,
 							    cpu,
 							    true,
 							    _collectionPtr,
@@ -813,6 +838,7 @@ void Graph::fillCPUGraph(int cpu)
 			eFront = _histoPtr->data[index];
 
 		pidBack = ksmodel_get_pid_back(_histoPtr, bin,
+							  sd,
 							  cpu,
 							  true,
 							  _collectionPtr,
@@ -820,10 +846,11 @@ void Graph::fillCPUGraph(int cpu)
 
 		pidBackNoFilter =
 			ksmodel_get_pid_back(_histoPtr, bin,
-						       cpu,
-						       false,
-						       _collectionPtr,
-						       nullptr);
+							sd,
+							cpu,
+							false,
+							_collectionPtr,
+							nullptr);
 
 		if (pidBack != pidBackNoFilter)
 			pidBack = KS_FILTERED_BIN;
@@ -832,6 +859,7 @@ void Graph::fillCPUGraph(int cpu)
 		if (eFront) {
 			if (!(eFront->visible & KS_EVENT_VIEW_FILTER_MASK) &&
 			    ksmodel_cpu_visible_event_exist(_histoPtr, bin,
+								       sd,
 								       cpu,
 								       _collectionPtr,
 								       &index)) {
@@ -874,6 +902,7 @@ void Graph::fillCPUGraph(int cpu)
 		 */
 		pidBackNoFilter = ksmodel_get_pid_back(_histoPtr,
 						       LOWER_OVERFLOW_BIN,
+						       sd,
 						       cpu,
 						       false,
 						       _collectionPtr,
@@ -882,6 +911,7 @@ void Graph::fillCPUGraph(int cpu)
 		/* Now get the Pid back, applying filters. */
 		pidBack = ksmodel_get_pid_back(_histoPtr,
 					       LOWER_OVERFLOW_BIN,
+					       sd,
 					       cpu,
 					       true,
 					       _collectionPtr,
@@ -916,9 +946,10 @@ void Graph::fillCPUGraph(int cpu)
 /**
  * @brief Process a Task Graph.
  *
+ * @param sd: Data stream identifier.
  * @param pid: The Process Id of the Task.
  */
-void Graph::fillTaskGraph(int pid)
+void Graph::fillTaskGraph(int sd, int pid)
 {
 	int cpuFront, cpuBack(0), pidFront(0), pidBack(0), lastCpu(-1), bin(0);
 	struct kshark_entry *eFront;
@@ -972,6 +1003,7 @@ void Graph::fillTaskGraph(int pid)
 			 */
 			int cpuPid = ksmodel_get_pid_back(_histoPtr,
 							  bin,
+							  sd,
 							  lastCpu,
 							  false,
 							  nullptr, // No collection
@@ -998,6 +1030,7 @@ void Graph::fillTaskGraph(int pid)
 		eFront = nullptr;
 		/* Get the CPU used by this task. */
 		cpuFront = ksmodel_get_cpu_front(_histoPtr, bin,
+						 sd,
 						 pid,
 						 false,
 						 _collectionPtr,
@@ -1006,6 +1039,7 @@ void Graph::fillTaskGraph(int pid)
 			eFront = _histoPtr->data[index];
 
 		cpuBack = ksmodel_get_cpu_back(_histoPtr, bin,
+					       sd,
 					       pid,
 					       false,
 					       _collectionPtr,
@@ -1020,6 +1054,7 @@ void Graph::fillTaskGraph(int pid)
 			 */
 			pidFront = ksmodel_get_pid_front(_histoPtr,
 							 bin,
+							 sd,
 							 cpuFront,
 							 false,
 							 _collectionPtr,
@@ -1027,6 +1062,7 @@ void Graph::fillTaskGraph(int pid)
 
 			pidBack = ksmodel_get_pid_back(_histoPtr,
 						       bin,
+						       sd,
 						       cpuBack,
 						       false,
 						       _collectionPtr,
@@ -1037,6 +1073,7 @@ void Graph::fillTaskGraph(int pid)
 				if (!(eFront->visible & KS_EVENT_VIEW_FILTER_MASK) &&
 				    ksmodel_task_visible_event_exist(_histoPtr,
 								     bin,
+								     sd,
 								     pid,
 								     _collectionPtr,
 								     &index)) {
@@ -1062,8 +1099,9 @@ void Graph::fillTaskGraph(int pid)
 		 * No data from this Task in the very first bin. Use the Lower
 		 * Overflow Bin to retrieve the CPU used by the task (if any).
 		 */
-		cpuFront = ksmodel_get_cpu_back(_histoPtr, LOWER_OVERFLOW_BIN, pid,
-					   false, _collectionPtr, nullptr);
+		cpuFront = ksmodel_get_cpu_back(_histoPtr, LOWER_OVERFLOW_BIN,
+						sd, pid,
+						false, _collectionPtr, nullptr);
 		if (cpuFront >= 0) {
 			/*
 			 * The Lower Overflow Bin contains data from this Task.
@@ -1075,6 +1113,7 @@ void Graph::fillTaskGraph(int pid)
 
 			pidCpu0 = ksmodel_get_pid_back(_histoPtr,
 						       0,
+						       sd,
 						       cpuFront,
 						       false,
 						       _collectionPtr,
@@ -1082,6 +1121,7 @@ void Graph::fillTaskGraph(int pid)
 
 			pidCpuLOB = ksmodel_get_pid_back(_histoPtr,
 							 LOWER_OVERFLOW_BIN,
+							 sd,
 							 cpuFront,
 							 false,
 							 _collectionPtr,
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index ee447f1..6e66373 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -432,9 +432,9 @@ public:
 	/** @brief Set the Hash table of Task's colors. */
 	void setBinColorTablePtr(KsPlot::ColorTable *ct) {_binColors = ct;}
 
-	void fillCPUGraph(int cpu);
+	void fillCPUGraph(int sd, int cpu);
 
-	void fillTaskGraph(int pid);
+	void fillTaskGraph(int sd, int pid);
 
 	void draw(float s = 1);
 
-- 
2.25.1

