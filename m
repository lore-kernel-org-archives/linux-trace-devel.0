Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C854C282D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EDAE20857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfA3Koc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:32 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41468 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Kob (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:31 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so25432592wrs.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hp78ZfnBwjZGta5mALPAnQjOB/5k6jNLjv6/AK8elN4=;
        b=K60E2yA8x7Ua5FLZ9BJwvXugTtXKCPprla3rTS9eu/zZqZE/cXkabLl4+9JOoppOdb
         rE3NaN/Mh4dgAe6Fb5HiajxJRkFuxFzH9IwNhgGtl3ZHtUEve1Y8JLlIqhKcfzRTpF/L
         D+uimdE7y2ErjeNm9jDfX6RRzlsMJLZlpsgZxOwmHvBhkaJice0joA718R+K0w/VOpzP
         Rtr8V1SZDwSFd8dqbV0ExvXwyH+w2l0hLFUPHwz1wzZ2v1I6QON2NYlOevdT/wfkHJFR
         fyGrZ3NmLMNBchidNn0LVdbmBue/WfM5nCjur9RUa9sYuralMlhDkik088Xp921WNTfg
         eynw==
X-Gm-Message-State: AJcUukfcvtd/Z/yY5yYjMTZj5vOSK9xUz4z8pc+LC9Sj3MXkR2DVCuCS
        pH1VoNILgJmUbcpocSeagOzaKl1v
X-Google-Smtp-Source: ALg8bN7jKRb8oo7E1tkrh5JXVVoa7EogekCDc4H9mqjptxLGDclEXsjNFj2WzdiuCJAwWpfXZASGVw==
X-Received: by 2002:adf:891a:: with SMTP id s26mr29360303wrs.44.1548845069539;
        Wed, 30 Jan 2019 02:44:29 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:29 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/6] trace_cmd: Rename struct cmdline to struct tep_cmdline
Date:   Wed, 30 Jan 2019 12:44:21 +0200
Message-Id: <20190130104425.8813-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make libtraceevent a proper library, variables, data
structures and functions should have a unique prefix to prevent name
space conflicts. That prefix will be "tep_".

This patch renames 'struct cmdline' to 'struct tep_cmdline'.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.358871851@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h   |  8 +++----
 lib/traceevent/event-parse-local.h |  4 ++--
 lib/traceevent/event-parse.c       | 36 +++++++++++++++---------------
 tracecmd/trace-read.c              |  3 ++-
 4 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 3f2ae80..426b7eb 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -515,10 +515,10 @@ int tep_data_pid(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_preempt_count(struct tep_handle *pevent, struct tep_record *rec);
 int tep_data_flags(struct tep_handle *pevent, struct tep_record *rec);
 const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid);
-struct cmdline;
-struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-				       struct cmdline *next);
-int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline);
+struct tep_cmdline;
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+					   struct tep_cmdline *next);
+int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline);
 
 void tep_print_field(struct trace_seq *s, void *data,
 		     struct tep_format_field *field);
diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index 70693b8..c5c8eb4 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -7,7 +7,7 @@
 #ifndef _PARSE_EVENTS_INT_H
 #define _PARSE_EVENTS_INT_H
 
-struct cmdline;
+struct tep_cmdline;
 struct cmdline_list;
 struct func_map;
 struct func_list;
@@ -36,7 +36,7 @@ struct tep_handle {
 	int long_size;
 	int page_size;
 
-	struct cmdline *cmdlines;
+	struct tep_cmdline *cmdlines;
 	struct cmdline_list *cmdlist;
 	int cmdline_count;
 
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index b506dc7..1f1821d 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -124,15 +124,15 @@ struct tep_print_arg *alloc_arg(void)
 	return calloc(1, sizeof(struct tep_print_arg));
 }
 
