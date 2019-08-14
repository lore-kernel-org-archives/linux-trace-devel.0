Return-Path: <SRS0=RHP/=WK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A27C41517
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B2B0216F4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 14 Aug 2019 08:47:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RySAleaE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfHNIr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 04:47:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43429 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfHNIrY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 04:47:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id y8so4352733wrn.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 14 Aug 2019 01:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ATHkTl64dc+PwT9K6GwGHhzgZwXlEQJYJ3ZCQRQ0c4c=;
        b=RySAleaE9dFDw6rM0dQyzsE9o1JISoR3Pk3HW9ecEkzWmujAiA8MeJycOSgsNrZ/3m
         eUA+4pNUedTh3Bmgf+xD++GEBn9eSAQI1Bk0VFGWkMeZ91NoGzWlUAFaejJytkdYp2Zb
         805wImL8474Mu+asSDrgIjfqXSHZkKWEl/mcQBGikYNxDfsvyIHrJxTnGuj7LCp3WAlk
         1kiv2C8jbWrIqaayHOkhInz9kvPQrRhM7NahcXXjNADQ0MIcs4OlGE9VtL6Ug32qB4lZ
         HmgDd8eN4ePkAJOEZuwpcgmku2XVRFQ4W6TuDqNNhbCnQYPGgl8WeZMyeiQFQKH2OGwc
         3jnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ATHkTl64dc+PwT9K6GwGHhzgZwXlEQJYJ3ZCQRQ0c4c=;
        b=pQsf0Z6nm0LUdNwkszS0M9vziItvKQ3gEbT/4iUgDVh2FWQf/hRwHkMSx6a8+XZnYM
         2HSugkhhaTEDnlrr6esNLinV7lGKoJNJyW4ht6tq+7Kxg77Stf8T1RfzpJr+BxakdzGj
         qRhW9j20MBMlZ2pxWlBijCGaDpl+XS8hJWXrGZ1PwG8rzjPfjfqXkNTWI91QaBmrhsGG
         2mzVHnw2bkKQN3p38Efvap/tUbegUKtXqtoLWVmTw5lNiBUhqPgmE3cGs2Q2XiWhlonZ
         2Ltk58PNWzukHmvy/C55wR3EwM8gHb+TCXA6F4m4/WPFHGMCkOQ3be0Lox+6ZfLSDZP6
         EMZQ==
X-Gm-Message-State: APjAAAVti9WTuhmmBpjIJCCC05r+9LaXWZhpbHTICXTsC9kk3jgBIDFQ
        v5zqd2/zR7CRZx2Py0dMtWU=
X-Google-Smtp-Source: APXvYqy+Sci8USWc9yVqHOKLwsskcDKSkFS4X7KDEckbPXa1Xpsw/B7KxL4ByhHcTyMdmd09KxNAeA==
X-Received: by 2002:a5d:6b84:: with SMTP id n4mr42589226wrx.118.1565772441413;
        Wed, 14 Aug 2019 01:47:21 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c19sm2897481wml.13.2019.08.14.01.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2019 01:47:20 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/8] trace-cmd: Move trace-cmd global variable "debug" to libtracecmd
Date:   Wed, 14 Aug 2019 11:47:05 +0300
Message-Id: <20190814084712.28188-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190814084712.28188-1-tz.stoyanov@gmail.com>
References: <20190814084712.28188-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A trace-cmd global variable "debug" is used from libtracecmd and
should be defined there. A new library APIs are implemented to
access it:
 void tracecmd_set_debug(bool debug);
 bool tracecmd_get_debug(void);

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  |  3 +++
 lib/trace-cmd/trace-msg.c      |  4 ++--
 lib/trace-cmd/trace-util.c     | 21 +++++++++++++++++++++
 tracecmd/include/trace-local.h |  2 --
 tracecmd/trace-cmd.c           |  2 --
 tracecmd/trace-list.c          |  2 +-
 tracecmd/trace-listen.c        |  8 ++++----
 tracecmd/trace-read.c          |  8 ++++----
 tracecmd/trace-record.c        |  2 +-
 9 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 5ce8fb3..b96de04 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -51,6 +51,9 @@ void free_record(struct tep_record *record);
 
 void tracecmd_set_quiet(int quiet);
 int tracecmd_get_quiet(void);
