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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE54C433E9
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E4A4233EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Jan 2021 15:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731979AbhATPXZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Jan 2021 10:23:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390556AbhATPNl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Jan 2021 10:13:41 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1549C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:00 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id d26so23432304wrb.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Jan 2021 07:13:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NR8Rp1f4MT9wUwWwc3+wHHZOq9Ja7AJcb3OyBHKwQW4=;
        b=kOisUo6UEYbHtMYi8do2QNoV2xCPeh3gfUXcDOGGXenn66iJZoqNnJBYmh47ioMwSc
         NikpYOK3yt1s4g6Kg0FoNQ5LojNvvedZe0YGBHWrjSFm5LjQXlmOeVMxENBDC8Y5fGUC
         jwoaVJ5bYYRxr8JLdpGZOvDREP+qabm9cViFeqPtV3coxpupzo25gSn0OcFiMkMpJMS2
         9GzxKXfdVbjLGV/XvD56JGvKuqRPJtSAqNzL+UjNAhsYglY4bh/u2fs+YFGtaV39r9kC
         3oIzXDH1AvKeAjgmQ8/XnIBPhQ91LvPhoCcjl3AUu74eQ03ne8FJdg/venfIRVOvJy11
         RNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NR8Rp1f4MT9wUwWwc3+wHHZOq9Ja7AJcb3OyBHKwQW4=;
        b=SJXfXaFow9v7tT4mbOWttlgdtsjTaxmhrq3mTjqa4wuhnc5gsqF/fUvnq2ZTo4Kw0x
         AmZRNixzpzERsCPkEfP/FgrSvwS9M/NPw9GH3Ru05R0aS/oI/cazpdDtX9hvg/kc95WH
         HcugmwnYo6WMQ36udXERtd889udJedqsAs/jxlcyLHKNP8mIhAsjfW+07t53YBUXKQRK
         V93tQXbTEYkAEKtnQ/VgwUPWVVBpEVtW4ixJvhpSZrsTwdiYJJ73EC8TADscA2SBVifV
         Vsmi0qMriD4zmeFdKFVrn0XkNGPUbLEeNUw8RIsUooLluGGxlJV6Ep3fHQpDS78ak6Hc
         D1jA==
X-Gm-Message-State: AOAM533jWdDQ7ZQxlzopasHh/98zBPtCeGpxi4AHJZBh2q2CtsfS/CqV
        Yy7DDK52rZL3SJDohnhAhKw=
X-Google-Smtp-Source: ABdhPJy/zF9/8d1FQi60XqiOblz/BwXINC89pWJ05hCBxXsLBt4xymguj4KwGR3dqlVAUubcdOsmpA==
X-Received: by 2002:a5d:62c8:: with SMTP id o8mr9995865wrv.51.1611155579682;
        Wed, 20 Jan 2021 07:12:59 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c11sm4571106wmd.36.2021.01.20.07.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 07:12:59 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/5] libtracefs: New APIs for trace options
Date:   Wed, 20 Jan 2021 17:12:52 +0200
Message-Id: <20210120151256.43075-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210120151256.43075-1-tz.stoyanov@gmail.com>
References: <20210120151256.43075-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These new APIs can be used to check and set various trace options

