Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0825C433E0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 641C423730
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbhAOFE4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFEz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:04:55 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C76C0613CF
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:14 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id ga15so11575508ejb.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lGkZPE9J//gBgZYdQHbGsB9y8EyXeA1zzNgqJP/2kuc=;
        b=MszHrI43Vc/HjVUUfaNbAxTxQzVJZ5JRpXA/yqvdQ8L2NyC0tHGLKSz3M2eKVep7bm
         1Zaez4ZXAlJSBUfQ3A4eUObqFadW3gffhNsPqbmXEQ82f+VcFR/KUniig43fN6pUiSnT
         MBHB85Wb+u80l6aSbLIL8/Oxh6Kz0oiG5jASrDf05X/e7/6d4l9/cYgOjpimsciIWT5A
         dLEpocqkX53wI4+cirjoX2Dabip/T//4CEO1oZZ6aj+ZH/8rOLSxVwrC3QFBRPDgbtxE
         oxcYki6/+qJIncNaPje6E2r3N2MCCCmPhTCeATiTc4JlNMT21C9c2Fk34oPyAPHnI4ok
         S7Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lGkZPE9J//gBgZYdQHbGsB9y8EyXeA1zzNgqJP/2kuc=;
        b=Rh6VZA9CWReKtpi9qobMHUe2LxJJRrdYEoETpZ7rqX4nAEL2Y0Fc5R/fTgW2rjKK5N
         v4T5iI/A9Hkbk6c6ryOfOwjUIT7vcPdEyjI6NksXev2WSrtTyR2vgBcqUxT/gE8GpxZt
         izqQoRowMQflR6Y3N6T1+aNRcohuSc+DEZbQBynsWG+55V6diPXKY2mXbmi+ob8U8Qnw
         Q3BWhuS9R2lnd1MzKGfH+H7ZujKKY1i+SNsXDyLdOsoIGmgp1fM6NCURRmnyDrsDcSRk
         DU6dJ8zjG9+5bbNeSlcLDlBgWA9mVGeShP9ma6UXPzFecDLH3b/MdNEmdhVyyc0qGbyx
         Gisw==
X-Gm-Message-State: AOAM530FA2FLLzNUUUdcQGwXdoNb1CuLZ/J/HvGw8TH9GPF3hYEFkJSX
        FUQoDcBSWmWCWQ8Tzml126dxXy0HsQ/89FL5
X-Google-Smtp-Source: ABdhPJz2NEc7fo8biTz5X7ysaPIWBDI9MteLCxbWhKyCkUXPX9Bojz2LS+WyeITWy6uV5ZKdhmopDw==
X-Received: by 2002:a17:906:e106:: with SMTP id gj6mr294261ejb.337.1610687053640;
        Thu, 14 Jan 2021 21:04:13 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d4sm3055670edq.36.2021.01.14.21.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:04:12 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/5] libtracefs: New APIs for trace options
Date:   Fri, 15 Jan 2021 07:04:06 +0200
Message-Id: <20210115050410.1194011-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
References: <20210115050410.1194011-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These new APIs can be used to check and set various trace options

