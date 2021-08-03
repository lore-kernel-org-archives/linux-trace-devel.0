Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58CF0C4320E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A359610A0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 17:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbhHCRGX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 13:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237479AbhHCRGU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 13:06:20 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B806109F;
        Tue,  3 Aug 2021 17:06:08 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAxrj-002ubk-Ol; Tue, 03 Aug 2021 13:06:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v3 08/22] libtracefs: Make parser unique to libtracefs
Date:   Tue,  3 Aug 2021 13:05:52 -0400
Message-Id: <20210803170606.694085-9-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803170606.694085-1-rostedt@goodmis.org>
References: <20210803170606.694085-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Add %define api.prefix and defines to have the parser global variables use
tracefs_* instead of yy*, as without this, if a tool that links to this
library, and tries to use the synth sql parsing, it may end up using its
own yyparse() and friends functions.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 src/sqlhist.y         | 10 ++++++++++
 src/tracefs-sqlhist.c |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/sqlhist.y b/src/sqlhist.y
index ce9cb58fb3a9..9d03a457ae84 100644
--- a/src/sqlhist.y
+++ b/src/sqlhist.y
@@ -30,6 +30,16 @@ extern void yyerror(struct sqlhist_bison *, char *fmt, ...);
 %}
 
 %define api.pure
+
+/* Change the globals to use tracefs_ prefix */
+%define api.prefix{tracefs_}
+%code provides
+{
+  #define YYSTYPE TRACEFS_STYPE
+  #define yylex tracefs_lex
+  #define yyerror tracefs_error
+}
+
 %lex-param {void *scanner}
 %parse-param {struct sqlhist_bison *sb}
 
diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 65577c9b7de3..70bcab14cb27 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1086,7 +1086,7 @@ struct tracefs_synth *tracefs_sql(struct tep_handle *tep, const char *name,
 		return NULL;
 	}
 
-	ret = yyparse(&sb);
+	ret = tracefs_parse(&sb);
 	yylex_destroy(sb.scanner);
 
 	if (ret)
-- 
2.30.2

