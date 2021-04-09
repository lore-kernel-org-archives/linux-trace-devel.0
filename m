Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16219C43460
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9137610CF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 15:16:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhDIPQX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 11:16:23 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:36110 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234037AbhDIPQV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 11:16:21 -0400
Received: from sc9-mailhost1.vmware.com (10.113.161.71) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 08:16:04 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost1.vmware.com (Postfix) with ESMTP id DB68720D41;
        Fri,  9 Apr 2021 08:16:07 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Add helper function trace_get_lock()
Date:   Fri, 9 Apr 2021 11:16:03 -0400
Message-ID: <20210409151604.2224578-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210409151604.2224578-1-rostedt@goodmis.org>
References: <20210409151604.2224578-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Since more APIs will need to get the instance pthread mutex or the
toplevel pthread mutex depending on if the lock needed to change an
instance or the top level state, create trace_get_lock() to not need to
reimplement the conditional for every instance it is used.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 5 +++++
 src/tracefs-tools.c     | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index ea441b5..1c06a40 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -27,6 +27,11 @@ struct tracefs_instance {
 
 extern pthread_mutex_t toplevel_lock;
 
+static inline pthread_mutex_t *trace_get_lock(struct tracefs_instance *instance)
+{
+	return instance ? &instance->lock : &toplevel_lock;
+}
+
 /* Can be overridden */
 void warning(const char *fmt, ...);
 
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 037875f..6bab2b0 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -756,7 +756,7 @@ static int update_filter(const char *filter_path, int *fd,
 	bool reset = flags & TRACEFS_FL_RESET;
 	bool cont = flags & TRACEFS_FL_CONTINUE;
 	bool future = flags & TRACEFS_FL_FUTURE;
-	pthread_mutex_t *lock = instance ? &instance->lock : &toplevel_lock;
+	pthread_mutex_t *lock = trace_get_lock(instance);
 	int open_flags;
 	int ret = 1;
 
-- 
2.29.2

