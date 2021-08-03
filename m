Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF4FC4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 696F561164
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhHCEYq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 00:24:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233627AbhHCEYH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 00:24:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB366112D;
        Tue,  3 Aug 2021 04:23:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAly8-002qnm-3c; Tue, 03 Aug 2021 00:23:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 16/21] libtracefs: Add error message when calculation has no label
Date:   Tue,  3 Aug 2021 00:23:42 -0400
Message-Id: <20210803042347.679499-17-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803042347.679499-1-rostedt@goodmis.org>
References: <20210803042347.679499-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

If a calculation between event fields is performed and there's no label
(name) for it, it errors out, causing the bison parser to give a strange
error:

  FAILED MEMORY: add_selection(sb, (yyvsp[0].expr), NULL)
  Failed creating synthetic event!: No such file or directory

Instead, just set the compare->name field to NULL, and report a better
error later on in the processing.

  ERROR: 'no name'
  Field calculations must be labeled 'AS name'

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/tracefs-sqlhist.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index f191661610c9..c27f7478a527 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -242,8 +242,6 @@ __hidden int add_selection(struct sqlhist_bison *sb, void *select,
 	case EXPR_FIELD:
 		break;
 	case EXPR_COMPARE:
-		if (!name)
-			return -1;
 		expr->compare.name = name;
 		break;
 	case EXPR_NUMBER:
@@ -692,6 +690,9 @@ static int build_compare(struct tracefs_synth *synth,
 	enum tracefs_synth_calc calc;
 	int ret;
 
+	if (!compare->name)
+		return -1;
+
 	lval = &compare->lval->field;
 	rval = &compare->rval->field;
 
@@ -1069,6 +1070,14 @@ static void compare_error(struct tep_handle *tep,
 {
 	struct compare *compare = &expr->compare;
 
+	if (!compare->name) {
+		sb->line_no = expr->line;
+		sb->line_idx = expr->idx + strlen("no name");
+
+		parse_error(sb, "no name",
+		    "Field calculations must be labeled 'AS name'\n");
+	}
+
 	switch (errno) {
 	case ENODEV:
 	case EBADE:
-- 
2.30.2

