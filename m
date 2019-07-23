Return-Path: <SRS0=P3iB=VU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75059C76186
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 20:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 487C52253D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Jul 2019 20:59:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391890AbfGWU7N (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Jul 2019 16:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389103AbfGWU7M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Jul 2019 16:59:12 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E1422253D;
        Tue, 23 Jul 2019 20:59:12 +0000 (UTC)
Date:   Tue, 23 Jul 2019 16:59:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: kernel-shark: Suppress "Root privileges are required" if already
 root
Message-ID: <20190723165910.3319ccbb@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: Steven Rostedt (VMware) <rostedt@goodmis.org>

If the tracefs directory is configured into the kernel, and
kshark-record  fails to find the tracing directory, it should test if
it already has root privileges (geteuid() returns zero), before posting
a message "Root privileges are required" as that can confuse users.

Reported-by: howaboutsynergy@pm.me
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
diff --git a/kernel-shark/src/KsCaptureDialog.cpp b/kernel-shark/src/KsCaptureDialog.cpp
index 2e6e8f9c..dbf73302 100644
--- a/kernel-shark/src/KsCaptureDialog.cpp
+++ b/kernel-shark/src/KsCaptureDialog.cpp
@@ -18,6 +18,12 @@
 #include "KsCmakeDef.hpp"
 #include "KsCaptureDialog.hpp"
 
+extern "C" {
+  // To get access to geteuid()
+  #include <unistd.h>
+  #include <sys/types.h>
+}
+
 static inline tep_handle *local_events()
 {
 	return tracecmd_local_events(tracecmd_get_tracing_dir());
@@ -65,7 +71,9 @@ KsCaptureControl::KsCaptureControl(QWidget *parent)
 
 		if (!_localTEP)
 			message += "Cannot find or mount tracing directory.\n";
-		if (!pluginList.count())
+
+		// geteuid() returns 0 if running as effective id of root
+		if (!pluginList.count() && geteuid())
 			message += "Root privileges are required.\n";
 
 		QLabel *errorLabel = new QLabel(message);
