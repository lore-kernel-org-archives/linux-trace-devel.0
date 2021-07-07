Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1598C07E96
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BF661CC0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Jul 2021 03:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbhGGDNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 23:13:52 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1CA561CBB;
        Wed,  7 Jul 2021 03:11:12 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m0xxv-00130X-KG; Tue, 06 Jul 2021 23:11:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/4] libtracefs: Implement tracefs_list_size()
Date:   Tue,  6 Jul 2021 23:11:07 -0400
Message-Id: <20210707031110.249759-2-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707031110.249759-1-rostedt@goodmis.org>
References: <20210707031110.249759-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add tracefs_list_size() that returns a the size of a list created by
tracefs_list_add().

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs.h   |  1 +
 src/tracefs-utils.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 266c513e4116..6b9a76c4c40a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -65,6 +65,7 @@ int tracefs_error_clear(struct tracefs_instance *instance);
 
 void tracefs_list_free(char **list);
 char **tracefs_list_add(char **list, const char *string);
+int tracefs_list_size(char **list);
 
 /**
  * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index ec5ecb08ed2e..6750336c9ef6 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -447,3 +447,19 @@ char **tracefs_list_add(char **list, const char *string)
 
 	return list;
 }
+
+/**
+ * tracefs_list_size - Return the number of strings in the list
+ * @list: The list to determine the size.
+ *
+ * Returns the number of elements in the list.
+ * If @list is NULL, then zero is returned.
+ */
+int tracefs_list_size(char **list)
+{
+	if (!list)
+		return 0;
+
+	list--;
+	return (int)*(unsigned long *)list;
+}
-- 
2.30.2

