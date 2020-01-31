Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF29C33CB2
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4135520CC7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLnbdiW4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAaMLb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:31 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44419 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728484AbgAaMLa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:30 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so6817114ljj.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DXr2BEPFxtHwGmE/teCGGAXRKazu/p8/9z12yJ1uN6A=;
        b=hLnbdiW4gVNEy2WOuWRFyE/D/VeXTD4bIWpVXe+KgONJm8IYxdCKHhlFyrbVAlzJ96
         Pe62gZYA0KAAQG+G4DvSXiVTkWtvZcGsh2V2sD/agi56lCS5iCHqz60xT7KcYMBXrckn
         scdfsD5N4C/z3zKy1UjKAq1Bs+UuF2pwWNe7D3O0W7aZpyxkMHUH92CepF2fwsxR9Ghz
         iKy4KzGHOJj0tuqO56cPcAAnB6FGM92FeKLhPHgkRndde3gO6gm9o1yEG9OZHOlIYUSX
         8y67qqVmLljHiLwLw0eZZiSYcSGAY58+52ouNZviodADxzUuGpsmenDATolNw2cWQyV9
         NT4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DXr2BEPFxtHwGmE/teCGGAXRKazu/p8/9z12yJ1uN6A=;
        b=V168+t7a6i9LOjbCsXQJHAv3+/5bG3Xbk7hFkLgYwd+Lg9oB3QWo0QDs/SqKMdpREj
         EbfivJ1l2p0ya5ol3VAwUsI++IICmNmFGoOAzajFruIS17xNFRNZfRMx6t9p73p22XYs
         0T4iuRdoK9Efk/XesKJjoP8G9ZrTYb8xir7L+DkJZ2xz6H7IeOPCBKBv/6Q+ORIcMA8v
         GIJaXFo79Ry+gRRs3Im3sWx9u4Cc3pfSpv5dLoDB218y2hAiLqNQxEwHMGs3b56ODKlx
         DgKNpnK0JIlYqcKdXZ+RmMvtjiHTi1HPdO3UBKPyVScW0gBslgSTQSjDkY0Oc6QUXgpT
         MfJQ==
X-Gm-Message-State: APjAAAUOJKFi+eJodOoPqLhcSzNYsOoKf5WdyWB6t0zQuEPIq+sYLrmS
        d616MzXvqsWYrYSLzIWmR8c=
X-Google-Smtp-Source: APXvYqx+jYENWf31I31RZ9K4ihYUm/uVwKGP2xeGayeCcoWjL9r75BugPfkpqFW40Rm5SrayQsS71w==
X-Received: by 2002:a2e:8152:: with SMTP id t18mr5806930ljg.255.1580472686338;
        Fri, 31 Jan 2020 04:11:26 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 08/15] trace-cmd: Exchange tracing IDs between host and guest
Date:   Fri, 31 Jan 2020 14:11:04 +0200
Message-Id: <20200131121111.130355-9-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Extend the trace request and trace reply messages, to include also
the IDs of host and guest tracing sessions. Those IDs are used to
unambiguously match the tracing sessions, when reading trace.dat files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/trace-cmd/trace-cmd.h  | 12 ++++++++----
 lib/trace-cmd/trace-msg.c      | 31 ++++++++++++++++++++++---------
 tracecmd/include/trace-local.h |  3 ++-
 tracecmd/trace-agent.c         | 10 +++++++---
 tracecmd/trace-record.c        | 10 +++++++---
 5 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6075a37..55abd48 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -370,16 +370,20 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
 void tracecmd_msg_set_done(struct tracecmd_msg_handle *msg_handle);
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv, bool use_fifos);
+				int argc, char **argv, bool use_fifos,
+				unsigned long long trace_id);
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos);
+				int *argc, char ***argv, bool *use_fifos,
+				unsigned long long *trace_id);
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports, bool use_fifos);
+				 unsigned int *ports, bool use_fifos,
+				 unsigned long long trace_id);
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports, bool *use_fifos);
+				 unsigned int **ports, bool *use_fifos,
+				 unsigned long long *trace_id);
 
 /* --- Plugin handling --- */
 extern struct tep_plugin_option trace_ftrace_options[];
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 85a2bae..d6a68ac 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -23,6 +23,7 @@
 #include <linux/types.h>
 
 #include "trace-write-local.h"
+#include "trace-cmd-local.h"
 #include "trace-local.h"
 #include "trace-msg.h"
 
@@ -63,12 +64,14 @@ struct tracecmd_msg_rinit {
 struct tracecmd_msg_trace_req {
 	be32 flags;
 	be32 argc;
+	u64 trace_id;
 } __attribute__((packed));
 
 struct tracecmd_msg_trace_resp {
 	be32 flags;
 	be32 cpus;
 	be32 page_size;
+	u64 trace_id;
 } __attribute__((packed));
 
 struct tracecmd_msg_header {
@@ -811,7 +814,8 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
+			  bool use_fifos, unsigned long long trace_id)
 {
 	size_t args_size = 0;
 	char *p;
@@ -823,6 +827,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
 	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_req.argc = htonl(argc);
+	msg->trace_req.trace_id = htonll(trace_id);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
 		return -ENOMEM;
@@ -835,13 +840,14 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
 }
 
 int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int argc, char **argv, bool use_fifos)
