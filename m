Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 891BAC432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 714BF61158
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Aug 2021 04:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbhHCEYV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Aug 2021 00:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233719AbhHCEYI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 00:24:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DEAD611C2;
        Tue,  3 Aug 2021 04:23:57 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94.2)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mAly8-002qnv-6k; Tue, 03 Aug 2021 00:23:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Tom Zanussi <zanussi@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Clark Williams <williams@redhat.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH v2 19/21] libtracefs: Allow trace_sql() to take keywords for fields with backslash
Date:   Tue,  3 Aug 2021 00:23:45 -0400
Message-Id: <20210803042347.679499-20-rostedt@goodmis.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803042347.679499-1-rostedt@goodmis.org>
References: <20210803042347.679499-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

Some events have fields with keywords, and the parsing will not let it
work. For example, you can have:

  select from from regcache_drop_region

And that will produce a syntax error, as the from will confuse the parser.
Allow fields to start with a backslash, which will allow the parser to see
"from" as a field and not as a keyword. That is:

  select \from from regcache_drop_region

will work as expected. Note, any field can start with a backslash, and the
starting backslash will be ignored.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Documentation/libtracefs-sql.txt | 20 ++++++++++++++++++++
 src/sqlhist.l                    |  6 ++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/libtracefs-sql.txt b/Documentation/libtracefs-sql.txt
index 190abe641d7c..e38ed7649432 100644
--- a/Documentation/libtracefs-sql.txt
+++ b/Documentation/libtracefs-sql.txt
@@ -162,6 +162,26 @@ select start.pid, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat from sche
    WHERE start.prio < 100 || end.prev_prio < 100
 --
 
+
+KEYWORDS AS EVENT FIELDS
+------------------------
+
+In some cases, an event may have a keyword. For example, regcache_drop_region has "from"
+as a field and the following will not work
+
+[source,c]
+--
+  select from from regcache_drop_region
+--
+
+In such cases, add a backslash to the conflicting field, and this will tell the parser
+that the "from" is a field and not a keyword:
+
+[source,c]
+--
+  select \from from regcache_drop_region
+--
+
 HISTOGRAMS
 ----------
 
diff --git a/src/sqlhist.l b/src/sqlhist.l
index f9e0fcc17e63..897daac7d2a8 100644
--- a/src/sqlhist.l
+++ b/src/sqlhist.l
@@ -25,7 +25,7 @@ extern int my_yyinput(void *extra, char *buf, int max);
 %option reentrant
 %option bison-bridge
 
-field		[a-z_][a-z0-9_\.]*
+field		\\?[a-z_][a-z0-9_\.]*
 qstring		\"[^\"]*\"
 hexnum		0x[0-9a-f]+
 number		[0-9a-f]+
@@ -46,8 +46,10 @@ where { HANDLE_COLUMN; return WHERE; }
 }
 
 {field} {
+	const char *str = yyg->yytext_r;
 	HANDLE_COLUMN;
-	yylval->string = store_str(TRACE_SB, yyg->yytext_r);
+	if (str[0] == '\\') { str++; };
+	yylval->string = store_str(TRACE_SB, str);
 	return FIELD;
 }
 
-- 
2.30.2

