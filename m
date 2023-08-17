Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760ECC71131
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355710AbjHQWYa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 18:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355709AbjHQWYU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CB930F1
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 15:24:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E3CA66D8E
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 22:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CB2C43397;
        Thu, 17 Aug 2023 22:24:17 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.96)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1qWlPj-000Usn-2m;
        Thu, 17 Aug 2023 18:24:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ross Zwisler <zwisler@google.com>,
        Stevie Alvarez <stevie.6strings@gmail.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 9/9] libtraceeval: Only do stats on values marked with the STAT flag
Date:   Thu, 17 Aug 2023 18:24:22 -0400
Message-Id: <20230817222422.118568-10-rostedt@goodmis.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230817222422.118568-1-rostedt@goodmis.org>
References: <20230817222422.118568-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Add TRACEEVAL_FL_STAT to perform stats on the value, otherwise ignore it.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/traceeval-hist.h | 1 +
 samples/task-eval.c      | 1 +
 src/histograms.c         | 2 +-
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
index 81fe805e691d..34f01a51a334 100644
--- a/include/traceeval-hist.h
+++ b/include/traceeval-hist.h
@@ -36,6 +36,7 @@ enum traceeval_flags {
 	TRACEEVAL_FL_VALUE		= (1 << 1),
 	TRACEEVAL_FL_SIGNED		= (1 << 2),
 	TRACEEVAL_FL_TIMESTAMP		= (1 << 3),
+	TRACEEVAL_FL_STAT		= (1 << 3),
 };
 
 /*
diff --git a/samples/task-eval.c b/samples/task-eval.c
index ed3a1a95f097..0e3acb7644ef 100644
--- a/samples/task-eval.c
+++ b/samples/task-eval.c
@@ -147,6 +147,7 @@ static struct traceeval_type delta_vals[] = {
 	{
 		.type	= TRACEEVAL_TYPE_NUMBER_64,
 		.name	= "delta",
+		.flags = TRACEEVAL_FL_STAT,
 	},
 	{
 		.type	= TRACEEVAL_TYPE_NONE,
diff --git a/src/histograms.c b/src/histograms.c
index 973bf3ad279c..8f1cf4187713 100644
--- a/src/histograms.c
+++ b/src/histograms.c
@@ -571,7 +571,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
 		return 0;
 	}
 
-	if (!stat)
+	if (!stat || !(type->flags & TRACEEVAL_FL_STAT))
 		return 0;
 
 	if (!stat->count++) {
-- 
2.40.1

