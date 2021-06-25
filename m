Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14418C49EA7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDDAC61954
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhFYWUF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:20:05 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:28184 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhFYWUF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 18:20:05 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 15:17:40 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 8A82E20327;
        Fri, 25 Jun 2021 15:17:43 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeross1994@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/4] libtracefs: Fix the errno values of tracefs_tracer_set()
Date:   Fri, 25 Jun 2021 18:17:37 -0400
Message-ID: <20210625221739.1215557-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210625221739.1215557-1-rostedt@goodmis.org>
References: <20210625221739.1215557-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-002.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Be consistent with the errno values on error for tracefs_tracer_set(). If
a bad enum is passed in, then EINVAL should be set, not ENODEV. But if the
tracer does not exist, then ENODEV should be set (even though the write
will return EINVAL).

Also fix the setting of errno to negative values. That's done in the
kernel, not user space.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index fb243d8..6d5ddae 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -979,12 +979,12 @@ int tracefs_tracer_set(struct tracefs_instance *instance,
 
 	fd = open(tracer_path, O_WRONLY);
 	if (fd < 0) {
-		errno = -ENOENT;
+		errno = ENOENT;
 		goto out;
 	}
 
 	if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
-		errno = -ENODEV;
+		errno = EINVAL;
 		goto out;
 	}
 
@@ -1005,10 +1005,16 @@ int tracefs_tracer_set(struct tracefs_instance *instance,
 		}
 	}
 	if (!t) {
-		errno = -EINVAL;
+		errno = EINVAL;
 		goto out;
 	}
 	ret = write_tracer(fd, t);
+	/*
+	 * If the tracer does not exist, EINVAL is returned,
+	 * but let the user know this as ENODEV.
+	 */
+	if (ret < 0 && errno == EINVAL)
+		errno = ENODEV;
  out:
 	tracefs_put_tracing_file(tracer_path);
 	close(fd);
-- 
2.30.2