-struct cmdline {
+struct tep_cmdline {
 	char *comm;
 	int pid;
 };
 
 static int cmdline_cmp(const void *a, const void *b)
 {
-	const struct cmdline *ca = a;
-	const struct cmdline *cb = b;
+	const struct tep_cmdline *ca = a;
+	const struct tep_cmdline *cb = b;
 
 	if (ca->pid < cb->pid)
 		return -1;
@@ -152,7 +152,7 @@ static int cmdline_init(struct tep_handle *pevent)
 {
 	struct cmdline_list *cmdlist = pevent->cmdlist;
 	struct cmdline_list *item;
-	struct cmdline *cmdlines;
+	struct tep_cmdline *cmdlines;
 	int i;
 
 	cmdlines = malloc(sizeof(*cmdlines) * pevent->cmdline_count);
@@ -179,8 +179,8 @@ static int cmdline_init(struct tep_handle *pevent)
 
 static const char *find_cmdline(struct tep_handle *pevent, int pid)
 {
-	const struct cmdline *comm;
-	struct cmdline key;
+	const struct tep_cmdline *comm;
+	struct tep_cmdline key;
 
 	if (!pid)
 		return "<idle>";
@@ -208,8 +208,8 @@ static const char *find_cmdline(struct tep_handle *pevent, int pid)
  */
 int tep_pid_is_registered(struct tep_handle *pevent, int pid)
 {
-	const struct cmdline *comm;
-	struct cmdline key;
+	const struct tep_cmdline *comm;
+	struct tep_cmdline key;
 
 	if (!pid)
 		return 1;
@@ -235,9 +235,9 @@ int tep_pid_is_registered(struct tep_handle *pevent, int pid)
 static int add_new_comm(struct tep_handle *pevent,
 			const char *comm, int pid, bool override)
 {
-	struct cmdline *cmdlines = pevent->cmdlines;
-	struct cmdline *cmdline;
-	struct cmdline key;
+	struct tep_cmdline *cmdlines = pevent->cmdlines;
+	struct tep_cmdline *cmdline;
+	struct tep_cmdline key;
 	char *new_comm;
 
 	if (!pid)
@@ -5332,8 +5332,8 @@ const char *tep_data_comm_from_pid(struct tep_handle *pevent, int pid)
 	return comm;
 }
 
-static struct cmdline *
-pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *next)
+static struct tep_cmdline *
+pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct tep_cmdline *next)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)next;
 
@@ -5345,7 +5345,7 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
 	while (cmdlist && strcmp(cmdlist->comm, comm) != 0)
 		cmdlist = cmdlist->next;
 
-	return (struct cmdline *)cmdlist;
+	return (struct tep_cmdline *)cmdlist;
 }
 
 /**
@@ -5361,10 +5361,10 @@ pid_from_cmdlist(struct tep_handle *pevent, const char *comm, struct cmdline *ne
  * next pid.
  * Also, it does a linear search, so it may be slow.
  */
-struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
-				       struct cmdline *next)
+struct tep_cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *comm,
+					   struct tep_cmdline *next)
 {
-	struct cmdline *cmdline;
+	struct tep_cmdline *cmdline;
 
 	/*
 	 * If the cmdlines have not been converted yet, then use
@@ -5403,7 +5403,7 @@ struct cmdline *tep_data_pid_from_comm(struct tep_handle *pevent, const char *co
  * Returns the pid for a give cmdline. If @cmdline is NULL, then
  * -1 is returned.
  */
-int tep_cmdline_pid(struct tep_handle *pevent, struct cmdline *cmdline)
+int tep_cmdline_pid(struct tep_handle *pevent, struct tep_cmdline *cmdline)
 {
 	struct cmdline_list *cmdlist = (struct cmdline_list *)cmdline;
 
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 804022a..4cc1f61 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -419,9 +419,10 @@ static char *append_pid_filter(char *curr_filter, char *pid)
 
 static void convert_comm_filter(struct tracecmd_input *handle)
 {
+	struct tep_cmdline *cmdline;
 	struct tep_handle *pevent;
 	struct pid_list *list;
-	struct cmdline *cmdline;
+
 	char pidstr[100];
 
 	if (!comm_list)
-- 
2.20.1