+				int argc, char **argv, bool use_fifos,
+				unsigned long long trace_id)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_REQ, &msg);
-	ret = make_trace_req(&msg, argc, argv, use_fifos);
+	ret = make_trace_req(&msg, argc, argv, use_fifos, trace_id);
 	if (ret < 0)
 		return ret;
 
@@ -854,7 +860,8 @@ int tracecmd_msg_send_trace_req(struct tracecmd_msg_handle *msg_handle,
   *     free(argv);
   */
 int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
-				int *argc, char ***argv, bool *use_fifos)
+				int *argc, char ***argv, bool *use_fifos,
+				unsigned long long *trace_id)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end, **args;
@@ -901,7 +908,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	*argc = nr_args;
 	*argv = args;
 	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
-
+	*trace_id = ntohll(msg.trace_req.trace_id);
 	/*
 	 * On success we're passing msg.buf to the caller through argv[0] so we
 	 * reset it here before calling msg_free().
@@ -921,7 +928,8 @@ out:
 }
 
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
-			   unsigned int *ports, bool use_fifos)
+			   unsigned int *ports, bool use_fifos,
+			   unsigned long long trace_id)
 {
 	int data_size;
 
@@ -935,19 +943,22 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
 	msg->trace_resp.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_resp.cpus = htonl(nr_cpus);
 	msg->trace_resp.page_size = htonl(page_size);
+	msg->trace_resp.trace_id = htonll(trace_id);
 
 	return 0;
 }
 
 int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int nr_cpus, int page_size,
-				 unsigned int *ports, bool use_fifos)
+				 unsigned int *ports, bool use_fifos,
+				 unsigned long long trace_id)
 {
 	struct tracecmd_msg msg;
 	int ret;
 
 	tracecmd_msg_init(MSG_TRACE_RESP, &msg);
-	ret = make_trace_resp(&msg, page_size, nr_cpus, ports, use_fifos);
+	ret = make_trace_resp(&msg, page_size, nr_cpus, ports,
+			      use_fifos, trace_id);
 	if (ret < 0)
 		return ret;
 
@@ -956,7 +967,8 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports, bool *use_fifos)
+				 unsigned int **ports, bool *use_fifos,
+				 unsigned long long *trace_id)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end;
@@ -981,6 +993,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
+	*trace_id = ntohll(msg.trace_resp.trace_id);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
 	if (!*ports) {
 		ret = -ENOMEM;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 6fe22bb..4f2b554 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -101,7 +101,8 @@ void trace_dump(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv, bool use_fifos);
+		       int argc, char **argv, bool use_fifos,
+		       unsigned long long trace_id);
 
 struct hook_list;
 
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 1c6e0a3..52d2719 100644
--- a/tracecmd/trace-agent.c
+++ b/tracecmd/trace-agent.c
@@ -128,6 +128,7 @@ cleanup:
 static void agent_handle(int sd, int nr_cpus, int page_size)
 {
 	struct tracecmd_msg_handle *msg_handle;
+	unsigned long long trace_id;
 	unsigned int *ports;
 	char **argv = NULL;
 	int argc = 0;
@@ -144,7 +145,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!msg_handle)
 		die("Failed to allocate message handle");
 
-	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv, &use_fifos);
+	ret = tracecmd_msg_recv_trace_req(msg_handle, &argc, &argv,
+					  &use_fifos, &trace_id);
 	if (ret < 0)
 		die("Failed to receive trace request");
 
@@ -154,12 +156,14 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
 
+	trace_id = tracecmd_generate_traceid();
 	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
-					   ports, use_fifos);
+					   ports, use_fifos, trace_id);
 	if (ret < 0)
 		die("Failed to send trace response");
 
-	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos);
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
+			   use_fifos, trace_id);
 
 	free(argv[0]);
 	free(argv);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b6e55ee..90026d9 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3663,12 +3663,14 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to allocate message handle");
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
-					  instance->argv, use_fifos);
+					  instance->argv, use_fifos,
+					  top_instance.trace_id);
 	if (ret < 0)
 		die("Failed to send trace request");
 
 	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
-					   &ports, &use_fifos);
+					   &ports, &use_fifos,
+					   &instance->trace_id);
 	if (ret < 0)
 		die("Failed to receive trace response");
 
@@ -6214,7 +6216,8 @@ void trace_record(int argc, char **argv)
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
-		       bool use_fifos)
+		       bool use_fifos,
+		       unsigned long long trace_id)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -6244,6 +6247,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
+	top_instance.trace_id = trace_id;
 	record_trace(argc, argv, &ctx);
 
 	free(argv_plus);
-- 
2.24.1

