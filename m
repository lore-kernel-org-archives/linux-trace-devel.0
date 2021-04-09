Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8C0C43462
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF652610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhDIPQY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:16:24 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:55164 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234058AbhDIPQX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 11:16:23 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 08:16:04 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 898D920D41;
        Fri,  9 Apr 2021 08:16:08 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/3] libtracefs: Add lock around modifying the trace_marker file descriptor
Date:   Fri, 9 Apr 2021 11:16:04 -0400
Message-ID: <20210409151604.2224578-4-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210409151604.2224578-1-rostedt@goodmis.org>
References: <20210409151604.2224578-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a pthread mutex to protect the integrity of the file descriptor saved
for writing to the trace_marker and trace_marker_raw files. This lock is
only to protect the modification of the file descriptor and does not
protect against one thread closing the descriptor and another thread
writing to it.

It is only used to make sure that the file descriptor gets opened if it is
not already opened when doing a write, to protect opening the same file
more than once, and to protect against closing the same file descriptor
more than once.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-marker.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/src/tracefs-marker.c b/src/tracefs-marker.c
index 924ceea..61a07ab 100644
--- a/src/tracefs-marker.c
+++ b/src/tracefs-marker.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <stdio.h>
+#include <pthread.h>
 
 #include "tracefs.h"
 #include "tracefs-local.h"
@@ -25,24 +26,43 @@ static inline int *get_marker_fd(struct tracefs_instance *instance, bool raw)
 static int marker_init(struct tracefs_instance *instance, bool raw)
 {
 	const char *file = raw ? "trace_marker_raw" : "trace_marker";
+	pthread_mutex_t *lock = trace_get_lock(instance);
 	int *fd = get_marker_fd(instance, raw);
+	int ret;
 
 	if (*fd >= 0)
 		return 0;
 
-	*fd = tracefs_instance_file_open(instance, file, O_WRONLY | O_CLOEXEC);
+	/*
+	 * The mutex is only to hold the integrity of the file descriptor
+	 * to prevent opening it more than once, or closing the same
+	 * file descriptor more than once. It does not protect against
+	 * one thread closing the file descriptor and another thread
+	 * writing to it. That is up to the application to prevent
+	 * from happening.
+	 */
+	pthread_mutex_lock(lock);
+	/* The file could have been opened since we taken the lock */
+	if (*fd < 0)
+		*fd = tracefs_instance_file_open(instance, file, O_WRONLY | O_CLOEXEC);
+
+	ret = *fd < 0 ? -1 : 0;
+	pthread_mutex_unlock(lock);
 
-	return *fd < 0 ? -1 : 0;
+	return ret;
 }
 
 static void marker_close(struct tracefs_instance *instance, bool raw)
 {
+	pthread_mutex_t *lock = trace_get_lock(instance);
 	int *fd = get_marker_fd(instance, raw);
 
-	if (*fd < 0)
-		return;
-	close(*fd);
-	*fd = -1;
+	pthread_mutex_lock(lock);
+	if (*fd >= 0) {
+		close(*fd);
+		*fd = -1;
+	}
+	pthread_mutex_unlock(lock);
 }
 
 static int marker_write(struct tracefs_instance *instance, bool raw, void *data, int len)
@@ -50,6 +70,11 @@ static int marker_write(struct tracefs_instance *instance, bool raw, void *data,
 	int *fd = get_marker_fd(instance, raw);
 	int ret;
 
+	/*
+	 * The lock does not need to be taken for writes. As a write
+	 * does not modify the file descriptor. It's up to the application
+	 * to prevent it from being closed if another thread is doing a write.
+	 */
 	if (!data || len < 1)
 		return -1;
 	if (*fd < 0) {
-- 
2.29.2