tracefs_option_set();
tracefs_option_clear();
tracefs_option_is_set();
tracefs_options_get_supported();
tracefs_option_is_supported();
tracefs_options_get_enabled();
tracefs_option_is_enabled();
tracefs_option_enable();
tracefs_option_diasble();
tracefs_option_name();

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h   |  61 +++++++++++
 src/tracefs-tools.c | 244 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 305 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 85a776e..2df596f 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -80,4 +80,65 @@ int tracefs_fill_local_events(const char *tracing_dir,
 
 char *tracefs_get_clock(struct tracefs_instance *instance);
 
+enum tracefs_option_id {
+	TRACEFS_OPTION_INVALID = 0,
+	TRACEFS_OPTION_ANNOTATE,
+	TRACEFS_OPTION_BIN,
+	TRACEFS_OPTION_BLK_CGNAME,
+	TRACEFS_OPTION_BLK_CGROUP,
+	TRACEFS_OPTION_BLK_CLASSIC,
+	TRACEFS_OPTION_BLOCK,
+	TRACEFS_OPTION_CONTEXT_INFO,
+	TRACEFS_OPTION_DISABLE_ON_FREE,
+	TRACEFS_OPTION_DISPLAY_GRAPH,
+	TRACEFS_OPTION_EVENT_FORK,
+	TRACEFS_OPTION_FGRAPH_ABSTIME,
+	TRACEFS_OPTION_FGRAPH_CPU,
+	TRACEFS_OPTION_FGRAPH_DURATION,
+	TRACEFS_OPTION_FGRAPH_IRQS,
+	TRACEFS_OPTION_FGRAPH_OVERHEAD,
+	TRACEFS_OPTION_FGRAPH_OVERRUN,
+	TRACEFS_OPTION_FGRAPH_PROC,
+	TRACEFS_OPTION_FGRAPH_TAIL,
+	TRACEFS_OPTION_FUNC_STACKTRACE,
+	TRACEFS_OPTION_FUNCTION_FORK,
+	TRACEFS_OPTION_FUNCTION_TRACE,
+	TRACEFS_OPTION_GRAPH_TIME,
+	TRACEFS_OPTION_HEX,
+	TRACEFS_OPTION_IRQ_INFO,
+	TRACEFS_OPTION_LATENCY_FORMAT,
+	TRACEFS_OPTION_MARKERS,
+	TRACEFS_OPTION_OVERWRITE,
+	TRACEFS_OPTION_PAUSE_ON_TRACE,
+	TRACEFS_OPTION_PRINTK_MSG_ONLY,
+	TRACEFS_OPTION_PRINT_PARENT,
+	TRACEFS_OPTION_RAW,
+	TRACEFS_OPTION_RECORD_CMD,
+	TRACEFS_OPTION_RECORD_TGID,
+	TRACEFS_OPTION_SLEEP_TIME,
+	TRACEFS_OPTION_STACKTRACE,
+	TRACEFS_OPTION_SYM_ADDR,
+	TRACEFS_OPTION_SYM_OFFSET,
+	TRACEFS_OPTION_SYM_USEROBJ,
+	TRACEFS_OPTION_TRACE_PRINTK,
+	TRACEFS_OPTION_USERSTACKTRACE,
+	TRACEFS_OPTION_VERBOSE,
+};
+#define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
+
+struct tracefs_options_mask {
+	unsigned long long	mask;
+};
+void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
+void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
+bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id);
+
+struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
+bool tracefs_option_is_supported(struct tracefs_instance *instance, enum tracefs_option_id id);
+struct tracefs_options_mask *tracefs_options_get_enabled(struct tracefs_instance *instance);
+bool tracefs_option_is_enabled(struct tracefs_instance *instance, enum tracefs_option_id id);
+int tracefs_option_enable(struct tracefs_instance *instance, enum tracefs_option_id id);
+int tracefs_option_diasble(struct tracefs_instance *instance, enum tracefs_option_id id);
+const char *tracefs_option_name(enum tracefs_option_id id);
+
 #endif /* _TRACE_FS_H */
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 101f389..6e7fce5 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -9,12 +9,27 @@
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
 
+static const char * const options_map[TRACEFS_OPTION_MAX] = {
+	"unknown", "annotate", "bin", "blk_cgname", "blk_cgroup", "blk_classic",
+	"block", "context-info", "disable_on_free", "display-graph", "event-fork",
+	"funcgraph-abstime", "funcgraph-cpu", "funcgraph-duration", "funcgraph-irqs",
+	"funcgraph-overhead", "funcgraph-overrun", "funcgraph-proc", "funcgraph-tail",
+	"func_stack_trace", "function-fork", "function-trace", "graph-time", "hex",
+	"irq-info", "latency-format", "markers", "overwrite", "pause-on-trace",
+	"printk-msg-only", "print-parent", "raw", "record-cmd", "record-tgid",
+	"sleep-time", "stacktrace", "sym-addr", "sym-offset", "sym-userobj",
+	"trace_printk", "userstacktrace", "verbose" };
+
 static int trace_on_off(int fd, bool on)
 {
 	const char *val = on ? "1" : "0";
@@ -107,3 +122,232 @@ int tracefs_trace_off_fd(int fd)
 		return -1;
 	return trace_on_off(fd, false);
 }
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
+enum tracefs_option_id tracefs_option_id(char *name)
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
+bool tracefs_option_is_set(struct tracefs_options_mask options, enum tracefs_option_id id)
+{
+	if (id > TRACEFS_OPTION_INVALID)
+		return options.mask & (1ULL << (id - 1));
+	return false;
+}
+
+/**
+ * tracefs_option_set - Set option in options bitmask
+ * @options: Pointer to a bitmask with options
+ * @id: trace option id
+ */
+void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id)
+{
+	if (options && id > TRACEFS_OPTION_INVALID)
+		options->mask |= (1ULL << (id - 1));
+}
+
+/**
+ * tracefs_option_clear - Clear option from options bitmask
+ * @options: Pointer to a bitmask with options
+ * @id: trace option id
+ */
+void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id)
+{
+	if (options && id > TRACEFS_OPTION_INVALID)
+		options->mask &= ~(1ULL << (id - 1));
+}
-- 
2.29.2

