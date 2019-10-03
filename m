Return-Path: <SRS0=xFsM=X4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 901F9C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 14:44:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA2B215EA
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Oct 2019 14:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbfJCOo4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 10:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727943AbfJCOoz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 10:44:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31C7920865;
        Thu,  3 Oct 2019 14:44:55 +0000 (UTC)
Date:   Thu, 3 Oct 2019 10:44:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 3/2] trace-cmd: Optimize the logic of reset_cpu_mask()
Message-ID: <20191003104453.51fbdadb@gandalf.local.home>
In-Reply-To: <20191001145740.8866-1-tz.stoyanov@gmail.com>
References: <20191001145740.8866-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Change the logic of reset_cpu_mask() to be a little more condensed, and also
move the buffer onto the stack and eliminate the warning message as we no
longer need to use malloc.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 6f3520cc..cfe67f90 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4100,27 +4100,14 @@ static void reset_cpu_mask(void)
 {
 	struct buffer_instance *instance;
 	int cpus = count_cpus();
-	int fullwords;
-	char *buf;
-	int bits;
-	int len;
+	int fullwords = (cpus - 1) / 32;
+	int bits = (cpus - 1) % 32 + 1;
+	int len = (fullwords + 1) * 9;
+	char buf[len + 1];
 
-	fullwords = cpus / 32;
-	bits = cpus % 32;
-	len = (fullwords + 1) * 9;
-
-	buf = malloc(len + 1);
-	if (!buf) {
-		warning("Unable to allocate %d bytes for cpu mask", len + 1);
-		return;
-	}
 	buf[0] = '\0';
-	if (bits) {
-		sprintf(buf, "%x", (1 << bits) - 1);
-	} else if (fullwords) {
-		strcat(buf, "ffffffff");
-		fullwords--;
-	}
+
+	sprintf(buf, "%x", (unsigned int)((1ULL << bits) - 1));
 	while (fullwords-- > 0)
 		strcat(buf, ",ffffffff");
 
-- 
2.20.1

