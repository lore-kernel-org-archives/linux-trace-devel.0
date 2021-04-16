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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFACDC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:31:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C761261073
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 13:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbhDPNbl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 09:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbhDPNbk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 09:31:40 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2010C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 06:31:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id p6so20001297wrn.9
        for <linux-trace-devel@vger.kernel.org>; Fri, 16 Apr 2021 06:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T1/Frr8X7Gtr9rKNQ2r3dKbh4IG0Htw9Y4S/VM5n4eM=;
        b=GXTtbG/WmmRHQfxMapf789yWCXIv/hLlNTvJYdcxLfEB3irn3TlFTTcKqe7cuGopKV
         YpBCapilVPDiGJFoPeQzTaLS74hUxaZWJoqvf4iVyfMUEM6uicZkNqSA0662lQ41Ofzk
         5DG46XmAkkogVnwI6xxEdGWbqCjKdnu7Sl6TfqAeFkVc9PRmIXkxgZEYoR+AKwEuGiO2
         LqY63/xySnx9GAVkZpGePdLn8r9tEl5mbpO54+l+7/ozSh3i2vCeZNXhYnGl573WeuY8
         Fk4rLMj5No4EI8jqAl6NjMfDaiVr2qMUbiWt9bM+LvXGQFUILIDTdH9w7WsLuuDisruU
         dx3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T1/Frr8X7Gtr9rKNQ2r3dKbh4IG0Htw9Y4S/VM5n4eM=;
        b=siCvY+xkTVs2EXrXzJIQROTidSuXySoEoQsGM0A+vwEKRnVH99HN7WVG9gjSEtqIhm
         YfG58XZArx29cpVkf2Jra9yTijs6tzRSsC4fKQPl21YhokN6eVLIXmn/hbOjtotihvqk
         q82TrX4vVzVKmzNIBgcRhfFie9O4GBGd4e90evcrcTYrGsoqRZq25kZmYAASO+WbgDJg
         PhzTxQHPthapaeQrB7ZCa2DAB16FBa+rQEzUj8J1rJU7jFT0uePdj+/KRb/dh34MvMqM
         mWMcRJa3x7zjSwSTTXDlqaWUW/JyCLGeVo2DAi5IfWJwHIfrrJP//W7DMCxdDqxG8PCA
         oXkQ==
X-Gm-Message-State: AOAM530XdO+0t2sEe0YKRmC8gC0CG/6VTxQWWbqgE1qYYBcpa93QLGB6
        vjHQUoAokBbrKwnS2IozuEmB797Ql/2xpw==
X-Google-Smtp-Source: ABdhPJwLW2EhBM1crnNQVnVohbIN6h2Bo70QUOMQCOUuQxCYpgGZd9ZU9iqZDfXxLwp+UqlDBdPqTQ==
X-Received: by 2002:a05:6000:186d:: with SMTP id d13mr9201963wri.199.1618579872509;
        Fri, 16 Apr 2021 06:31:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id c8sm8838862wmb.34.2021.04.16.06.31.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 06:31:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Check if file version is supported
Date:   Fri, 16 Apr 2021 16:31:10 +0300
Message-Id: <20210416133110.47044-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading a trace file, version of the file is ignored. This could
case problems when bumping the version number because of changes in
in the structure of the file. The old code should detect unsupported
file version and should not try to read it.
A new trace-cmd library API is added to check if version is supported:
 tracecmd_is_version_supported()
Checks are added in the code to ensure not trying to read trace file
with unsupported version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 10 ++++++++++
 lib/trace-cmd/trace-util.c                        |  8 ++++++++
 tracecmd/trace-dump.c                             |  7 +++++++
 4 files changed, 27 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 56f82244..f7c1fa10 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -42,6 +42,8 @@ void tracecmd_record_ref(struct tep_record *record);
 void tracecmd_set_debug(bool set_debug);
 bool tracecmd_get_debug(void);
 
+bool tracecmd_is_version_supported(unsigned int version);
+
 struct tracecmd_output;
 struct tracecmd_recorder;
 struct hook_list;
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 991abd5f..9007c44e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -117,6 +117,7 @@ struct tracecmd_input {
 	bool			use_trace_clock;
 	bool			read_page;
 	bool			use_pipe;
+	int			file_version;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3175,6 +3176,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	unsigned int page_size;
 	char *version;
 	char buf[BUFSIZ];
+	long ver;
 
 	handle = malloc(sizeof(*handle));
 	if (!handle)
@@ -3199,6 +3201,14 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	if (!version)
 		goto failed_read;
 	pr_stat("version = %s\n", version);
+	ver = strtol(version, NULL, 10);
+	if (ver > INT_MAX || ver < INT_MIN || (!ver && errno))
+		goto failed_read;
+	if (!tracecmd_is_version_supported(ver)) {
+		tracecmd_warning("Unsupported file version %d", ver);
+		goto failed_read;
+	}
+	handle->file_version = ver;
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2d3bc741..bacc47d1 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -582,3 +582,11 @@ unsigned long long tracecmd_generate_traceid(void)
 	free(str);
 	return hash;
 }
+
+bool tracecmd_is_version_supported(unsigned int version)
+{
+	if (version < FILE_VERSION)
+		return true;
+	return false;
+}
+
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3f56f65a..8e74d8f5 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -10,6 +10,7 @@
 #include <getopt.h>
 #include <sys/stat.h>
 #include <fcntl.h>
+#include <errno.h>
 
 #include "trace-local.h"
 
@@ -145,6 +146,7 @@ static void dump_initial_format(int fd)
 	char magic[] = TRACECMD_MAGIC;
 	char buf[DUMP_SIZE];
 	int val4;
+	long ver;
 
 	do_print(SUMMARY, "\t[Initial format]\n");
 
@@ -166,6 +168,11 @@ static void dump_initial_format(int fd)
 		die("no version string");
 
 	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
+	ver = strtol(buf, NULL, 10);
+	if (ver > INT_MAX || ver < INT_MIN || (!ver && errno))
+		die("Invalid file version string");
+	if (!tracecmd_is_version_supported(ver))
+		die("Unsupported file version %d", ver);
 
 	/* get file endianness*/
 	if (read_file_bytes(fd, buf, 1))
-- 
2.30.2

