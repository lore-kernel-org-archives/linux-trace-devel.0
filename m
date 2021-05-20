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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D096C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526E561184
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhETDV3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhETDV2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:28 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED30C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a25so17633660edr.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n4BM1BOF4S5lHeHaOEJIuOPiyiWwnSuhagC/nfywwWE=;
        b=onsieDlzy5j6PxXiH2lZb1B2H1RArntGf67hAyzkO/Lv7ZnO76IXviDvcSM0ihurpO
         wEo+4oIiWqur1KSlXfC2YEYSbEbdaYsc0pTeRNPxkGz8TNp5B5+m6qI8S1OP1eeKnIRe
         a3cA94xcjRc864FcM+erZAE02MPw545G8Mg/ALG+ZmRnCf5JBJWS23LrZQdxINf2UtcL
         vl1/9M/nGT4ndXhPpZBnTtjzFjHMEoDct37pI36PSklyFy1NQd8sSdbHvJljwZZX+Uc3
         bER5SmxLLvDsKE3Cf72T3uy6pbtj7Y1rjkWj2+xy7couznywuktYKABAGfIU6DVLuctr
         iupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n4BM1BOF4S5lHeHaOEJIuOPiyiWwnSuhagC/nfywwWE=;
        b=UiwdjOygLUFO9Z427q0eGtRTSVYtyh/K+7D7h6BEALgeWzZdIFAU0+PW8EhiG3zLpT
         A6Ja3l0olvdZMI1eQFdZXcMZf43DbYKUKxRyJ3ACFlpohi7dYYvTmYiFu0VtUxTOcawA
         /QjfIhU3dRvPds9bM/0m9tXXf49657m3Wh4WPb4IV97cSeRtKlCKAu3eoewFz29z/Wo1
         UKFwAyzTlSJWAC3CcDUP3htQoWCFg1+u36Smuo18tQe7pTqRp8CQTdQEnGdblUdYwoQY
         +DsGMXkj0OyLTC78nJJEfqMxKfk+4YM+pDXhZd1mcpUn+C6m93NDCkmEwpwipT7yMM7g
         JcsQ==
X-Gm-Message-State: AOAM532YfxdUggofU/mo4UdEJnhF7BYZnX4BOllIsxxMqneXhhaIyzCT
        QFOyDTKD3j9r5zd33xzLJ+P4RYYuOQ/r1Q==
X-Google-Smtp-Source: ABdhPJy05fb2kAuCHmkvX+0JBEEvFdQBX2bIH3nvF/a4/yJpapYp5YOLO72o87oKtIQX+6veTPKNJg==
X-Received: by 2002:aa7:db48:: with SMTP id n8mr2583170edt.11.1621480805758;
        Wed, 19 May 2021 20:20:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 03/29] trace-cmd: Check if file version is supported
Date:   Thu, 20 May 2021 06:19:33 +0300
Message-Id: <20210520031959.346165-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
from unsupported version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 10 ++++++++++
 lib/trace-cmd/trace-util.c                        |  7 +++++++
 tracecmd/trace-dump.c                             |  7 +++++++
 4 files changed, 26 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index ecd172ca..136057b4 100644
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
index 5ee69b14..97ad0a5d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -131,6 +131,7 @@ struct tracecmd_input {
 	bool			use_trace_clock;
 	bool			read_page;
 	bool			use_pipe;
+	int			file_version;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -3269,6 +3270,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	unsigned int page_size;
 	char *version;
 	char buf[BUFSIZ];
+	unsigned long ver;
 
 	handle = malloc(sizeof(*handle));
 	if (!handle)
@@ -3293,6 +3295,14 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	if (!version)
 		goto failed_read;
 	tracecmd_info("version = %s\n", version);
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
index b65f9dec..b0c98c72 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -617,3 +617,10 @@ unsigned long long tracecmd_generate_traceid(void)
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
index 98425b98..03cc82b4 100644
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
2.31.1

