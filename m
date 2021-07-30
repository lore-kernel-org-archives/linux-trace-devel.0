Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A4AC4338F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B7E60EB5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 30 Jul 2021 03:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234496AbhG3DDZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234733AbhG3DDP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 23:03:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7905360E9B;
        Fri, 30 Jul 2021 03:03:11 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1m9Inm-002PQv-2b; Thu, 29 Jul 2021 23:03:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/6] libtracefs: Rename GR and NQ to GT and NE respectively
Date:   Thu, 29 Jul 2021 23:03:03 -0400
Message-Id: <20210730030307.574270-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210730030307.574270-1-rostedt@goodmis.org>
References: <20210730030307.574270-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

When writing the sqlhist interface, I found that calling ">" GT and "!="
NE were more sensible than calling them GR and NQ, as we already have LT
as "less than" why not use GT as "greater than". As well as EQ for
"equal", it seems more appropriate to have NE be "not equal".

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-synth.txt | 4 ++--
 include/tracefs.h                  | 4 ++--
 src/tracefs-hist.c                 | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Documentation/libtracefs-synth.txt b/Documentation/libtracefs-synth.txt
index 0e74e4f3aa0b..b20b4a7eb911 100644
--- a/Documentation/libtracefs-synth.txt
+++ b/Documentation/libtracefs-synth.txt
@@ -137,9 +137,9 @@ may be one of:
 
 *TRACEFS_COMPARE_EQ* - _field_ == _val_
 
-*TRACEFS_COMPARE_NQ* - _field_ != _val_
+*TRACEFS_COMPARE_NE* - _field_ != _val_
 
-*TRACEFS_COMPARE_GR* - _field_ > _val_
+*TRACEFS_COMPARE_GT* - _field_ > _val_
 
 *TRACEFS_COMPARE_GE* - _field_ >= _val_
 
diff --git a/include/tracefs.h b/include/tracefs.h
index 9cfd2577da2e..03a16bbffdc7 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -315,8 +315,8 @@ enum tracefs_synth_calc {
 
 enum tracefs_synth_compare {
 	TRACEFS_COMPARE_EQ,
-	TRACEFS_COMPARE_NQ,
-	TRACEFS_COMPARE_GR,
+	TRACEFS_COMPARE_NE,
+	TRACEFS_COMPARE_GT,
 	TRACEFS_COMPARE_GE,
 	TRACEFS_COMPARE_LT,
 	TRACEFS_COMPARE_LE,
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 8b9078791ab2..11355e648692 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1178,11 +1178,11 @@ static int add_synth_filter(char **filter, const char *field,
 		op = "==";
 		break;
 
-	case TRACEFS_COMPARE_NQ:
+	case TRACEFS_COMPARE_NE:
 		op = "!=";
 		break;
 
-	case TRACEFS_COMPARE_GR:
+	case TRACEFS_COMPARE_GT:
 		op = ">";
 		if (is_string)
 			goto inval;
-- 
2.30.2

