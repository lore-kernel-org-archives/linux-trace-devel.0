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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2483C48BE6
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A76D61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhFNHwj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:38 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BFAC061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id s6so45187695edu.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RiwZC1yBs8SQ9z1BwUSlU9j5di5yu+Mv55pgJ5/bATY=;
        b=sGSJoTy0SCqAzTU/GK5DRHpuaMY7B6dtjYBJEZUExFpEGSL+awarkPikl8xYmrGQuh
         UJKT4LTnzNbjIEu4yggZXWl12FykwnfOyYKWY1wzhtPI3Z+X1fDD+yyi4gjRA5lcm1a9
         Bav37EgzvxIDNI+0OPVfrXJ3E80ff/QuSLwHpCCrma1Wccpdx58pcCuEcnL/uyPG7FZj
         9/EU0Pa6qmruTKrtYQ7IPClBnBTy6bb6sB2cPujh+t+TGXT43HhOTu4d06gWNYntBD/k
         oG0WWOH0UT+Z20CnExOUgsmPFKNAF1hDIYyb554q+RxZ1f0xog9Oeh6hClfINLpafL1J
         A9Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RiwZC1yBs8SQ9z1BwUSlU9j5di5yu+Mv55pgJ5/bATY=;
        b=Xr8iY0LWvjIXzSnK41QC8NrDi6w64DQ+Lk/ka8NdL6KloF7LWZp5R+AQzNQeTSZa+P
         y7jhDBKwkXNYt3c/+HNB8e0FW+mPk29HE+v84NZGSiUlQHbjj/uteDHRGmygiUm7VOhB
         6LSs1HA+HkI4mFFWo+UIIoMj6+KIP1O9/kqVSi6t82dFjDb1So2Jma+xetO4e8Ua7FVj
         cW/PZvcmItuJNR7C7XU60DmFkAKnozhZPEej0pRjo/JadP0CZlwOJtfBwAYisZzI4X4m
         J8CVboXpzFF0085rI3LNaABXjgPMNS+AQAg9l+Wfu8xCJc0Cr7l7bNTwar/6xDNSvkh5
         nF9A==
X-Gm-Message-State: AOAM532UturMiHKJMxIJBQEh9C6jyGMJ6RJyR5bfxWep0gFOmhfZXOje
        EtzgplYgP70nmN0z/1jqLEeP8BtKqK3zMQ==
X-Google-Smtp-Source: ABdhPJyorSvqLD7IggN+XFxWwGwgPBEL1PrGp4bzcHMTkBFfFEEA1cFrBsaoIN7oQsApEcgRzZB2/g==
X-Received: by 2002:aa7:d785:: with SMTP id s5mr2115550edq.19.1623657034423;
        Mon, 14 Jun 2021 00:50:34 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 03/45] trace-cmd: Check if file version is supported
Date:   Mon, 14 Jun 2021 10:49:47 +0300
Message-Id: <20210614075029.598048-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 49539432..6fc18938 100644
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

