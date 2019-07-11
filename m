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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABEDC74A35
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1C8C216B7
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="klCX++9K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbfGKNDR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:17 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38614 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbfGKNDR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:17 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so6220528wrr.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bd0kJQcTR8CLMVmieACHDzqATfr+PZg/kQiOl4SlIfQ=;
        b=klCX++9KqIyoaEnyJ1DyxdsTYD5yZYApbtrUkswuNAiCYPfifkFZ3GTw2L4aIZSPXg
         /DNuAtFvrqtglTOpybuB3KxKNz9U8ZtpL4AKxuJKfGz53aHzpwBb5TYhDVKHwIwATBim
         WDdOnJObnvM9XcWLheAgeJhHcPHG1uO33ZTmm7DzDAogn+jViVKgmIiz0IU560Jk92w2
         kGAHliI3eBlIj+OQJADohMHHP7cVPz9fqi6FTrS1GFO3oW2dP/13dlgALxpKic6WRdJP
         vsn6ICiEsxVlwG6vri4ccq7bg8gRnkrFLlVrln0TvJJq8QtYuqVWmvCLohtI48RNiRGo
         8E3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bd0kJQcTR8CLMVmieACHDzqATfr+PZg/kQiOl4SlIfQ=;
        b=nK4186JEG2RdLlcB9PTDDOIN36akUpcLOCxJvwF2Y+V91aRd64SJYzhf1QpXceMq+l
         2+NraTtxkrWpl1Vb5eBsskEVrgagbuM6kCVHh6OVNHiIXunvLj12YbwqUZUqi9qhXtIK
         hGoqGpeQJxKnz1WX1xKityG+KzeQPjxs7FoAePixn0s3M36gHO/M1MUBXk85+gUksRmH
         e8SPLz5hWwlkd7RU8dgd0ZFB0zfdzK0+So2llvCGYCPT7wH6Ll7o6j700NRzWmVX/fFz
         s6FXFXwlSKMuJevUhAwHQs564cnlcflD/0PfcChgt11K9CKXcwhR3lH756viSysRrCCR
         wjHw==
X-Gm-Message-State: APjAAAWP1KOW3/QPS03+hX7K44vm951FIKtjStAvYSGQ3ncj3Ip4Tk4g
        yEkEPBnS9JkMXdH+/GU1T9pAkYSM
X-Google-Smtp-Source: APXvYqzlKhelJ9leQKOc7LnPbfb/7txnUdQ8Wb8Sc315aNXDbLPq17stdvASSyZQbomkJyaZoqz1Bw==
X-Received: by 2002:a5d:51c8:: with SMTP id n8mr4963130wrv.46.1562850194847;
        Thu, 11 Jul 2019 06:03:14 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:14 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/7] trace-cmd: Move trace-cmd global variable "debug" to libtracecmd
Date:   Thu, 11 Jul 2019 16:03:04 +0300
Message-Id: <20190711130307.25041-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190711130307.25041-1-tz.stoyanov@gmail.com>
References: <20190711130307.25041-1-tz.stoyanov@gmail.com>
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
index 8c8f87c..2f524b6 100644
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
index 8fbafa6..1dc2383 100644
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
index 9132582..9dcb833 100644
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
index e647117..8e2c83a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4902,7 +4902,7 @@ static void parse_record_options(int argc,
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