tracefs_options_get_supported();
tracefs_option_is_supported();
tracefs_options_get_enabled();
tracefs_option_is_enabled();
tracefs_options_set();
tracefs_options_clear();
tracefs_option_string();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |  54 ++++++++++
 src/tracefs-tools.c | 251 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 305 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 85a776e..1f10a00 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -80,4 +80,58 @@ int tracefs_fill_local_events(const char *tracing_dir,
 
 char *tracefs_get_clock(struct tracefs_instance *instance);
 
+#define		TRACEFS_OPTION_ANNOTATE		((unsigned long long)1 << 0)
+#define		TRACEFS_OPTION_BIN		((unsigned long long)1 << 1)
+#define		TRACEFS_OPTION_BLK_CGNAME	((unsigned long long)1 << 2)
+#define		TRACEFS_OPTION_BLK_CGROUP	((unsigned long long)1 << 3)
+#define		TRACEFS_OPTION_BLK_CLASSIC	((unsigned long long)1 << 4)
+#define		TRACEFS_OPTION_BLOCK		((unsigned long long)1 << 5)
+#define		TRACEFS_OPTION_CONTEXT_INFO	((unsigned long long)1 << 6)
+#define		TRACEFS_OPTION_DISABLE_ON_FREE	((unsigned long long)1 << 7)
+#define		TRACEFS_OPTION_DISPLAY_GRAPH	((unsigned long long)1 << 8)
+#define		TRACEFS_OPTION_EVENT_FORK	((unsigned long long)1 << 9)
+#define		TRACEFS_OPTION_FGRAPH_ABSTIME	((unsigned long long)1 << 10)
+#define		TRACEFS_OPTION_FGRAPH_CPU	((unsigned long long)1 << 11)
+#define		TRACEFS_OPTION_FGRAPH_DURATION	((unsigned long long)1 << 12)
+#define		TRACEFS_OPTION_FGRAPH_IRQS	((unsigned long long)1 << 13)
+#define		TRACEFS_OPTION_FGRAPH_OVERHEAD	((unsigned long long)1 << 14)
+#define		TRACEFS_OPTION_FGRAPH_OVERRUN	((unsigned long long)1 << 15)
+#define		TRACEFS_OPTION_FGRAPH_PROC	((unsigned long long)1 << 16)
+#define		TRACEFS_OPTION_FGRAPH_TAIL	((unsigned long long)1 << 17)
+#define		TRACEFS_OPTION_FUNC_STACKTRACE	((unsigned long long)1 << 18)
+#define		TRACEFS_OPTION_FUNCTION_FORK	((unsigned long long)1 << 19)
+#define		TRACEFS_OPTION_FUNCTION_TRACE	((unsigned long long)1 << 20)
+#define		TRACEFS_OPTION_GRAPH_TIME	((unsigned long long)1 << 21)
+#define		TRACEFS_OPTION_HEX		((unsigned long long)1 << 22)
+#define		TRACEFS_OPTION_IRQ_INFO		((unsigned long long)1 << 23)
+#define		TRACEFS_OPTION_LATENCY_FORMAT	((unsigned long long)1 << 24)
+#define		TRACEFS_OPTION_MARKERS		((unsigned long long)1 << 25)
+#define		TRACEFS_OPTION_OVERWRITE	((unsigned long long)1 << 26)
+#define		TRACEFS_OPTION_PAUSE_ON_TRACE	((unsigned long long)1 << 27)
+#define		TRACEFS_OPTION_PRINTK_MSG_ONLY	((unsigned long long)1 << 28)
+#define		TRACEFS_OPTION_PRINT_PARENT	((unsigned long long)1 << 29)
+#define		TRACEFS_OPTION_RAW		((unsigned long long)1 << 30)
+#define		TRACEFS_OPTION_RECORD_CMD	((unsigned long long)1 << 31)
+#define		TRACEFS_OPTION_RECORD_TGID	((unsigned long long)1 << 32)
+#define		TRACEFS_OPTION_SLEEP_TIME	((unsigned long long)1 << 33)
+#define		TRACEFS_OPTION_STACKTRACE	((unsigned long long)1 << 34)
+#define		TRACEFS_OPTION_SYM_ADDR		((unsigned long long)1 << 35)
+#define		TRACEFS_OPTION_SYM_OFFSET	((unsigned long long)1 << 36)
+#define		TRACEFS_OPTION_SYM_USEROBJ	((unsigned long long)1 << 37)
+#define		TRACEFS_OPTION_TEST_NOP_ACCEPT	((unsigned long long)1 << 38)
+#define		TRACEFS_OPTION_TEST_NOP_REFUSE	((unsigned long long)1 << 39)
+#define		TRACEFS_OPTION_TRACE_PRINTK	((unsigned long long)1 << 40)
+#define		TRACEFS_OPTION_USERSTACKTRACE	((unsigned long long)1 << 41)
+#define		TRACEFS_OPTION_VERBOSE		((unsigned long long)1 << 42)
+
+#define		TRACEFS_OPTION_INVALID		((unsigned long long)1 << 43)
+
+unsigned long long tracefs_options_get_supported(struct tracefs_instance *instance);
+bool tracefs_option_is_supported(struct tracefs_instance *instance, unsigned long long id);
+unsigned long long tracefs_options_get_enabled(struct tracefs_instance *instance);
+bool tracefs_option_is_enabled(struct tracefs_instance *instance, unsigned long long id);
+int tracefs_options_set(struct tracefs_instance *instance, unsigned long long options);
+int tracefs_options_clear(struct tracefs_instance *instance, unsigned long long options);
+const char *tracefs_option_string(unsigned long long id);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 101f389..0505552 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -9,12 +9,66 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/types.h>
+#include <dirent.h>
+#include <limits.h>
+#include <errno.h>
 
 #include "tracefs.h"
 #include "tracefs-local.h"
 
 #define TRACE_CTRL	"tracing_on"
 
+struct options_map {
+	unsigned long long id;
+	char *name;
+} options_map[] = {
+	{ TRACEFS_OPTION_ANNOTATE,		"annotate" },
+	{ TRACEFS_OPTION_BIN,			"bin" },
+	{ TRACEFS_OPTION_BLK_CGNAME,		"blk_cgname" },
+	{ TRACEFS_OPTION_BLK_CGROUP,		"blk_cgroup" },
+	{ TRACEFS_OPTION_BLK_CLASSIC,		"blk_classic" },
+	{ TRACEFS_OPTION_BLOCK,			"block" },
+	{ TRACEFS_OPTION_CONTEXT_INFO,		"context-info" },
+	{ TRACEFS_OPTION_DISABLE_ON_FREE,	"disable_on_free" },
+	{ TRACEFS_OPTION_DISPLAY_GRAPH,		"display-graph" },
+	{ TRACEFS_OPTION_EVENT_FORK,		"event-fork" },
+	{ TRACEFS_OPTION_FGRAPH_ABSTIME,	"funcgraph-abstime" },
+	{ TRACEFS_OPTION_FGRAPH_CPU,		"funcgraph-cpu" },
+	{ TRACEFS_OPTION_FGRAPH_DURATION,	"funcgraph-duration" },
+	{ TRACEFS_OPTION_FGRAPH_IRQS,		"funcgraph-irqs" },
+	{ TRACEFS_OPTION_FGRAPH_OVERHEAD,	"funcgraph-overhead" },
+	{ TRACEFS_OPTION_FGRAPH_OVERRUN,	"funcgraph-overrun" },
+	{ TRACEFS_OPTION_FGRAPH_PROC,		"funcgraph-proc" },
+	{ TRACEFS_OPTION_FGRAPH_TAIL,		"funcgraph-tail" },
+	{ TRACEFS_OPTION_FUNC_STACKTRACE,	"func_stack_trace" },
+	{ TRACEFS_OPTION_FUNCTION_FORK,		"function-fork" },
+	{ TRACEFS_OPTION_FUNCTION_TRACE,	"function-trace" },
+	{ TRACEFS_OPTION_GRAPH_TIME,		"graph-time" },
+	{ TRACEFS_OPTION_HEX,			"hex" },
+	{ TRACEFS_OPTION_IRQ_INFO,		"irq-info" },
+	{ TRACEFS_OPTION_LATENCY_FORMAT,	"latency-format" },
+	{ TRACEFS_OPTION_MARKERS,		"markers" },
+	{ TRACEFS_OPTION_OVERWRITE,		"overwrite" },
+	{ TRACEFS_OPTION_PAUSE_ON_TRACE,	"pause-on-trace" },
+	{ TRACEFS_OPTION_PRINTK_MSG_ONLY,	"printk-msg-only" },
+	{ TRACEFS_OPTION_PRINT_PARENT,		"print-parent" },
+	{ TRACEFS_OPTION_RAW,			"raw" },
+	{ TRACEFS_OPTION_RECORD_CMD,		"record-cmd" },
+	{ TRACEFS_OPTION_RECORD_TGID,		"record-tgid" },
+	{ TRACEFS_OPTION_SLEEP_TIME,		"sleep-time" },
+	{ TRACEFS_OPTION_STACKTRACE,		"stacktrace" },
+	{ TRACEFS_OPTION_SYM_ADDR,		"sym-addr" },
+	{ TRACEFS_OPTION_SYM_OFFSET,		"sym-offset" },
+	{ TRACEFS_OPTION_SYM_USEROBJ,		"sym-userobj" },
+	{ TRACEFS_OPTION_TEST_NOP_ACCEPT,	"test_nop_accept" },
+	{ TRACEFS_OPTION_TEST_NOP_REFUSE,	"test_nop_refuse" },
+	{ TRACEFS_OPTION_TRACE_PRINTK,		"trace_printk" },
+	{ TRACEFS_OPTION_USERSTACKTRACE,	"userstacktrace" },
+	{ TRACEFS_OPTION_VERBOSE,		"verbose" },
+	{ TRACEFS_OPTION_INVALID,		"unknown" },
+};
+
 static int trace_on_off(int fd, bool on)
 {
 	const char *val = on ? "1" : "0";
@@ -107,3 +161,200 @@ int tracefs_trace_off_fd(int fd)
 		return -1;
 	return trace_on_off(fd, false);
 }
+
+/**
+ * tracefs_option_string - Get trace option name from ID
+ * @id: trace option ID
+ *
+ * Returns string with option name, or "unknown" in case of not known option ID
+ */
+const char *tracefs_option_string(unsigned long long id)
+{
+	int size = sizeof(options_map) / sizeof(struct options_map);
+	int i;
+
+	for (i = 0; i < size; i++) {
+		if (options_map[i].id == id)
+			return options_map[i].name;
+	}
+
+	return options_map[size - 1].name;
+}
+
+/**
+ * tracefs_option_id - Get trace option ID from name
+ * @name: trace option name
+ *
+ * Returns trace option ID or TRACEFS_OPTION_INVALID in case of an error or
+ * unknown option name.
+ */
+unsigned long long tracefs_option_id(char *name)
+{
+	int size = sizeof(options_map) / sizeof(struct options_map);
+	int i;
+
+	if (!name)
+		return TRACEFS_OPTION_INVALID;
+
+	for (i = 0; i < size; i++) {
+		if (strlen(name) == strlen(options_map[i].name) &&
+		    !strcmp(options_map[i].name, name))
+			return options_map[i].id;
+	}
+
+	return TRACEFS_OPTION_INVALID;
+}
+
+static unsigned long long trace_get_options(struct tracefs_instance *instance,
+					    bool enabled)
+{
+	unsigned long long options = 0;
+	unsigned long long id;
+	char file[PATH_MAX];
+	struct dirent *dent;
+	char *dname = NULL;
+	DIR *dir = NULL;
+	long long val;
+
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
+			options |= id;
+	}
+	closedir(dir);
+	tracefs_put_tracing_file(dname);
+
+	return options;
+
+error:
+	if (dir)
+		closedir(dir);
+	tracefs_put_tracing_file(dname);
+	return 0;
+}
+
+/**
+ * tracefs_options_get_supported - Get all supported trace options in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns bitmask of all trace options, supported in given instance
+ */
+unsigned long long tracefs_options_get_supported(struct tracefs_instance *instance)
+{
+	return trace_get_options(instance, false);
+}
+
+/**
+ * tracefs_options_get_enabled - Get all currently enabled trace options in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ *
+ * Returns bitmask of all trace options, that are currently set in given instance
+ */
+unsigned long long tracefs_options_get_enabled(struct tracefs_instance *instance)
+{
+	return trace_get_options(instance, true);
+}
+
+static int trace_config_options(struct tracefs_instance *instance,
+				unsigned long long options, bool set)
+{
+	int size = sizeof(options_map) / sizeof(struct options_map);
+	char *set_str = set ? "1" : "0";
+	int str_size = strlen(set_str);
+	char file[PATH_MAX];
+	long long i;
+
+	for (i = 0; i < size && options; i++) {
+		if (!(options & options_map[i].id))
+			continue;
+		options &= ~options_map[i].id;
+		snprintf(file, PATH_MAX, "options/%s", options_map[i].name);
+		if (str_size != tracefs_instance_file_write(instance, file, set_str))
+			break;
+	}
+
+	if (options)
+		return -1;
+	return 0;
+}
+
+/**
+ * tracefs_options_set - Enable trace options
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @options: bitmask of trace options that will be enabled
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_options_set(struct tracefs_instance *instance, unsigned long long options)
+{
+	return trace_config_options(instance, options, true);
+}
+
+/**
+ * tracefs_options_clear - Disable trace options
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @options: bitmask of trace options that will be disabled
+ *
+ * Returns -1 in case of an error or 0 otherwise
+ */
+int tracefs_options_clear(struct tracefs_instance *instance, unsigned long long options)
+{
+	return trace_config_options(instance, options, false);
+}
+
+/**
+ * tracefs_option_is_supported - Check if an option is supported
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: option id
+ *
+ * Returns true if an option with given id is supported by the system, false if
+ * it is not supported.
+ */
+bool tracefs_option_is_supported(struct tracefs_instance *instance, unsigned long long id)
+{
+	char file[PATH_MAX];
+	const char *oname = tracefs_option_string(id);
+
+	if (!oname)
+		return false;
+	snprintf(file, PATH_MAX, "options/%s", oname);
+	return tracefs_file_exists(instance, (char *)file);
+}
+
+/**
+ * tracefs_option_is_enabled - Check if an option is enabled in given instance
+ * @instance: ftrace instance, can be NULL for the top instance
+ * @id: option id
+ *
+ * Returns true if an option with given id is enabled in the given instance,
+ * false if it is not enabled.
+ */
+bool tracefs_option_is_enabled(struct tracefs_instance *instance, unsigned long long id)
+{
+	const char *oname = tracefs_option_string(id);
+	char file[PATH_MAX];
+	long long res;
+
+	if (!oname)
+		return false;
+	snprintf(file, PATH_MAX, "options/%s", oname);
+	if (!tracefs_instance_file_read_number(instance, file, &res) && res)
+		return true;
+
+	return false;
+}
-- 
2.29.2

