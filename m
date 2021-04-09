Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED022C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBC45610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbhDIPQX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:16:23 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:55164 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233878AbhDIPQV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 11:16:21 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 08:16:03 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id 386A020D49;
        Fri,  9 Apr 2021 08:16:07 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 1/3] libtracefs: Do some cleanups to the trace_marker.c code
Date:   Fri, 9 Apr 2021 11:16:02 -0400
Message-ID: <20210409151604.2224578-2-rostedt@goodmis.org>
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

Just some clean ups.

- Make the if statement simpler in marker_init()
- Remove unnecessary "+ 1" to string length when writing to the
  trace_marker file.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-marker.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-marker.c b/src/tracefs-marker.c
index 0dc72f6..924ceea 100644
--- a/src/tracefs-marker.c
+++ b/src/tracefs-marker.c
@@ -24,14 +24,13 @@ static inline int *get_marker_fd(struct tracefs_instance *instance, bool raw)
 
 static int marker_init(struct tracefs_instance *instance, bool raw)
 {
+	const char *file = raw ? "trace_marker_raw" : "trace_marker";
 	int *fd = get_marker_fd(instance, raw);
 
 	if (*fd >= 0)
 		return 0;
-	if (raw)
-		*fd = tracefs_instance_file_open(instance, "trace_marker_raw", O_WRONLY | O_CLOEXEC);
-	else
-		*fd = tracefs_instance_file_open(instance, "trace_marker", O_WRONLY | O_CLOEXEC);
+
+	*fd = tracefs_instance_file_open(instance, file, O_WRONLY | O_CLOEXEC);
 
 	return *fd < 0 ? -1 : 0;
 }
@@ -95,7 +94,7 @@ int tracefs_vprintf(struct tracefs_instance *instance, const char *fmt, va_list
 	ret = vasprintf(&str, fmt, ap);
 	if (ret < 0)
 		return ret;
-	ret = marker_write(instance, false, str, strlen(str) + 1);
+	ret = marker_write(instance, false, str, strlen(str));
 	free(str);
 
 	return ret;
-- 
2.29.2