+void tracecmd_set_debug(bool debug);
+bool tracecmd_get_debug(void);
+
 
 struct tracecmd_input;
 struct tracecmd_output;
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index e2dd188..92562c7 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -32,7 +32,7 @@ static inline void dprint(const char *fmt, ...)
 {
 	va_list ap;
 
-	if (!debug)
+	if (!tracecmd_get_debug())
 		return;
 
 	va_start(ap, fmt);
@@ -351,7 +351,7 @@ static int tracecmd_msg_recv_wait(int fd, struct tracecmd_msg *msg)
 
 	pfd.fd = fd;
 	pfd.events = POLLIN;
-	ret = poll(&pfd, 1, debug ? -1 : msg_wait_to);
+	ret = poll(&pfd, 1, tracecmd_get_debug() ? -1 : msg_wait_to);
 	if (ret < 0)
 		return -errno;
 	else if (ret == 0)
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 26b9a18..b5ce84f 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -29,6 +29,7 @@
 int tracecmd_disable_sys_plugins;
 int tracecmd_disable_plugins;
 static int tracecmd_quiet;
+static bool tracecmd_debug;
 
 static struct registered_plugin_options {
 	struct registered_plugin_options	*next;
@@ -117,6 +118,26 @@ int tracecmd_get_quiet(void)
 	return tracecmd_quiet;
 }
 
+/**
+ * tracecmd_set_quiet - Set if to print output to the screen
+ * @quiet: If non zero, print no output to the screen
+ *
+ */
+void tracecmd_set_debug(bool debug)
+{
+	tracecmd_debug = debug;
+}
+
+/**
+ * tracecmd_get_quiet - Get if to print output to the screen
+ * Returns non zero, if no output to the screen should be printed
+ *
+ */
+bool tracecmd_get_debug(void)
+{
+	return tracecmd_debug;
+}
+
 void trace_util_free_plugin_options_list(char **list)
 {
 	tracecmd_free_list(list);
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 23a3a29..e2d5506 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -12,8 +12,6 @@
 #include "trace-cmd.h"
 #include "event-utils.h"
 
-extern int debug;
-
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
 
diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 5283ba7..30691b6 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -16,8 +16,6 @@
 int silence_warnings;
 int show_status;
 
-int debug;
-
 void warning(const char *fmt, ...)
 {
 	va_list ap;
diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index 00c6073..832540e 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -427,7 +427,7 @@ void trace_list(int argc, char **argv)
 				break;
 			case '-':
 				if (strcmp(argv[i], "--debug") == 0) {
-					debug = true;
+					tracecmd_set_debug(true);
 					break;
 				}
 				fprintf(stderr, "list: invalid option -- '%s'\n",
diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 3106022..3cbee67 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -717,7 +717,7 @@ static int do_fork(int cfd)
 	pid_t pid;
 
 	/* in debug mode, we do not fork off children */
-	if (debug)
+	if (tracecmd_get_debug())
 		return 0;
 
 	pid = fork();
@@ -769,7 +769,7 @@ static int do_connection(int cfd, struct sockaddr_storage *peer_addr,
 
 	tracecmd_msg_handle_close(msg_handle);
 
-	if (!debug)
+	if (!tracecmd_get_debug())
 		exit(0);
 
 	return 0;
@@ -910,7 +910,7 @@ static void do_listen(char *port)
 	struct addrinfo *result, *rp;
 	int sfd, s;
 
-	if (!debug)
+	if (!tracecmd_get_debug())
 		signal_setup(SIGCHLD, sigstub);
 
 	make_pid_file();
@@ -1009,7 +1009,7 @@ void trace_listen(int argc, char **argv)
 			daemon = 1;
 			break;
 		case OPT_debug:
-			debug = 1;
+			tracecmd_set_debug(true);
 			break;
 		default:
 			usage(argv);
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index d22c723..12b8b3d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -782,10 +782,10 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 				 cpu, record->missed_events);
 	else if (record->missed_events < 0)
 		trace_seq_printf(&s, "CPU:%d [EVENTS DROPPED]\n", cpu);
-	if (buffer_breaks || debug) {
+	if (buffer_breaks || tracecmd_get_debug()) {
 		if (tracecmd_record_at_buffer_start(handle, record)) {
 			trace_seq_printf(&s, "CPU:%d [SUBBUFFER START]", cpu);
-			if (debug)
+			if (tracecmd_get_debug())
 				trace_seq_printf(&s, " [%lld:0x%llx]",
 						 tracecmd_page_ts(handle, record),
 						 record->offset & ~(page_size - 1));
@@ -816,7 +816,7 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 		tep_print_event(pevent, &s, record, use_trace_clock);
 	if (s.len && *(s.buffer + s.len - 1) == '\n')
 		s.len--;
-	if (debug) {
+	if (tracecmd_get_debug()) {
 		struct kbuffer *kbuf;
 		struct kbuffer_raw_info info;
 		void *page;
@@ -1616,7 +1616,7 @@ void trace_report (int argc, char **argv)
 			break;
 		case OPT_debug:
 			buffer_breaks = 1;
-			debug = 1;
+			tracecmd_set_debug(true);
 			break;
 		case OPT_profile:
 			profile = 1;
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b25b659..32793b3 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5143,7 +5143,7 @@ static void parse_record_options(int argc,
 			no_filter = true;
 			break;
 		case OPT_debug:
-			debug = 1;
+			tracecmd_set_debug(true);
 			break;
 		case OPT_module:
 			if (ctx->instance->filter_mod)
-- 
2.21.0

