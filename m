Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEF4C74A35
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF16F21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khV0vFit"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfGKNDS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40049 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfGKNDS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id r1so6209367wrl.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uGgc6zIRpznErJK829WU0XeMrBpJBqIOq8KS8xENGlk=;
        b=khV0vFitRNgjLRAadymRQIUY8usEONYIKG9HGExfb8rK9k7QBZgklyAfHq+kgb/5P2
         b2xu6/6qQ1DbuVM/7b3GpudqYZaBRr/GF3GSViBPpkAD6yxgCcOFaGXjidETzBn/zVnh
         9FM9k949DS13tq5dQHonbe0djb995GR9nEjhb7xALcZ6PLcLzN+2lTCoaLgD+6Vu44ze
         9zOSLbGzJETfkMhxgmuKK9bVjlErN301RjjbUgl1cyKEYOM7BjVDoypvCwNuD8iui7Y/
         VmyQ/xb4YExy3ACF0VQjZd5ehimfsmvJcmn3tA7PEQKRdSibIRgvO9LDmCaOWXznQViM
         DZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uGgc6zIRpznErJK829WU0XeMrBpJBqIOq8KS8xENGlk=;
        b=PKWeNeDjChM14mynVyZ423Q/X0PCC5edibTRNbgqDrZp6kvkKXqiGRts+owDR0bDR9
         8+22mCpcRZb8JzaL00n4rwuDAt2HIjEMbbW4PguvGp/JJ9ePM+VOQkhckXEcAp+pxUOo
         zB2no/PaiJf54+P55Fu0+0NLL/ntQYa8tNxTjTNTcB1SRGbpg8SewPJurZ0vclLiLGkd
         9XpQ8TSZNiRUMmCxz8N57cRndVDqwaGba+9dX9X9tw8DPz/Ld2kARD2QRwsqd2yrf/q7
         FuFGnx46XIdtIlJ07KueP7DOXUxpZoNJYhjOUXWbZxwiXaEzjgLoQYeuTC8ECb1N0A5g
         Ca0Q==
X-Gm-Message-State: APjAAAW5OnjdHxhnBaAHL/AznQ6miesDz6nXfGvEmRJemzCo0w4wWu3x
        O3vjnXWfqvf8dSpwqexfN1s=
X-Google-Smtp-Source: APXvYqwWiyauDVvt1X8+PAthykBW+qB+QPgMd38XqHF9ousY80rhJ8WnIgoCPDVQzSjf/DyuY2aybA==
X-Received: by 2002:adf:e947:: with SMTP id m7mr5325600wrn.123.1562850196002;
        Thu, 11 Jul 2019 06:03:16 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 5/7] trace-cmd: Move plog() function to libtracecmd.
Date:   Thu, 11 Jul 2019 16:03:05 +0300
Message-Id: <20190711130307.25041-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

plog() function writes logs into a log file. It is used in
libtracecmd and its implementation should be there.
The function is moved from trace-cmd into the library, and 2
additional APIs are implemented:
	int trace_set_log_file(char *logfile); - use it to set
the log file.
	void plog_error(const char *fmt, ...); - use it to log
an error message into the file.

The plog() function is used also from pdie() in trace-cmd.
pdie() depends on trace-cmd context and cannot be moved to
the library. It is reimplemented as macros, in order to utilize
the new plog() library function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  4 ++
 include/trace-cmd/trace-msg.h |  3 --
 lib/trace-cmd/trace-util.c    | 71 +++++++++++++++++++++++++++++++++++
 tracecmd/trace-listen.c       | 69 ++++------------------------------
 4 files changed, 83 insertions(+), 64 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 2f524b6..5cfb028 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -388,6 +388,10 @@ struct hook_list {
 struct hook_list *tracecmd_create_event_hook(const char *arg);
 void tracecmd_free_hooks(struct hook_list *hooks);
 
+void plog(const char *fmt, ...);
+void plog_error(const char *fmt, ...);
+int trace_set_log_file(char *logfile);
+
 /* --- Hack! --- */
 int tracecmd_blk_hack(struct tracecmd_input *handle);
 
diff --git a/include/trace-cmd/trace-msg.h b/include/trace-cmd/trace-msg.h
index b7fe10b..aab8a69 100644
--- a/include/trace-cmd/trace-msg.h
+++ b/include/trace-cmd/trace-msg.h
@@ -12,7 +12,4 @@
 
 extern unsigned int page_size;
 
-void plog(const char *fmt, ...);
-void pdie(const char *fmt, ...);
-
 #endif /* _TRACE_MSG_H_ */
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index b5ce84f..8c1a0a0 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -31,6 +31,8 @@ int tracecmd_disable_plugins;
 static int tracecmd_quiet;
 static bool tracecmd_debug;
 
+static FILE *trace_logfp;
+
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
 	struct tep_plugin_option			*options;
@@ -1716,3 +1718,72 @@ void __weak *malloc_or_die(unsigned int size)
 		die("malloc");
 	return data;
 }
