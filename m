Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8CBFC6377D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 13:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D8176135B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 13:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhGVM4P (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 08:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhGVMzo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 08:55:44 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C4E60FE7;
        Thu, 22 Jul 2021 13:36:19 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m6Ys6-001at1-Mc; Thu, 22 Jul 2021 09:36:18 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 1/4] libtracefs: Add tracefs_list_pop() to remove the last item
Date:   Thu, 22 Jul 2021 09:36:07 -0400
Message-Id: <20210722133610.379933-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210722133610.379933-1-rostedt@goodmis.org>
References: <20210722133610.379933-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add a way to remove the last item of a string list. This will be needed to
revert changes made to the new tracefs_synth structure that will have more
than one tracefs_list char ** that must be the same size. If one is
successfully updated, but the next one fails, the first one needs to be
reverted.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |  1 +
 src/tracefs-utils.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 2649417654b1..4dd77b9c4119 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -66,6 +66,7 @@ int tracefs_error_clear(struct tracefs_instance *instance);
 void tracefs_list_free(char **list);
 char **tracefs_list_add(char **list, const char *string);
 int tracefs_list_size(char **list);
+int tracefs_list_pop(char **list);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 600cdf2acefc..63bb413298fe 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -448,6 +448,32 @@ char **tracefs_list_add(char **list, const char *string)
 	return list;
 }
 
+/**
+ * tracefs_list_pop - Removes the last string added
+ * @list: The list to remove the last event from
+ *
+ * Returns 0 on success, -1 on error.
+ * Returns 1 if the list is empty or NULL.
+ */
+int tracefs_list_pop(char **list)
+{
+	unsigned long size;
+
+	if (!list || list[0])
+		return 1;
+
+	list--;
+	size = *(unsigned long *)list;
+	/* size must be greater than zero */
+	if (!size)
+		return -1;
+	size--;
+	*list = (char *)size;
+	list++;
+	list[size] = '\0';
+	return 0;
+}
+
 /**
  * tracefs_list_size - Return the number of strings in the list
  * @list: The list to determine the size.
-- 
2.30.2

