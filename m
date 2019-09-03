Return-Path: <SRS0=NxYB=W6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C078C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 388F723431
	for <linux-trace-devel@archiver.kernel.org>; Tue,  3 Sep 2019 13:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qMCaQjba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfICNew (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 3 Sep 2019 09:34:52 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:45422 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfICNev (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 3 Sep 2019 09:34:51 -0400
Received: by mail-wr1-f48.google.com with SMTP id q12so17484644wrj.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 03 Sep 2019 06:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPwam2csJrwR6+4W/GwkgtNQvtWoArv5NAaZJm/Jv80=;
        b=qMCaQjbaC8dg5bIoP2fH+r0LUTb7rSAxOeUoAiY0L6fcwOMXQVhT41P8nTwKI5eRvg
         j0sISZToE/hFrIX/fMUsIN5vVLuKHG/PkHoyLeR8Chg6b2IzZ1zABko6ibjodyUzKtoU
         biTaSA0+kchs0J9/lMGBk2W+l/o01uyW5mXQEwro+RRT4FCsLy9BZRJTP41mhki8Y+mt
         uuaNU3xHa3NykpxUFR/amI9eLnkvJ6OYElxRcbQ7976MpAT+itgxjuOoAXLvMLn1ASUf
         vnegT/mDe3A/kMLd3tUX0JvS1tA6zwjtghLMekJT0APN8OuSJ3BTDnzjX0SNPjAKMg7w
         rhng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPwam2csJrwR6+4W/GwkgtNQvtWoArv5NAaZJm/Jv80=;
        b=Nghr6GGUzDzl3TJKMxn/YH+cnyM2WvaOYanmYDFYoP35iJ4JB7ha/CWBBRf9xsgKXI
         hSEFf1SRiZ4/2pUTs0IXp1mYOD+owPC/oOxXiUt2SJu1BEBl3r0H3k5r3vXvtWrKujYX
         nVB1Iz8FKu6Xgb5HOuBuYFmt1BeK+AsywUhF5nfX5LPTpXgluj3n5LejoUJkEunfSXL7
         v546fB/5yl4wY85UttPFzofoCAtNfC9eChFre+YdJ967B7QBUEjA0lWGm/DxfMBcybGd
         iBNZkSKiduq/y2gQczsr5HLtyJFe5W344vNggFakRKFJVh0AF5CnroN/3edCtE0WS62z
         dNNA==
X-Gm-Message-State: APjAAAVmW4t4KZHCkZogSQ1rMHGCqGk6KTV5ys85Kcbz9DdQBYNDGYlu
        dMApj/VUARBLBfOTTaFNH3I=
X-Google-Smtp-Source: APXvYqxLmtDLO4s3xdSP1ouYkDuTYcXEget0h6RMYaFe9hEceam0E5NNtZUp5tqFcZAdnPaArSq+tg==
X-Received: by 2002:a05:6000:1c3:: with SMTP id t3mr1617411wrx.76.1567517688915;
        Tue, 03 Sep 2019 06:34:48 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r16sm33509833wrc.81.2019.09.03.06.34.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 06:34:48 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/4] trace-cmd: Move plog() function to libtracecmd.
Date:   Tue,  3 Sep 2019 16:34:43 +0300
Message-Id: <20190903133445.30486-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190903133445.30486-1-tz.stoyanov@gmail.com>
References: <20190903133445.30486-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

plog() function writes logs into a log file. It is used in
libtracecmd and its implementation should be there.
The function is moved from trace-cmd into the library and
renamed to tracecmd_plog(). Two additional APIs are implemented:
	int tracecmd_set_log_file(char *logfile); - use it to set
the log file.
	void tracecmd_plog_error(const char *fmt, ...); - use it to log
an error message into the file.

The plog() function is used also from pdie() in trace-cmd.
pdie() depends on trace-cmd context and cannot be moved to
the library. It is reimplemented as macros, in order to utilize
the new tracecmd_plog() library function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h |  4 ++
 include/trace-cmd/trace-msg.h |  3 --
 lib/trace-cmd/trace-msg.c     |  8 ++--
 lib/trace-cmd/trace-util.c    | 70 +++++++++++++++++++++++++++
 tracecmd/trace-listen.c       | 89 +++++++----------------------------
 tracecmd/trace-record.c       |  2 +-
 6 files changed, 96 insertions(+), 80 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index f44f7a4..de3183d 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -389,6 +389,10 @@ struct hook_list {
 struct hook_list *tracecmd_create_event_hook(const char *arg);
 void tracecmd_free_hooks(struct hook_list *hooks);
 
+void tracecmd_plog(const char *fmt, ...);
+void tracecmd_plog_error(const char *fmt, ...);
+int tracecmd_set_logfile(char *logfile);
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
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 92562c7..74c5254 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -318,7 +318,7 @@ static int tracecmd_msg_recv(int fd, struct tracecmd_msg *msg)
 
 	return 0;
 error:
-	plog("Receive an invalid message(size=%d)\n", size);
+	tracecmd_plog("Receive an invalid message(size=%d)\n", size);
 	return -ENOMSG;
 }
 
@@ -531,7 +531,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	}
 
 	cpus = ntohl(msg.tinit.cpus);
