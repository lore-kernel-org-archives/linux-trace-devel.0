Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6999C2B9F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C364B61952
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jun 2021 22:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhFYWUG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jun 2021 18:20:06 -0400
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:28186 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229954AbhFYWUG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jun 2021 18:20:06 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 25 Jun 2021 15:17:40 -0700
Received: from oasis.vmware.com (unknown [10.84.232.102])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 4B98A20327;
        Fri, 25 Jun 2021 15:17:44 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     Sameeruddin shaik <sameeross1994@gmail.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 3/4] libtracefs: Check tracer parameter first in tracefs_tracer_set()
Date:   Fri, 25 Jun 2021 18:17:38 -0400
Message-ID: <20210625221739.1215557-4-rostedt@goodmis.org>
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

There's no reason to open the current_tracer file, nor even find its path
before checking if the tracer parameter is valid or not. Instead of
checking that later in the process and then having to "clean up" what has
already been done, check it first, and simply return with error if it is
not valid.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-tools.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 6d5ddae..0e689aa 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -973,6 +973,11 @@ int tracefs_tracer_set(struct tracefs_instance *instance,
 	int fd = -1;
 	int i;
 
+	if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
+		errno = EINVAL;
+		return -1;
+	}
+
 	tracer_path = tracefs_instance_get_file(instance, CUR_TRACER);
 	if (!tracer_path)
 		return -1;
@@ -983,11 +988,6 @@ int tracefs_tracer_set(struct tracefs_instance *instance,
 		goto out;
 	}
 
-	if (tracer < 0 || tracer > ARRAY_SIZE(tracers)) {
-		errno = EINVAL;
-		goto out;
-	}
-
 	if (tracer == TRACEFS_TRACER_CUSTOM) {
 		va_list ap;
 
-- 
2.30.2

