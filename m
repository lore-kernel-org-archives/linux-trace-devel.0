Return-Path: <SRS0=fS1d=PY=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB42C43387
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C7D720866
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Jan 2019 19:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfAPTSp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Jan 2019 14:18:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:32968 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbfAPTSp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Jan 2019 14:18:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so8323533wrr.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Jan 2019 11:18:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4lCc6zWkyH26fz6CO1eDHb3FsFEv6DWPvfULoZ51UU8=;
        b=ZKNgP8g4IzitpOvk6Rpt5LjDYGwXqmpeeEgV53rpYL15P+Rp8Pq0/6US58MsH85u+P
         z93S0ExDPUX9IRXyegw/Vcgu0OLU7pIzLJZqZ9xBNZBYVQMa0Mv3q+l4FnZh6Tu6Zc7D
         nFo4oxEXrtIuAIpyv7a2CO0GuinDmWDoiR03ffRZjDxXlxXtSpap/JwvSzfJ5ddy9Zlz
         m1scdG4LobvJtdXMNxIyQeFtar8Jx6Ob7ZDDxw7WRg6I0ZFwW4X9inGeJ2KcpSeddb8R
         mFujOwL3Nm0x+684Fb0JinqmKYvHn7kmFjZ4p+mSdvt1iU33MzvkJKuge+hm6KO0dNwm
         77NQ==
X-Gm-Message-State: AJcUukfAmEIRB9+YQ0iPUuwEOYrfBijWdaH/c4XwWxxwVLnEVwK8Umrm
        uAgvBq0ZnPrZI45ERsFjMhY=
X-Google-Smtp-Source: ALg8bN7f2BrEeq8bGfuDDMzicv+9bOvER9o6JbzME53ff6QLYGKNItAJU5aZQcFG+w7hNDcO04dw3A==
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr9200610wrm.218.1547666322760;
        Wed, 16 Jan 2019 11:18:42 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm98393345wrx.50.2019.01.16.11.18.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Jan 2019 11:18:41 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/7] trace-cmd: Added new option in trace.dat file for negative time offsets
Date:   Wed, 16 Jan 2019 21:18:33 +0200
Message-Id: <20190116191838.32127-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190116191838.32127-1-tstoyanov@vmware.com>
References: <20190116191838.32127-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When synchronizing timestamps between different machines, there are cases
when the time offset is negative. A new option, TRACECMD_OPTION_OFFSET_N,
is added in trace.dat file for such use cases. The format is the same as
TRACECMD_OPTION_OFFSET, but the value is interpreted as negative integer.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 include/trace-cmd/trace-cmd.h |   1 +
 lib/trace-cmd/trace-input.c   |   7 +-
 tracecmd/trace-record.c       | 123 +++++++++++++++++-----------------
 3 files changed, 70 insertions(+), 61 deletions(-)

diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
index c79fc63..d0bddfc 100644
--- a/include/trace-cmd/trace-cmd.h
+++ b/include/trace-cmd/trace-cmd.h
@@ -82,6 +82,7 @@ enum {
 	TRACECMD_OPTION_HOOK,
 	TRACECMD_OPTION_OFFSET,
 	TRACECMD_OPTION_CPUCOUNT,
+	TRACECMD_OPTION_OFFSET_N,
 };
 
 enum {
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b628570..de15d4b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -2151,6 +2151,7 @@ static int handle_options(struct tracecmd_input *handle)
 			handle->ts_offset += offset;
 			break;
 		case TRACECMD_OPTION_OFFSET:
+		case TRACECMD_OPTION_OFFSET_N:
 			/*
 			 * Similar to date option, but just adds an
 			 * offset to the timestamp.
@@ -2158,7 +2159,11 @@ static int handle_options(struct tracecmd_input *handle)
 			if (handle->flags & TRACECMD_FL_IGNORE_DATE)
 				break;
 			offset = strtoll(buf, NULL, 0);
-			handle->ts_offset += offset;
+			if (option == TRACECMD_OPTION_OFFSET_N) {
+				if (handle->ts_offset > offset)
+					handle->ts_offset -= offset;
+			} else
+				handle->ts_offset += offset;
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index cd80462..f7349eb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -201,6 +201,13 @@ enum trace_cmd {
 	CMD_record_agent,
 };
 
+enum {
+	DATA_FL_NONE		= 0,
+	DATA_FL_DATE		= 1,
+	DATA_FL_OFFSET		= 2,
+	DATA_FL_OFFSET_N	= 4,
+};
+
 struct common_record_context {
 	enum trace_cmd curr_cmd;
 	struct buffer_instance *instance;
@@ -3230,7 +3237,62 @@ again:
 	return msg_handle;
 }
 
-static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx);
+static void add_option_hooks(struct tracecmd_output *handle)
+{
+	struct hook_list *hook;
+	int len;
+
+	for (hook = hooks; hook; hook = hook->next) {
+		len = strlen(hook->hook);
+		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
+				    len + 1, hook->hook);
+	}
+}
+
+static void add_uname(struct tracecmd_output *handle)
+{
+	struct utsname buf;
+	char *str;
+	int len;
+	int ret;
+
+	ret = uname(&buf);
+	/* if this fails for some reason, just ignore it */
+	if (ret < 0)
+		return;
+
+	len = strlen(buf.sysname) + strlen(buf.nodename) +
+		strlen(buf.release) + strlen(buf.machine) + 4;
+	str = malloc(len);
+	if (!str)
+		return;
+	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
+	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
+	free(str);
+}
+
+static void add_options(struct tracecmd_output *handle,
+			struct common_record_context *ctx)
+{
+	int type = 0;
+
+	if (ctx->date2ts) {
+		if (ctx->data_flags & DATA_FL_DATE)
+			type = TRACECMD_OPTION_DATE;
+		else if (ctx->data_flags & DATA_FL_OFFSET)
+			type = TRACECMD_OPTION_OFFSET;
+		else if (ctx->data_flags & DATA_FL_OFFSET_N)
+			type = TRACECMD_OPTION_OFFSET_N;
+	}
+
+	if (type)
+		tracecmd_add_option(handle, type,
+				    strlen(ctx->date2ts)+1, ctx->date2ts);
+
+	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
+	add_option_hooks(handle);
+	add_uname(handle);
+}
 
 static struct tracecmd_msg_handle *
 setup_connection(struct buffer_instance *instance, struct common_record_context *ctx)
@@ -3457,40 +3519,6 @@ add_buffer_stat(struct tracecmd_output *handle, struct buffer_instance *instance
 				    instance->s_save[i].buffer);
 }
 
-static void add_option_hooks(struct tracecmd_output *handle)
-{
-	struct hook_list *hook;
-	int len;
-
-	for (hook = hooks; hook; hook = hook->next) {
-		len = strlen(hook->hook);
-		tracecmd_add_option(handle, TRACECMD_OPTION_HOOK,
-				    len + 1, hook->hook);
-	}
-}
-
-static void add_uname(struct tracecmd_output *handle)
-{
-	struct utsname buf;
-	char *str;
-	int len;
-	int ret;
-
-	ret = uname(&buf);
-	/* if this fails for some reason, just ignore it */
-	if (ret < 0)
-		return;
-
-	len = strlen(buf.sysname) + strlen(buf.nodename) +
-		strlen(buf.release) + strlen(buf.machine) + 4;
-	str = malloc(len);
-	if (!str)
-		return;
-	sprintf(str, "%s %s %s %s", buf.sysname, buf.nodename, buf.release, buf.machine);
-	tracecmd_add_option(handle, TRACECMD_OPTION_UNAME, len, str);
-	free(str);
-}
-
 static void print_stat(struct buffer_instance *instance)
 {
 	int cpu;
@@ -3505,31 +3533,6 @@ static void print_stat(struct buffer_instance *instance)
 		trace_seq_do_printf(&instance->s_print[cpu]);
 }
 
-enum {
-	DATA_FL_NONE		= 0,
-	DATA_FL_DATE		= 1,
-	DATA_FL_OFFSET		= 2,
-};
-
-static void add_options(struct tracecmd_output *handle, struct common_record_context *ctx)
-{
-	int type = 0;
-
-	if (ctx->date2ts) {
-		if (ctx->data_flags & DATA_FL_DATE)
-			type = TRACECMD_OPTION_DATE;
-		else if (ctx->data_flags & DATA_FL_OFFSET)
-			type = TRACECMD_OPTION_OFFSET;
-	}
-
-	if (type)
-		tracecmd_add_option(handle, type, strlen(ctx->date2ts)+1, ctx->date2ts);
-
-	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
-	add_option_hooks(handle);
-	add_uname(handle);
-}
-
 static void write_guest_file(struct buffer_instance *instance)
 {
 	struct tracecmd_output *handle;
-- 
2.20.1

