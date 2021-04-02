Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2657EC43461
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDBE0610D1
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhDBNUI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhDBNUH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:07 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53057C0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:06 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ap14so7473002ejc.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BuREHbHSY0biXmAmsmHsevF/CWO+IFZCyFyzPRx2Quo=;
        b=TxqLKVqfLiOqquk7GQ+hyXpIZTp8X91/5b8jJDM9suvETpv5Qn5yhqaemWdRdE5kXj
         kY+X1t+RrbBHRT3zRtdWWbEVqAjhHd44BGf2S1Qbs1YqTiBtqMKBcc/VsUxornxOvBN3
         iVlEd8RSGN+sui/pd2XICMuEFEFs11/C91s5e2X2HKtdVrA/cbqPyGY7s21ecItq1ZDG
         jt7mhRR/RRbUSqshC/oJ95+TIcGtEv/YFVgY5HxlXeiyff9i7IQ5ec6aWuwyQB9o7RCA
         tQKeA/WFkES4Os0xBocf1qQQDiqNAyw3aIjqigYPZl2pOSW/WRIL4ZOGPe4YB4vqqcJ8
         eb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BuREHbHSY0biXmAmsmHsevF/CWO+IFZCyFyzPRx2Quo=;
        b=b9RAv3jk3gND+EixhfbSAKVaXbLuuMofX81mk3u+LJqLqIzZbc7jItleLZD1H+920s
         BAmidniZs6rXjp5/2u/Tg/iZJX369aqS2njjkfyuNOVpFhzW+vLBRLeM+wRxrCXmdMtG
         rE9U5IJljM+s4h0l6+qGu0WkB0Qoq1+zv4eXfRKym+uG20aGIDtHe01JiUdlx4xiTLng
         sZqxkZr4uBBfp6pQwuTPDjWqGXPmFNZXpFVj7/qi8NmBe81aMkrTX4gCxeRSlVzc5TFT
         rJRKN968eb9X5vjJW1TlC50mgbFWPl9h7fQyDpB7dKlHOWZAbykJ1M3xKxnVWQBXePcl
         /u5w==
X-Gm-Message-State: AOAM5315R9PzbqcufNz/NPyXcqSXWM5FIPnl2gMXtpsI5QlRJeSWxOPC
        ovGDkTX/5HzbWwzvY+uouU+iet6hMYzq6A==
X-Google-Smtp-Source: ABdhPJxOa74YRHzWu2hZId3efR/dspZik2MpDBDDUeaAQNlV+uv5DZxeSWF2FacMeyaItbXYjuw8Mg==
X-Received: by 2002:a17:906:5d05:: with SMTP id g5mr13901626ejt.489.1617369604901;
        Fri, 02 Apr 2021 06:20:04 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:04 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 4/6] libtracefs: Move the "options" code to  tracefs-instance.c
Date:   Fri,  2 Apr 2021 16:19:45 +0300
Message-Id: <20210402131947.346235-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We would like the instance object to own two bit masks (struct
tracefs_options_mask) associated with all supported and all enabled
options. However, the definition of the instance itself is not public,
hence the code implementing the "options" related APIs has to in the
same source file as the definition of the instance.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-instance.c | 266 +++++++++++++++++++++++++++++++++++++++++
 src/tracefs-tools.c    | 266 -----------------------------------------
 2 files changed, 266 insertions(+), 266 deletions(-)

diff --git a/src/tracefs-instance.c b/src/tracefs-instance.c
index 0df313c..49645eb 100644
--- a/src/tracefs-instance.c
+++ b/src/tracefs-instance.c
@@ -18,6 +18,10 @@
 #include "tracefs.h"
 #include "tracefs-local.h"
 
+struct tracefs_options_mask {
+	unsigned long long	mask;
+};
+
 #define FLAG_INSTANCE_NEWLY_CREATED	(1 << 0)
 struct tracefs_instance {
 	char	*trace_dir;
@@ -587,3 +591,265 @@ out:
 	free(all_clocks);
 	return ret;
 }
