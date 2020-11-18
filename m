Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17826C5519F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4120246CE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 21:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKRVqO (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgKRVqO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 16:46:14 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58477221EB;
        Wed, 18 Nov 2020 21:46:13 +0000 (UTC)
Date:   Wed, 18 Nov 2020 16:46:11 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4.1 - 5.1/8] libtracefs: Use the permissions of the
 instances  directory for instances
Message-ID: <20201118164611.007c6900@oasis.local.home>
In-Reply-To: <20201118164416.4cf12941@oasis.local.home>
References: <20201117074557.180602-1-tz.stoyanov@gmail.com>
        <20201117074557.180602-6-tz.stoyanov@gmail.com>
        <20201118164416.4cf12941@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

Use the same permissions of the instances directory for the permissions of
creating a new instance.

Link: https://lore.kernel.org/linux-trace-devel/20201117074557.180602-6-tz.stoyanov@gmail.com

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/tracefs/tracefs-instance.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/lib/tracefs/tracefs-instance.c b/lib/tracefs/tracefs-instance.c
index 06f33c35..13ec4f5f 100644
--- a/lib/tracefs/tracefs-instance.c
+++ b/lib/tracefs/tracefs-instance.c
@@ -57,6 +57,25 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 	free(instance);
 }
 
+static mode_t get_trace_file_permissions(char *name)
+{
+	mode_t rmode = 0;
+	struct stat st;
+	char *path;
+	int ret;
+
+	path = tracefs_get_tracing_file(name);
+	if (!path)
+		return 0;
+	ret = stat(path, &st);
+	if (ret)
+		goto out;
+	rmode = st.st_mode & ACCESSPERMS;
+out:
+	tracefs_put_tracing_file(path);
+	return rmode;
+}
+
 /**
  * tracefs_instance_create - Create a new ftrace instance
  * @instance: Pointer to the instance to be created
@@ -67,15 +86,18 @@ void tracefs_instance_free(struct tracefs_instance *instance)
 int tracefs_instance_create(struct tracefs_instance *instance)
 {
 	struct stat st;
+	mode_t mode;
 	char *path;
 	int ret;
 
 	path = tracefs_instance_get_dir(instance);
 	ret = stat(path, &st);
-	if (ret < 0)
-		ret = mkdir(path, 0777);
-	else
+	if (ret < 0) {
+		mode = get_trace_file_permissions("instances");
+		ret = mkdir(path, mode);
+	} else {
 		ret = 1;
+	}
 	tracefs_put_tracing_file(path);
 	return ret;
 }
-- 
2.25.4

