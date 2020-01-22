Return-Path: <SRS0=9Wso=3L=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 524D1C2D0DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2783F24673
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jan 2020 15:00:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZ3tj/ec"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgAVPAR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 10:00:17 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:36144 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVPAQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 10:00:16 -0500
Received: by mail-lj1-f194.google.com with SMTP id r19so7168421ljg.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Jan 2020 07:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eqRso3NEbB+YvSEB+vbn9an1fQ/4pFwItG6zwIvSo90=;
        b=EZ3tj/ec7X2TkEkGoxglrMtSnt9s5M37iohkftoRX0ygtzWHtMt6AfBaOM5wfKaTCG
         Ehx3Gi5kPZ3Jxr3t0A1x6MTORCxKv29C9Na3hIYVPZj/wydSLCKr1KMZ0qSwx6vbM+7C
         /TdsHxcx/xs6YpUup3VwZoNa/rYdV6YaAKwSSt0SQluwfy7fRRuaCbKeOWfZoatSDJur
         S2YcbMkk9u+Lz4Fyv8JVJITgbfr94Fjkt6/UzjE+tnE8pq7UXFFaO7mus0tzGX2NnHzC
         MoDnhaFSDnV6TbKhceBHhRZfI+xOrVCu/wpctUrbxkHYMBwRmuWVhA+wETZFJEGPOd47
         gYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eqRso3NEbB+YvSEB+vbn9an1fQ/4pFwItG6zwIvSo90=;
        b=cCXoxEjBCLOrnCGR+vuSui9z0qOzkndQHFwMQUjIAHdrgbLW5lA2zQQpFVDX58rBqX
         oxuiK57tq1VybDVHBnULN8Wr0o5qCIXgCtvzyndi2e8rXy4ulTuEydayEuPoAI1H4X9S
         O4Wk7uy2Bxhgkrs2oVcuwzw41sV/x2V60RNBfmsDFqE0TTv90NkX6zCWd2V8nAiwnixc
         5VcrCHQBPBQRlW//+SBQncB9GJk7+YyOxwCZb+LqFdElk4esQhu6cpFItOEoRXSWqGOu
         xQlGr1M4G/PxUv5RGaoQ39SEJsnn4jURX5QjJ+wTgQdHpOpN77Rj0phg2+avvU0o4diq
         969A==
X-Gm-Message-State: APjAAAUA0kbpIvLi6WVAoiFUibNI6zqj5Dqzksyxuufrlhimp9EjhlG3
        tb4PA+6JIg+L7QW+3F7B22lpqqLE
X-Google-Smtp-Source: APXvYqz+9ob8HR3RURJIOcSlMz+T93xAdi86r3LiRTlkUl8R1A1HFSuCAoN0vHK8nSHM+oHKj4VsPQ==
X-Received: by 2002:a2e:b5ac:: with SMTP id f12mr20132559ljn.0.1579705214268;
        Wed, 22 Jan 2020 07:00:14 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l7sm20722803lfc.80.2020.01.22.07.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 07:00:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 7/7] trace-cmd, kernelshark, libtraceevent: Changed tep_plugin_add_option() API
Date:   Wed, 22 Jan 2020 17:00:02 +0200
Message-Id: <20200122150002.763233-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200122150002.763233-1-tz.stoyanov@gmail.com>
References: <20200122150002.763233-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The API
 tep_plugin_add_option()
is renamed to
 tep_plugin_set_option()

The new name describes more closely the purpose of the API -
it lets us update the option's value. The logic of the API is
slightly changed: If no plugin is given, all options that match
the option name will be updated.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/traceevent/event-parse.h |  2 +-
 kernel-shark/src/libkshark.c     |  4 ++--
 lib/traceevent/event-plugin.c    | 30 +++++++++++++++++++++++-------
 tracecmd/trace-read.c            |  2 +-
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index a64482d..538dd94 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -368,7 +368,7 @@ void tep_walk_plugins(const struct tep_plugin_list *list,
 
 int tep_plugin_add_options(const char *name,
 			   struct tep_plugin_option *options);
-int tep_plugin_add_option(const char *name, const char *val);
+int tep_plugin_set_option(const char *name, const char *val);
 void tep_plugin_remove_options(struct tep_plugin_option *options);
 void tep_plugin_walk_options(int (*callback)(struct tep_plugin_option *op,
 					     void *context),
diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index a361578..34fa007 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -160,8 +160,8 @@ bool kshark_open(struct kshark_context *kshark_ctx, const char *file)
 	 * Turn off function trace indent and turn on show parent
 	 * if possible.
 	 */
-	tep_plugin_add_option("ftrace:parent", "1");
-	tep_plugin_add_option("ftrace:indent", "0");
+	tep_plugin_set_option("ftrace:parent", "1");
+	tep_plugin_set_option("ftrace:indent", "0");
 
 	return true;
 }
diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
index 1ea02e6..4af85de 100644
--- a/lib/traceevent/event-plugin.c
+++ b/lib/traceevent/event-plugin.c
@@ -219,7 +219,10 @@ static void parse_option_name(char **option, char **plugin)
 	*plugin = NULL;
 
 	if ((p = strstr(*option, ":"))) {
-		*plugin = *option;
+		if (**option == ':')
+			*plugin = NULL;
+		else
+			*plugin = *option;
 		*p = '\0';
 		*option = strdup(p + 1);
 		if (!*option)
@@ -229,25 +232,38 @@ static void parse_option_name(char **option, char **plugin)
 
 static int process_option(const char *plugin, const char *option, const char *val)
 {
+	struct registered_plugin_options *reg;
 	struct tep_plugin_option *op;
+	int ret;
 
-	op = find_registered_option(plugin, option);
-	if (!op)
-		return 0;
+	for (reg = registered_options; reg; reg = reg->next) {
+		for (op = reg->options; op->name; op++) {
+			if (plugin && strcmp(plugin, op->plugin) != 0)
+				continue;
+			if (strcmp(option, op->name) != 0)
+				continue;
 
-	return update_option_value(op, val);
+			ret = update_option_value(op, val);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return 0;
 }
 
 /**
- * tep_plugin_add_option - add an option/val pair to set plugin options
+ * tep_plugin_set_option - update the value of plugin option
  * @name: The name of the option (format: <plugin>:<option> or just <option>)
  * @val: (optiona) the value for the option
  *
  * Modify a plugin option. If @val is given than the value of the option
  * is set (note, some options just take a boolean, so @val must be either
  * "1" or "0" or "true" or "false").
+ * If there is no <plugin> in the @name, all options with name <option> will
+ * be updated.
  */
-int tep_plugin_add_option(const char *name, const char *val)
+int tep_plugin_set_option(const char *name, const char *val)
 {
 	struct trace_plugin_options *op;
 	char *option_str;
diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index c0d640d..7b41d72 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1381,7 +1381,7 @@ static void process_plugin_option(char *option)
 		*p = '\0';
 		val = p+1;
 	}
-	tep_plugin_add_option(name, val);
+	tep_plugin_set_option(name, val);
 }
 
 static void set_event_flags(struct tep_handle *pevent, struct event_str *list,
-- 
2.24.1