+
+static const char * const options_map[] = {
+	"unknown",
+	"annotate",
+	"bin",
+	"blk_cgname",
+	"blk_cgroup",
+	"blk_classic",
+	"block",
+	"context-info",
+	"disable_on_free",
+	"display-graph",
+	"event-fork",
+	"funcgraph-abstime",
+	"funcgraph-cpu",
+	"funcgraph-duration",
+	"funcgraph-irqs",
+	"funcgraph-overhead",
+	"funcgraph-overrun",
+	"funcgraph-proc",
+	"funcgraph-tail",
+	"func_stack_trace",
+	"function-fork",
+	"function-trace",
+	"graph-time",
+	"hex",
+	"irq-info",
+	"latency-format",
+	"markers",
+	"overwrite",
+	"pause-on-trace",
+	"printk-msg-only",
+	"print-parent",
+	"raw",
+	"record-cmd",
+	"record-tgid",
+	"sleep-time",
+	"stacktrace",
+	"sym-addr",
+	"sym-offset",
+	"sym-userobj",
+	"trace_printk",
+	"userstacktrace",
+	"verbose" };
+
+/**
+ * tracefs_option_name - Get trace option name from id
+ * @id: trace option id
+ *
+ * Returns string with option name, or "unknown" in case of not known option id.
+ * The returned string must *not* be freed.
+ */
+const char *tracefs_option_name(enum tracefs_option_id id)
+{
+	/* Make sure options map contains all the options */
+	BUILD_BUG_ON(ARRAY_SIZE(options_map) != TRACEFS_OPTION_MAX);
+
+	if (id < TRACEFS_OPTION_MAX)
+		return options_map[id];
+
+	return options_map[0];
+}
+
+/**
+ * tracefs_option_id - Get trace option ID from name
+ * @name: trace option name
+ *
+ * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
+ * unknown option name.
+ */
+enum tracefs_option_id tracefs_option_id(const char *name)
+{
+	int i;
+
+	if (!name)
+		return TRACEFS_OPTION_INVALID;
+
+	for (i = 0; i < TRACEFS_OPTION_MAX; i++) {
+		if (strlen(name) == strlen(options_map[i]) &&
+		    !strcmp(options_map[i], name))
+			return i;
+	}
+
+	return TRACEFS_OPTION_INVALID;
+}
+
+static void tracefs_option_set(struct tracefs_options_mask *options,
+			       enum tracefs_option_id id)
+{
+	if (options && id > TRACEFS_OPTION_INVALID)
+		options->mask |= (1ULL << (id - 1));
+}
+
+static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
+						      bool enabled)
+{
+	struct tracefs_options_mask *bitmask;
+	enum tracefs_option_id id;
+	char file[PATH_MAX];
+	struct dirent *dent;
+	char *dname = NULL;
+	DIR *dir = NULL;
+	long long val;
+
+	bitmask = calloc(1, sizeof(struct tracefs_options_mask));
+	if (!bitmask)
+		return NULL;
+	dname = tracefs_instance_get_file(instance, "options");
+	if (!dname)
+		goto error;
+	dir = opendir(dname);
+	if (!dir)
+		goto error;
+
+	while ((dent = readdir(dir))) {
+		if (*dent->d_name == '.')
+			continue;
+		if (enabled) {
+			snprintf(file, PATH_MAX, "options/%s", dent->d_name);
+			if (tracefs_instance_file_read_number(instance, file, &val) != 0 ||
+			    val != 1)
+				continue;
+		}
+		id = tracefs_option_id(dent->d_name);
+		if (id != TRACEFS_OPTION_INVALID)
+			tracefs_option_set(bitmask, id);
+	}
+	closedir(dir);
+	tracefs_put_tracing_file(dname);
+
+	return bitmask;
+
+error:
+	if (dir)
+		closedir(dir);
+	tracefs_put_tracing_file(dname);
+	free(bitmask);
+	return NULL;
+}
+
+/**
+ * tracefs_options_get_supported - Get all supported trace options in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns allocated bitmask structure with all trace options, supported in given
+ * instance, or NULL in case of an error. The returned structure must be freed with free()
+ */
+struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
+{
+	return trace_get_options(instance, false);
+}
+
+/**
+ * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns allocated bitmask structure with all trace options, enabled in given
+ * instance, or NULL in case of an error. The returned structure must be freed with free()
+ */
+struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
+{
+	return trace_get_options(instance, true);
+}
+
+static int trace_config_option(struct tracefs_instance *instance,
+			       enum tracefs_option_id id, bool set)
+{
+	char *set_str = set ? "1" : "0";
+	char file[PATH_MAX];
+	const char *name;
+
+	name = tracefs_option_name(id);
+	if (!name)
+		return -1;
+
+	snprintf(file, PATH_MAX, "options/%s", name);
+	if (strlen(set_str) != tracefs_instance_file_write(instance, file, set_str))
+		return -1;
+	return 0;
+}
+
+/**
+ * tracefs_option_enable - Enable trace option
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: trace option id
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id)
+{
+	return trace_config_option(instance, id, true);
+}
+
+/**
+ * tracefs_option_diasble - Disable trace option
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: trace option id
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id)
+{
+	return trace_config_option(instance, id, false);
+}
+
+/**
+ * tracefs_option_is_supported - Check if an option is supported
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: trace option id
+ *
+ * Returns true if an option with given id is supported by the system, false if
+ * it is not supported.
+ */
+bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id)
+{
+	const char *name = tracefs_option_name(id);
+	char file[PATH_MAX];
+
+	if (!name)
+		return false;
+	snprintf(file, PATH_MAX, "options/%s", name);
+	return tracefs_file_exists(instance, file);
+}
+
+/**
+ * tracefs_option_is_enabled - Check if an option is enabled in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: trace option id
+ *
+ * Returns true if an option with given id is enabled in the given instance,
+ * false if it is not enabled.
+ */
+bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id)
+{
+	const char *name = tracefs_option_name(id);
+	char file[PATH_MAX];
+	long long res;
+
+	if (!name)
+		return false;
+	snprintf(file, PATH_MAX, "options/%s", name);
+	if (!tracefs_instance_file_read_number(instance, file, &res) && res)
+		return true;
+
+	return false;
+}
+
+/**
+ * tracefs_option_is_set - Check if given option is set in the bitmask
+ * @options: Options bitmask
+ * @id: trace option id
+ *
+ * Returns true if an option with given id is set in the bitmask,
+ * false if it is not set.
+ */
+bool tracefs_option_is_set(struct tracefs_options_mask *options,
+			   enum tracefs_option_id id)
+{
+	if (id > TRACEFS_OPTION_INVALID)
+		return options->mask & (1ULL << (id - 1));
+	return false;
+}
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 11a4c8c..8f763a4 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -19,54 +19,6 @@
 
 #define TRACE_CTRL	"tracing_on"
 
