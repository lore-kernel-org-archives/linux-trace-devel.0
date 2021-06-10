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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB8FC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6794061406
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhFJLhs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:48 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:37689 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhFJLhl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:41 -0400
Received: by mail-wr1-f53.google.com with SMTP id i94so1915553wri.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RiwZC1yBs8SQ9z1BwUSlU9j5di5yu+Mv55pgJ5/bATY=;
        b=fT1pr+fmf9fOX14E7zGu8I80lb5GZs55WkvEO/wKbQDuMfj3FwTLQu0M6Pizhxd7Uz
         GVjNbB4miIFJjEwQaRQ1P+kbzW5AEb97EXfgBCyvQZcblKcNH3Vh57UqbhUC9G7JlVQf
         1Te8QNAgv6bB82lXavBoH7jDry1P1CaJsTH5ffWji5LeRBLyZ3fA1cgs4pQ3PxlmeLLT
         jbLpqiqtDDoAijuFYS3IUmdDcjfwkCKVISdZpVc+BdF1AI2fiZsmdWhxN00S0K57Ei8U
         Ob2P+TKh7XitU7SQUoh7qEavGWBLq9paeVj//EVn+lUuyUjljOhLIfavO5eAp8XEZ+IW
         VkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RiwZC1yBs8SQ9z1BwUSlU9j5di5yu+Mv55pgJ5/bATY=;
        b=iJnWvqtyMsOmIFKn2ZVmh91OuZlbhhh9EFHvxLSEUWNuC6krhwFH8UQuf3aAPfsEPp
         fSf84d35mdLahzQtxOo8R10Q8AY+G84wOjZKFDcHF1sKGUvBifzb8gO7llzPox1LTT+g
         LtiJXUtDonjbZwmhfhHqSMp/3FsuUUt7VkruRye83RPyRQqTBW+6MGNqZUaps28x4Sjq
         Z4C8GTwwVhcy4vu3JDG8vhtF9ebi0cgbyAT+ahxPPkBZjwQHa48B+R943H2kKT9udsLD
         CADy68t90ixrXQb1BljRSJy4K8CuU+Uih6belPTJLD0GTBFX0iXfpbpKopI071N5kpXz
         rd1g==
X-Gm-Message-State: AOAM5318bpvjN7sK54KvU+tCaZHuvXw38u6oRGcY4n7A78pUD/NjkZPy
        Ihd2DzeW9W53IhYFgmj4h8drzZiyZA4jTg==
X-Google-Smtp-Source: ABdhPJzRivtwfLGkmepixYhe1bTqgjVepCQJi4joGhzKtMbNxNV0Rhy7P+HucfUBCp20ETfRz8AOaA==
X-Received: by 2002:a5d:4e4d:: with SMTP id r13mr5028339wrt.218.1623324871693;
        Thu, 10 Jun 2021 04:34:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 03/40] trace-cmd: Check if file version is supported
Date:   Thu, 10 Jun 2021 14:33:49 +0300
Message-Id: <20210610113426.257931-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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

