Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A7DC3B196
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AF0F246D0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IWmvraqb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfLMPat (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:49 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35003 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbfLMPat (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:49 -0500
Received: by mail-lj1-f196.google.com with SMTP id j6so3111179lja.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J3RButzN5+ghSI5vJGJ/ISRyjUqksFMjFH1+tsXb/qo=;
        b=IWmvraqbRf18p23sDho5fSebKE3atbuqK614vxO4GiW9VKzVqT2Av3CA9j5cB7Wa8W
         9dcFdOlSW139xn3NxyFw3/KD1+29CJWGAffE9+GXTNldj6+Ib6KvDpMCUdVMmYblpEGS
         SMbKrxhBZLCpMwlzbgxBX/2lSY5Ac/X/LcHNcXoVL66Z2GtAe144CpDq4U0sI+f7S3WT
         XnzMLEOOe28KgbyyP+nALrz1ZT9fHXBXaad4hSTN4W6bXzK0zl+XuGdPnQVq50kqq4Qu
         eO5f5SqCvaalBUuJKO+18qkfuqJHAkrQNKHLgB4UrnLzlrub4bV20d2jBkdlgOCa4PTe
         /pYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J3RButzN5+ghSI5vJGJ/ISRyjUqksFMjFH1+tsXb/qo=;
        b=cRrvYUxxmkio6a/zYUQgpsaV3UVCrSv/fTIUYUO6r9wAJbZN1sOXMJ264NewihrYdJ
         m4eYtF24Cegy8K5r1NsPtl7fE2BWdhFcgRqxHPMo+9drs0O6jEHCuumrQguezbbpuQ1H
         T3u7lykLASyFGJSzskUUi3UDGI56ZPqw+5AckAgZCzc1JNNlz4r0BuNk/elUenKDKobZ
         P3oDfLrfwVuIYgXiLjq5FT+XwtmdZg+jpoWMp1r/Uvg1r3TZxMAk7osaq7J/uHdh2rfh
         vfTg2RHT53m+hnvbdGgGoA6PyIV9MVbSDdVvEMZNExUdUBBhTyVuu9rZOgKZ1oTpEnhC
         6VQA==
X-Gm-Message-State: APjAAAV2UJQL0Ri5ET2rqZwP78b0gtFxT+siJKxPZgo58AgTzlztlVQ6
        JFCONKaPv0YTze4mNCMvZCirgAZ5Djg=
X-Google-Smtp-Source: APXvYqwg3GA4UY5SQDBbFXFGnytv7UhvwfJvTAJoWtwi62GBzTY3sE2t41FGD8E/N569kuwrXKR+vQ==
X-Received: by 2002:a2e:9716:: with SMTP id r22mr10246468lji.224.1576251045978;
        Fri, 13 Dec 2019 07:30:45 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:45 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 11/18] trace-cmd: Exchange tracing IDs between host and guest
Date:   Fri, 13 Dec 2019 17:30:22 +0200
Message-Id: <20191213153029.133570-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-msg.c      | 31 +++++++++++++++++++++++--------
 tracecmd/include/trace-local.h |  4 +++-
 tracecmd/trace-agent.c         | 12 +++++++-----
 tracecmd/trace-record.c        | 12 +++++++++---
 5 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index 6cc2913..23415e4 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -353,16 +353,20 @@ bool tracecmd_msg_done(struct tracecmd_msg_handle *msg_handle);
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
 /* --- ftrace instances --- */
 
 struct tracecmd_instance;
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 9c8a690..a34297f 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -63,12 +63,14 @@ struct tracecmd_msg_rinit {
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
@@ -811,7 +813,8 @@ int tracecmd_msg_wait_close_resp(struct tracecmd_msg_handle *msg_handle)
 	return tracecmd_msg_wait_for_cmd(msg_handle, MSG_CLOSE_RESP);
 }
 
-static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool use_fifos)
+static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv,
+			  bool use_fifos, unsigned long long trace_id)
 {
 	size_t args_size = 0;
 	char *p;
@@ -823,6 +826,7 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
 	msg->hdr.size = htonl(ntohl(msg->hdr.size) + args_size);
 	msg->trace_req.flags = use_fifos ? htonl(MSG_TRACE_USE_FIFOS) : htonl(0);
 	msg->trace_req.argc = htonl(argc);
+	msg->trace_req.trace_id = htonll(trace_id);
 	msg->buf = calloc(args_size, 1);
 	if (!msg->buf)
 		return -ENOMEM;
@@ -835,13 +839,15 @@ static int make_trace_req(struct tracecmd_msg *msg, int argc, char **argv, bool
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
+	ret = make_trace_req(&msg, argc, argv,
+			     use_fifos, trace_id);
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
@@ -901,6 +908,7 @@ int tracecmd_msg_recv_trace_req(struct tracecmd_msg_handle *msg_handle,
 	*argc = nr_args;
 	*argv = args;
 	*use_fifos = ntohl(msg.trace_req.flags) & MSG_TRACE_USE_FIFOS;
+	*trace_id = ntohll(msg.trace_req.trace_id);
 
 	/*
 	 * On success we're passing msg.buf to the caller through argv[0] so we
@@ -921,7 +929,8 @@ out:
 }
 
 static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
-			   unsigned int *ports, bool use_fifos)
+			   unsigned int *ports, bool use_fifos,
+			   unsigned long long trace_id)
 {
 	int data_size;
 
@@ -935,19 +944,22 @@ static int make_trace_resp(struct tracecmd_msg *msg, int page_size, int nr_cpus,
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
 
@@ -956,13 +968,15 @@ int tracecmd_msg_send_trace_resp(struct tracecmd_msg_handle *msg_handle,
 
 int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 				 int *nr_cpus, int *page_size,
-				 unsigned int **ports, bool *use_fifos)
+				 unsigned int **ports, bool *use_fifos,
+				 unsigned long long *trace_id)
 {
 	struct tracecmd_msg msg;
 	char *p, *buf_end;
 	ssize_t buf_len;
 	int i, ret;
 
+	memset(&msg, 0, sizeof(msg));
 	ret = tracecmd_msg_recv(msg_handle->fd, &msg);
 	if (ret < 0)
 		return ret;
@@ -981,6 +995,7 @@ int tracecmd_msg_recv_trace_resp(struct tracecmd_msg_handle *msg_handle,
 	*use_fifos = ntohl(msg.trace_resp.flags) & MSG_TRACE_USE_FIFOS;
 	*nr_cpus = ntohl(msg.trace_resp.cpus);
 	*page_size = ntohl(msg.trace_resp.page_size);
+	*trace_id = ntohll(msg.trace_resp.trace_id);
 	*ports = calloc(*nr_cpus, sizeof(**ports));
 	if (!*ports) {
 		ret = -ENOMEM;
diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 6203e0d..90933cc 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -98,7 +98,9 @@ void trace_usage(int argc, char **argv);
 
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
-		       int argc, char **argv, bool use_fifos);
+		       int argc, char **argv,
+		       bool use_fifos,
+		       unsigned long long trace_id);
 
 struct hook_list;
 
diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
index 1c6e0a3..cc330b7 100644
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
 
@@ -153,13 +155,13 @@ static void agent_handle(int sd, int nr_cpus, int page_size)
 
 	if (!use_fifos)
 		make_vsocks(nr_cpus, fds, ports);
-
+	trace_id = tracecmd_generate_traceid();
 	ret = tracecmd_msg_send_trace_resp(msg_handle, nr_cpus, page_size,
-					   ports, use_fifos);
+					   ports, use_fifos, trace_id);
 	if (ret < 0)
 		die("Failed to send trace response");
-
-	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv, use_fifos);
+	trace_record_agent(msg_handle, nr_cpus, fds, argc, argv,
+			   use_fifos, trace_id);
 
 	free(argv[0]);
 	free(argv);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b65aeb2..4bd9b7a 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3505,12 +3505,16 @@ static void connect_to_agent(struct buffer_instance *instance)
 		die("Failed to allocate message handle");
 
 	ret = tracecmd_msg_send_trace_req(msg_handle, instance->argc,
-					  instance->argv, use_fifos);
+					  instance->argv, use_fifos,
+					  top_instance.trace_id);
+
 	if (ret < 0)
 		die("Failed to send trace request");
 
 	ret = tracecmd_msg_recv_trace_resp(msg_handle, &nr_cpus, &page_size,
-					   &ports, &use_fifos);
+					   &ports, &use_fifos,
+					   &instance->trace_id);
+
 	if (ret < 0)
 		die("Failed to receive trace response");
 
@@ -6116,7 +6120,8 @@ void trace_record(int argc, char **argv)
 int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 		       int cpus, int *fds,
 		       int argc, char **argv,
-		       bool use_fifos)
+		       bool use_fifos,
+		       unsigned long long trace_id)
 {
 	struct common_record_context ctx;
 	char **argv_plus;
@@ -6146,6 +6151,7 @@ int trace_record_agent(struct tracecmd_msg_handle *msg_handle,
 	ctx.instance->flags |= BUFFER_FL_AGENT;
 	ctx.instance->msg_handle = msg_handle;
 	msg_handle->version = V3_PROTOCOL;
+	top_instance.trace_id = trace_id;
 	record_trace(argc, argv, &ctx);
 
 	free(argv_plus);
-- 
2.23.0