-struct tracefs_options_mask {
-	unsigned long long	mask;
-};
-
-static const char * const options_map[] = {
-	"unknown",
-	"annotate",
-	"bin",
-	"blk_cgname",
-	"blk_cgroup",
-	"blk_classic",
-	"block",
-	"context-info",
-	"disable_on_free",
-	"display-graph",
-	"event-fork",
-	"funcgraph-abstime",
-	"funcgraph-cpu",
-	"funcgraph-duration",
-	"funcgraph-irqs",
-	"funcgraph-overhead",
-	"funcgraph-overrun",
-	"funcgraph-proc",
-	"funcgraph-tail",
-	"func_stack_trace",
-	"function-fork",
-	"function-trace",
-	"graph-time",
-	"hex",
-	"irq-info",
-	"latency-format",
-	"markers",
-	"overwrite",
-	"pause-on-trace",
-	"printk-msg-only",
-	"print-parent",
-	"raw",
-	"record-cmd",
-	"record-tgid",
-	"sleep-time",
-	"stacktrace",
-	"sym-addr",
-	"sym-offset",
-	"sym-userobj",
-	"trace_printk",
-	"userstacktrace",
-	"verbose" };
-
 static int trace_on_off(int fd, bool on)
 {
 	const char *val = on ? "1" : "0";
@@ -159,221 +111,3 @@ int tracefs_trace_off_fd(int fd)
 		return -1;
 	return trace_on_off(fd, false);
 }
