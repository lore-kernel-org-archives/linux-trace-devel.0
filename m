Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B6FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C7FD610A3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Aug 2021 20:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhHJUss (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Aug 2021 16:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhHJUsr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Aug 2021 16:48:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4471361058;
        Tue, 10 Aug 2021 20:48:25 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mDYfg-003hAH-6e; Tue, 10 Aug 2021 16:48:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5/9] libtracefs: Add API tracefs_list_dup()
Date:   Tue, 10 Aug 2021 16:48:14 -0400
Message-Id: <20210810204818.880714-6-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810204818.880714-1-rostedt@goodmis.org>
References: <20210810204818.880714-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add an API tracefs_list_dup() that will duplicate an existing list.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |  1 +
 src/tracefs-utils.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index f1e4ffa0d65f..6fb66c44afc7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -67,6 +67,7 @@ void tracefs_list_free(char **list);
 char **tracefs_list_add(char **list, const char *string);
 int tracefs_list_size(char **list);
 int tracefs_list_pop(char **list);
+char **tracefs_list_dup(char **list);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 63bb413298fe..8c92d6c54ab1 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -489,3 +489,29 @@ int tracefs_list_size(char **list)
 	list--;
 	return (int)*(unsigned long *)list;
 }
+
+/**
+ * tracefs_list_dup - create a duplicate list
+ * @list: The list to duplicate
+ *
+ * Allocates a new list that can be modified and freed separately.
+ *
+ * Returns a new allocated list that must be freed with
+ * tracefs_list_free(), or NULL on error.
+ */
+char **tracefs_list_dup(char **list)
+{
+	char **new = NULL;
+	char **tmp;
+	int i;
+
+	for (i = 0; list[i]; i++) {
+		tmp = tracefs_list_add(new, list[i]);
+		if (!tmp) {
+			free(new);
+			return NULL;
+		}
+		new = tmp;
+	}
+	return new;
+}
-- 
2.30.2

