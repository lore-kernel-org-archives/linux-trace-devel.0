Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EDEC07E95
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D78BD61411
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Jul 2021 20:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhGBUhf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:37:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:44550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229996AbhGBUhf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Jul 2021 16:37:35 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9A0613D8;
        Fri,  2 Jul 2021 20:35:02 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1lzPsL-000i7W-Kn; Fri, 02 Jul 2021 16:35:01 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/2] libtracefs: Move tracefs_list_free() to tracefs-utils.c
Date:   Fri,  2 Jul 2021 16:34:58 -0400
Message-Id: <20210702203459.169473-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702203459.169473-1-rostedt@goodmis.org>
References: <20210702203459.169473-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The tracefs_list_free() function is more a helper utility, and it is
better placed in tracefs-utils.c than tracefs-events.c

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 20 --------------------
 src/tracefs-utils.c  | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 568bfe60be3b..77f4624776e2 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -284,26 +284,6 @@ __hidden char *trace_append_file(const char *dir, const char *name)
 	return ret < 0 ? NULL : file;
 }
 
-/**
- * tracefs_list_free - free list if strings, returned by APIs
- *			tracefs_event_systems()
- *			tracefs_system_events()
- *
- *@list pointer to a list of strings, the last one must be NULL
- */
-void tracefs_list_free(char **list)
-{
-	int i;
-
-	if (!list)
-		return;
-
-	for (i = 0; list[i]; i++)
-		free(list[i]);
-
-	free(list);
-}
-
 /**
  * tracefs_event_systems - return list of systems for tracing
  * @tracing_dir: directory holding the "events" directory
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index a8dd7fc35a00..b29131ecf0c5 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -364,3 +364,23 @@ int tracefs_error_clear(struct tracefs_instance *instance)
 {
 	return tracefs_instance_file_clear(instance, ERROR_LOG);
 }
+
+/**
+ * tracefs_list_free - free list if strings, returned by APIs
+ *			tracefs_event_systems()
+ *			tracefs_system_events()
+ *
+ *@list pointer to a list of strings, the last one must be NULL
+ */
+void tracefs_list_free(char **list)
+{
+	int i;
+
+	if (!list)
+		return;
+
+	for (i = 0; list[i]; i++)
+		free(list[i]);
+
+	free(list);
+}
-- 
2.30.2