-
-/**
- * tracefs_option_name - Get trace option name from id
- * @id: trace option id
- *
- * Returns string with option name, or "unknown" in case of not known option id.
- * The returned string must *not* be freed.
- */
-const char *tracefs_option_name(enum tracefs_option_id id)
-{
-	/* Make sure options map contains all the options */
-	BUILD_BUG_ON(ARRAY_SIZE(options_map) != TRACEFS_OPTION_MAX);
-
-	if (id < TRACEFS_OPTION_MAX)
-		return options_map[id];
-
-	return options_map[0];
-}
-
-/**
- * tracefs_option_id - Get trace option ID from name
- * @name: trace option name
- *
- * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
- * unknown option name.
- */
-enum tracefs_option_id tracefs_option_id(const char *name)
-{
-	int i;
-
-	if (!name)
-		return TRACEFS_OPTION_INVALID;
-
-	for (i = 0; i < TRACEFS_OPTION_MAX; i++) {
-		if (strlen(name) == strlen(options_map[i]) &&
-		    !strcmp(options_map[i], name))
-			return i;
-	}
-
-	return TRACEFS_OPTION_INVALID;
-}
-
-static void tracefs_option_set(struct tracefs_options_mask *options,
-			       enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask |= (1ULL << (id - 1));
-}
-
-static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
-						      bool enabled)
-{
-	struct tracefs_options_mask *bitmask;
-	enum tracefs_option_id id;
-	char file[PATH_MAX];
-	struct dirent *dent;
-	char *dname = NULL;
-	DIR *dir = NULL;
-	long long val;
-
-	bitmask = calloc(1, sizeof(struct tracefs_options_mask));
-	if (!bitmask)
-		return NULL;
-	dname = tracefs_instance_get_file(instance, "options");
-	if (!dname)
-		goto error;
-	dir = opendir(dname);
-	if (!dir)
-		goto error;
-
-	while ((dent = readdir(dir))) {
-		if (*dent->d_name == '.')
-			continue;
-		if (enabled) {
-			snprintf(file, PATH_MAX, "options/%s", dent->d_name);
-			if (tracefs_instance_file_read_number(instance, file, &val) != 0 ||
-			    val != 1)
-				continue;
-		}
-		id = tracefs_option_id(dent->d_name);
-		if (id != TRACEFS_OPTION_INVALID)
-			tracefs_option_set(bitmask, id);
-	}
-	closedir(dir);
-	tracefs_put_tracing_file(dname);
-
-	return bitmask;
-
-error:
-	if (dir)
-		closedir(dir);
-	tracefs_put_tracing_file(dname);
-	free(bitmask);
-	return NULL;
-}
-
-/**
- * tracefs_options_get_supported - Get all supported trace options in given instance
- * @instance: ftrace instance, can be NULL for the top instance
- *
- * Returns allocated bitmask structure with all trace options, supported in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
- */
-struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance)
-{
-	return trace_get_options(instance, false);
-}
-
-/**
- * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
- * @instance: ftrace instance, can be NULL for the top instance
- *
- * Returns allocated bitmask structure with all trace options, enabled in given
- * instance, or NULL in case of an error. The returned structure must be freed with free()
- */
-struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance)
-{
-	return trace_get_options(instance, true);
-}
-
-static int trace_config_option(struct tracefs_instance *instance,
-			       enum tracefs_option_id id, bool set)
-{
-	char *set_str = set ? "1" : "0";
-	char file[PATH_MAX];
-	const char *name;
-
-	name = tracefs_option_name(id);
-	if (!name)
-		return -1;
-
-	snprintf(file, PATH_MAX, "options/%s", name);
-	if (strlen(set_str) != tracefs_instance_file_write(instance, file, set_str))
-		return -1;
-	return 0;
-}
-
-/**
- * tracefs_option_enable - Enable trace option
- * @instance: ftrace instance, can be NULL for the top instance
- * @id: trace option id
- *
- * Returns -1 in case of an error or 0 otherwise
- */
-int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id)
-{
-	return trace_config_option(instance, id, true);
-}
-
-/**
- * tracefs_option_diasble - Disable trace option
- * @instance: ftrace instance, can be NULL for the top instance
- * @id: trace option id
- *
- * Returns -1 in case of an error or 0 otherwise
- */
-int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id)
-{
-	return trace_config_option(instance, id, false);
-}
-
-/**
- * tracefs_option_is_supported - Check if an option is supported
- * @instance: ftrace instance, can be NULL for the top instance
- * @id: trace option id
- *
- * Returns true if an option with given id is supported by the system, false if
- * it is not supported.
- */
-bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id)
-{
-	const char *name = tracefs_option_name(id);
-	char file[PATH_MAX];
-
-	if (!name)
-		return false;
-	snprintf(file, PATH_MAX, "options/%s", name);
-	return tracefs_file_exists(instance, file);
-}
-
-/**
- * tracefs_option_is_enabled - Check if an option is enabled in given instance
- * @instance: ftrace instance, can be NULL for the top instance
- * @id: trace option id
- *
- * Returns true if an option with given id is enabled in the given instance,
- * false if it is not enabled.
- */
-bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id)
-{
-	const char *name = tracefs_option_name(id);
-	char file[PATH_MAX];
-	long long res;
-
-	if (!name)
-		return false;
-	snprintf(file, PATH_MAX, "options/%s", name);
-	if (!tracefs_instance_file_read_number(instance, file, &res) && res)
-		return true;
-
-	return false;
-}
-
-/**
- * tracefs_option_is_set - Check if given option is set in the bitmask
- * @options: Options bitmask
- * @id: trace option id
- *
- * Returns true if an option with given id is set in the bitmask,
- * false if it is not set.
- */
-bool tracefs_option_is_set(struct tracefs_options_mask *options,
-			   enum tracefs_option_id id)
-{
-	if (id > TRACEFS_OPTION_INVALID)
-		return options->mask & (1ULL << (id - 1));
-	return false;
-}
-- 
2.27.0

