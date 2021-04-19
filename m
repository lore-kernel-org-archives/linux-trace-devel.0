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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FFAC433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 688586101D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 19 Apr 2021 09:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237852AbhDSJca (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 19 Apr 2021 05:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhDSJc3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 05:32:29 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D832C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 02:32:00 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id bx20so38675818edb.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 19 Apr 2021 02:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d+QZNnFoSVslOFct/uRkPquLmyGPzUwFMniqOWhN0M=;
        b=ahtyvnB9CwVPZl3ManQocRh4rrof/Gs60+L29Db5fxwFXClpmSk/6G+MXtdEP7CnGf
         G9/EwpCh9P9sjkuScDjq4ZGRJRtSp0T8TOM0XpW/2fU9MXptFB/CDb178yMIUd3rr3Y5
         8GEdWuUX+LYFNiqgWDJBZfXhqyv9gzGpf6oD6B55cwfqLpXbhxQ6GIWsHpZ8ST7yjIJb
         U3sqHFFdecT+6BFzPUkl2b0aHQNZTOjpYDl1/sf7MPhkSH9yYLQPSCYmaiInf2v4YRt4
         rqRjkfCM6+CXgGALC/1+1YYKOTZquscu/D4Ah+7Mu6eEotoQ2y8wEJ/6pA79VpKKdQ8G
         sYig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5d+QZNnFoSVslOFct/uRkPquLmyGPzUwFMniqOWhN0M=;
        b=lsnT2bTJc5HFsaNhp6nJLVRX+dyBVRHFtXA7xVA8J1v2MdXjUQYHZzc3HRCSJXPC16
         sNQ6l8doQeHhFDkoCR3ED1xv0ZA4Hft9g0/dN52NaElBdrwCT32SUCwq/RW3x/P8nrPE
         ZeelDhBPbSRhgbVrwX5jePqaM3AX0/T1KYc0WCEzlwfbenGpg+UeVnXyznr8eub1lD65
         5SZbiHObo+fhx0G3owsuZ5W3ErQ4FkxMJbJKxvk06RuJbcWUJTbxqgf0eCULTuVV1mQ8
         Nq7WC9n9mmxKLBc3kVER2ssWrcdwQPm4R0j9n9THfA0uZhvbQjxnv4sL4RJNVE5FnqJD
         cXyQ==
X-Gm-Message-State: AOAM532kbqtuTC+lQ8Giy1odQUlZZJ5urA8aFwEQwCx5NEZuW3bmiduQ
        LntZTBeUUDgcmGWudCyIqSN/umdJ0/Q=
X-Google-Smtp-Source: ABdhPJwvJTYQhbWKjlJGjtabIgHYsC3+N7IZmYlpdMD9zODwUa61nVrcZN7K3vJK2t4Q87OKnw/gDw==
X-Received: by 2002:aa7:da18:: with SMTP id r24mr23587979eds.198.1618824719095;
        Mon, 19 Apr 2021 02:31:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d15sm5327900edu.86.2021.04.19.02.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 02:31:58 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] trace-cmd: Check if file version is supported
Date:   Mon, 19 Apr 2021 12:31:56 +0300
Message-Id: <20210419093156.200099-1-tz.stoyanov@gmail.com>
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
v2 changes:
 - Fix the comparison of the version, to include the current version number.
 - Make the version variable unsigned.
 - Coding style fixes.

 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 10 ++++++++++
 lib/trace-cmd/trace-util.c                        |  7 +++++++
 tracecmd/trace-dump.c                             |  7 +++++++
 4 files changed, 26 insertions(+)

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
index 991abd5f..0de651a2 100644
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
+	unsigned long ver;
 
 	handle = malloc(sizeof(*handle));
 	if (!handle)
@@ -3199,6 +3201,14 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	if (!version)
 		goto failed_read;
 	pr_stat("version = %s\n", version);
+	ver = strtol(version, NULL, 10);
+	if (!ver && errno)
+		goto failed_read;
+	if (!tracecmd_is_version_supported(ver)) {
+		tracecmd_warning("Unsupported file version %lu", ver);
+		goto failed_read;
+	}
+	handle->file_version = ver;
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 2d3bc741..a6fc64c8 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -582,3 +582,10 @@ unsigned long long tracecmd_generate_traceid(void)
 	free(str);
 	return hash;
 }
+
+bool tracecmd_is_version_supported(unsigned int version)
+{
+	if (version <= FILE_VERSION)
+		return true;
+	return false;
+}
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 3f56f65a..aa48eaad 100644
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
+	unsigned long ver;
 
 	do_print(SUMMARY, "\t[Initial format]\n");
 
@@ -166,6 +168,11 @@ static void dump_initial_format(int fd)
 		die("no version string");
 
 	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
+	ver = strtol(buf, NULL, 10);
+	if (!ver && errno)
+		die("Invalid file version string %s", buf);
+	if (!tracecmd_is_version_supported(ver))
+		die("Unsupported file version %lu", ver);
 
 	/* get file endianness*/
 	if (read_file_bytes(fd, buf, 1))
-- 
2.30.2

