Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAABC433EB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16BD56024A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Mar 2021 00:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC3AxP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 29 Mar 2021 20:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230100AbhC3Awu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 29 Mar 2021 20:52:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13B1D61997;
        Tue, 30 Mar 2021 00:52:50 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lR2cj-003Tip-3B; Mon, 29 Mar 2021 20:52:49 -0400
Message-ID: <20210330005248.979418078@goodmis.org>
User-Agent: quilt/0.66
Date:   Mon, 29 Mar 2021 20:51:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: [PATCH 12/13 v2] libtracefs: Move struct tracefs_instance to tracefs-local.h
References: <20210330005123.151740983@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

In order to have direct access to the tracefs_instance structure for all
of the libtracefs internal code, move it to the tracefs-local.h file, then
other parts of libtracefs code can use it to store internal data.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 6 ++++++
 src/tracefs-instance.c  | 5 -----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 187870e7c491..9c18218cd916 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -14,6 +14,12 @@
 #define BUILD_BUG_ON(cond)			\
 	do { if (!(1/!(cond))) { } } while (0)
 
+struct tracefs_instance {
+	char	*trace_dir;
+	char	*name;
+	int	flags;
+};
+
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 0df313c8e8c6..a02c839f2079 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -19,11 +19,6 @@
 #include "tracefs-local.h"
 
 #define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
-struct tracefs_instance {
-	char	*trace_dir;
-	char	*name;
-	int	flags;
-};
 
 /**
  * instance_alloc - allocate a new ftrace instance
-- 
2.30.1