+
+#define LOG_BUF_SIZE 1024
+static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
+{
+	static int newline = 1;
+	char buf[LOG_BUF_SIZE];
+	int r;
+
+	r = vsnprintf(buf, LOG_BUF_SIZE, fmt, ap);
+
+	if (r > LOG_BUF_SIZE)
+		r = LOG_BUF_SIZE;
+
+	if (trace_logfp) {
+		if (newline)
+			fprintf(trace_logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
+		else
+			fprintf(trace_logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
+		newline = buf[r - 1] == '\n';
+		fflush(trace_logfp);
+		return;
+	}
+
+	fprintf(fp, "%.*s", r, buf);
+}
+
+void plog(const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	__plog("", fmt, ap, stdout);
+	va_end(ap);
+	/* Make sure it gets to the screen, in case we crash afterward */
+	fflush(stdout);
+}
+
+void plog_error(const char *fmt, ...)
+{
+	va_list ap;
+	char *str = "";
+
+	va_start(ap, fmt);
+	__plog("Error: ", fmt, ap, stderr);
+	va_end(ap);
+	if (errno)
+		str = strerror(errno);
+	if (trace_logfp)
+		fprintf(trace_logfp, "\n%s\n", str);
+	else
+		fprintf(stderr, "\n%s\n", str);
+}
+
+/**
+ * trace_set_log_file - Set file for logging
+ * @logfile: Name of the log file
+ *
+ * Returns 0 on successful completion or -1 in case of error
+ */
+int trace_set_log_file(char *logfile)
+{
+	if (trace_logfp)
+		fclose(trace_logfp);
+	trace_logfp = fopen(logfile, "w");
+	if (!trace_logfp)
+		return -1;
+	return 0;
+}
+
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 9dcb833..7c7d4ce 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -34,8 +34,6 @@ static char *output_dir;
 static char *default_output_file = "trace";
 static char *output_file;
 
-static FILE *logfp;
-
 static int backlog = 5;
 
 static int do_daemon;
@@ -44,6 +42,13 @@ static int do_daemon;
 static struct tracecmd_msg_handle *stop_msg_handle;
 static bool done;
 
+#define pdie(fmt, ...)				\
+	do {					\
+		plog_error(fmt, ##__VA_ARGS__);	\
+		remove_pid_file();		\
+		exit(-1);			\
+	} while (0)
+
 #define  TEMP_FILE_STR "%s.%s:%s.cpu%d", output_file, host, port, cpu
 static char *get_temp_file(const char *host, const char *port, int cpu)
 {
@@ -114,43 +119,6 @@ static void finish(int sig)
 	done = true;
 }
 
-#define LOG_BUF_SIZE 1024
-static void __plog(const char *prefix, const char *fmt, va_list ap,
-		   FILE *fp)
-{
-	static int newline = 1;
-	char buf[LOG_BUF_SIZE];
-	int r;
-
-	r = vsnprintf(buf, LOG_BUF_SIZE, fmt, ap);
-
-	if (r > LOG_BUF_SIZE)
-		r = LOG_BUF_SIZE;
-
-	if (logfp) {
-		if (newline)
-			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
-		else
-			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
-		newline = buf[r - 1] == '\n';
-		fflush(logfp);
-		return;
-	}
-
-	fprintf(fp, "%.*s", r, buf);
-}
-
-void plog(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	__plog("", fmt, ap, stdout);
-	va_end(ap);
-	/* Make sure it gets to the screen, in case we crash afterward */
-	fflush(stdout);
-}
-
 static void make_pid_name(int mode, char *buf)
 {
 	snprintf(buf, PATH_MAX, VAR_RUN_DIR "/trace-cmd-net.pid");
@@ -169,26 +137,6 @@ static void remove_pid_file(void)
 	unlink(buf);
 }
 
-void pdie(const char *fmt, ...)
-{
-	va_list ap;
-	char *str = "";
-
-	va_start(ap, fmt);
-	__plog("Error: ", fmt, ap, stderr);
-	va_end(ap);
-	if (errno)
-		str = strerror(errno);
-	if (logfp)
-		fprintf(logfp, "\n%s\n", str);
-	else
-		fprintf(stderr, "\n%s\n", str);
-
-	remove_pid_file();
-
-	exit(-1);
-}
-
 static int process_udp_child(int sfd, const char *host, const char *port,
 			     int cpu, int page_size, int use_tcp)
 {
@@ -1030,8 +978,7 @@ void trace_listen(int argc, char **argv)
 
 	if (logfile) {
 		/* set the writes to a logfile instead */
-		logfp = fopen(logfile, "w");
-		if (!logfp)
+		if (trace_set_log_file(logfile) < 0)
 			die("creating log file %s", logfile);
 	}
 
-- 
2.21.0

