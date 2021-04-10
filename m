Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0713C43460
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B445161181
	for <linux-trace-devel@archiver.kernel.org>; Sat, 10 Apr 2021 00:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235249AbhDJAhr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 20:37:47 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:14812 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235298AbhDJAhr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 20:37:47 -0400
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Fri, 9 Apr 2021 17:37:26 -0700
Received: from vypre.com (unknown [10.21.244.131])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id 910F221457;
        Fri,  9 Apr 2021 17:37:30 -0700 (PDT)
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <linux-trace-devel@vger.kernel.org>
CC:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 2/3] libtracefs: Add parameter to turn off warnings in str_read_file()
Date:   Fri, 9 Apr 2021 20:37:26 -0400
Message-ID: <20210410003727.2288762-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210410003727.2288762-1-rostedt@goodmis.org>
References: <20210410003727.2288762-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Received-SPF: None (EX13-EDG-OU-001.vmware.com: rostedt@goodmis.org does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

There may be cases when reading a file that warnings should not be
displayed. Add a parameter to str_read_file() that lets the caller tell it
not to warn on any errors.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 include/tracefs-local.h | 2 +-
 src/tracefs-events.c    | 6 +++---
 src/tracefs-instance.c  | 2 +-
 src/tracefs-utils.c     | 8 +++++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/tracefs-local.h b/include/tracefs-local.h
index 84e4b10..9e3aa18 100644
--- a/include/tracefs-local.h
+++ b/include/tracefs-local.h
@@ -42,7 +42,7 @@ static inline pthread_mutex_t *trace_get_lock(struct tracefs_instance *instance)
 /* Can be overridden */
 void tracefs_warning(const char *fmt, ...);
 
-int str_read_file(const char *file, char **buffer);
+int str_read_file(const char *file, char **buffer, bool warn);
 char *trace_append_file(const char *dir, const char *name);
 char *trace_find_tracing_dir(void);
 
diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index 9a706ab..ab474e0 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -485,7 +485,7 @@ char **tracefs_tracers(const char *tracing_dir)
 	if (ret < 0)
 		goto out_free;
 
-	len = str_read_file(available_tracers, &buf);
+	len = str_read_file(available_tracers, &buf, true);
 	if (len <= 0)
 		goto out_free;
 
@@ -545,7 +545,7 @@ static int load_events(struct tep_handle *tep,
 		if (ret < 0)
 			goto next_event;
 
-		len = str_read_file(format, &buf);
+		len = str_read_file(format, &buf, true);
 		if (len <= 0)
 			goto next_event;
 
@@ -575,7 +575,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
 	if (ret < 0)
 		goto out;
 
-	len = str_read_file(header, &buf);
+	len = str_read_file(header, &buf, true);
 	if (len <= 0)
 		goto out;
 
diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index c6cfbda..b8ce36f 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -400,7 +400,7 @@ char *tracefs_instance_file_read(struct tracefs_instance *instance,
 	if (!path)
 		return NULL;
 
-	size = str_read_file(path, &buf);
+	size = str_read_file(path, &buf, true);
 
 	tracefs_put_tracing_file(path);
 	if (buf && psize)
diff --git a/src/tracefs-utils.c b/src/tracefs-utils.c
index 812a41a..e10b333 100644
--- a/src/tracefs-utils.c
+++ b/src/tracefs-utils.c
@@ -196,7 +196,7 @@ void tracefs_put_tracing_file(char *name)
 	free(name);
 }
 
-__hidden int str_read_file(const char *file, char **buffer)
+__hidden int str_read_file(const char *file, char **buffer, bool warn)
 {
 	char stbuf[BUFSIZ];
 	char *buf = NULL;
@@ -207,7 +207,8 @@ __hidden int str_read_file(const char *file, char **buffer)
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0) {
-		tracefs_warning("File %s not found", file);
+		if (warn)
+			tracefs_warning("File %s not found", file);
 		return -1;
 	}
 
@@ -217,7 +218,8 @@ __hidden int str_read_file(const char *file, char **buffer)
 			continue;
 		nbuf = realloc(buf, size+r+1);
 		if (!nbuf) {
-			tracefs_warning("Failed to allocate file buffer");
+			if (warn)
+				tracefs_warning("Failed to allocate file buffer");
 			size = -1;
 			break;
 		}
-- 
2.29.2