-	plog("cpus=%d\n", cpus);
+	tracecmd_plog("cpus=%d\n", cpus);
 	if (cpus < 0) {
 		ret = -EINVAL;
 		goto error;
@@ -540,7 +540,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 	msg_handle->cpu_count = cpus;
 
 	pagesize = ntohl(msg.tinit.page_size);
-	plog("pagesize=%d\n", pagesize);
+	tracecmd_plog("pagesize=%d\n", pagesize);
 	if (pagesize <= 0) {
 		ret = -EINVAL;
 		goto error;
@@ -570,7 +570,7 @@ int tracecmd_msg_initial_setting(struct tracecmd_msg_handle *msg_handle)
 
 		/* do we understand this option? */
 		if (!process_option(msg_handle, p))
-			plog("Cannot understand option '%s'\n", p);
+			tracecmd_plog("Cannot understand option '%s'\n", p);
 
 		p = strchr(p, '\0');
 	}
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index faff0b5..60bcb68 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -30,6 +30,8 @@ int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
 static bool tracecmd_debug;
 
+static FILE *logfp;
+
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
 	struct tep_plugin_option			*options;
@@ -1695,3 +1697,71 @@ void __weak *malloc_or_die(unsigned int size)
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
+	if (logfp) {
+		if (newline)
+			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
+		else
+			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
+		newline = buf[r - 1] == '\n';
+		fflush(logfp);
+		return;
+	}
+
+	fprintf(fp, "%.*s", r, buf);
+}
+
+void tracecmd_plog(const char *fmt, ...)
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
+void tracecmd_plog_error(const char *fmt, ...)
+{
+	va_list ap;
+	char *str = "";
+
+	va_start(ap, fmt);
+	__plog("Error: ", fmt, ap, stderr);
+	va_end(ap);
+	if (errno)
+		str = strerror(errno);
+	if (logfp)
+		fprintf(logfp, "\n%s\n", str);
+	else
+		fprintf(stderr, "\n%s\n", str);
+}
+
+/**
+ * tracecmd_set_logfile - Set file for logging
+ * @logfile: Name of the log file
+ *
+ * Returns 0 on successful completion or -1 in case of error
+ */
+int tracecmd_set_logfile(char *logfile)
+{
+	if (logfp)
+		fclose(logfp);
+	logfp = fopen(logfile, "w");
+	if (!logfp)
+		return -1;
+	return 0;
+}
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 9dcb833..233d661 100644
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
 
+#define pdie(fmt, ...)					\
+	do {						\
+		tracecmd_plog_error(fmt, ##__VA_ARGS__);\
+		remove_pid_file();			\
+		exit(-1);				\
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
@@ -369,15 +317,15 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 		if (memcmp(buf, V3_CPU, n) != 0) {
 			/* If it did not send a version, then bail */
 			if (memcmp(buf, "-1V", 3)) {
-				plog("Unknown string %s\n", buf);
+				tracecmd_plog("Unknown string %s\n", buf);
 				goto out;
 			}
 			/* Skip "-1" */
-			plog("Cannot handle the protocol %s\n", buf+2);
+			tracecmd_plog("Cannot handle the protocol %s\n", buf+2);
 
 			/* If it returned the same command as last time, bail! */
 			if (last_proto && strncmp(last_proto, buf, n) == 0) {
-				plog("Repeat of version %s sent\n", last_proto);
+				tracecmd_plog("Repeat of version %s sent\n", last_proto);
 				goto out;
 			}
 			free(last_proto);
@@ -410,7 +358,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 	} else {
 		/* The client is using the v1 protocol */
 
-		plog("cpus=%d\n", cpus);
+		tracecmd_plog("cpus=%d\n", cpus);
 		if (cpus < 0)
 			goto out;
 
@@ -424,7 +372,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 
 		pagesize = atoi(buf);
 
-		plog("pagesize=%d\n", pagesize);
+		tracecmd_plog("pagesize=%d\n", pagesize);
 		if (pagesize <= 0)
 			goto out;
 
@@ -473,7 +421,7 @@ static int communicate_with_client(struct tracecmd_msg_handle *msg_handle)
 	}
 
 	if (msg_handle->flags & TRACECMD_MSG_FL_USE_TCP)
-		plog("Using TCP for live connection\n");
+		tracecmd_plog("Using TCP for live connection\n");
 
 	ret = pagesize;
  out:
@@ -560,7 +508,7 @@ static int *create_all_readers(const char *node, const char *port,
 	if (msg_handle->version == V3_PROTOCOL) {
 		/* send set of port numbers to the client */
 		if (tracecmd_msg_send_port_array(msg_handle, port_array) < 0) {
-			plog("Failed sending port array\n");
+			tracecmd_plog("Failed sending port array\n");
 			goto out_free;
 		}
 	} else {
@@ -755,11 +703,9 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 			service, NI_MAXSERV, NI_NUMERICSERV);
 
 	if (s == 0)
-		plog("Connected with %s:%s\n",
-		       host, service);
+		tracecmd_plog("Connected with %s:%s\n", host, service);
 	else {
-		plog("Error with getnameinfo: %s\n",
-		       gai_strerror(s));
+		tracecmd_plog("Error with getnameinfo: %s\n", gai_strerror(s));
 		close(cfd);
 		tracecmd_msg_handle_close(msg_handle);
 		return -1;
@@ -1030,8 +976,7 @@ void trace_listen(int argc, char **argv)
 
 	if (logfile) {
 		/* set the writes to a logfile instead */
-		logfp = fopen(logfile, "w");
-		if (!logfp)
+		if (tracecmd_set_logfile(logfile) < 0)
 			die("creating log file %s", logfile);
 	}
 
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 61457c8..96d2c1a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3055,7 +3055,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
 	if (n < 0 || !buf[0]) {
 		/* the server uses the v1 protocol, so we'll use it */
 		msg_handle->version = V1_PROTOCOL;
-		plog("Use the v1 protocol\n");
+		tracecmd_plog("Use the v1 protocol\n");
 	} else {
 		if (memcmp(buf, "V3", n) != 0)
 			die("Cannot handle the protocol %s", buf);
-- 
2.21.0

