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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D68C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 191C8613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhELGjn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhELGjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:42 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCB5C06175F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id w3so33333555ejc.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nRqZS1BvJvd5nWIx62PAgM57YEudBnyFXReBCf0NtS0=;
        b=X+wFw+m1trTZy8zQoykhPywhIVrW3HYBp10ZN3JA4i+aXCdrSqmeSFFpSQS1lD+5yq
         AhJI26p//mHK0UNWic0/gqrrhhrJ/DERodCBxJRFBLNGnqiMgkOEs8sZ5O9NNqyfo541
         p9I+8+fKczDDgViwgNiMbniZQFAFhGJnN2QK367uNbLcQaayezxjCHsiO4GL/nUqr5Ju
         L/HuTx0jC+I3GFMTVQnM4cOklIWnI6++JNZuVeR3yJi3F6OweudChJh9QAXqQXa3oS3m
         h2Wnl3PcqrpNCP7FLH0x/LdV4oqstuwrccMGPZ+7MxDTpewS3SuFYD9S4D79XsdIbNzm
         zbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nRqZS1BvJvd5nWIx62PAgM57YEudBnyFXReBCf0NtS0=;
        b=g86rg6DofesN8qvdQ/pgT4ghX/Ev2jsV8hkYZhYyzLA7Xr8INbzyp8H8/p5kXA6l+1
         fUZFA4mc7DMSe44k481NjYOZeHGpXLjpBL5TIpKJ89mhOhrQCmB2Hhf9TqF4P1e91q8X
         VKUETDTiuKTFqjS5wWLcNjY6dAd5T3z0P8wSINAu9vSF34KTRfwydIcV1fBhX373ea+e
         NNiK2hncxq1IGrbFFiIvIJJMxzdLEabrbyzMbm5We7jzOXbNCbcRO2Y+Fzmu15WN1jtO
         8lVL8wcY3njm9D4bXglfP+8LdoWslCiktdl+Dceb5YkrRNbEzdgVk+My0fShMuT2IU/g
         buYg==
X-Gm-Message-State: AOAM533HfpiON9Xs//99lsVGbJa9Y8pRNGM6vSq2Hl72NOzuzJqluhJ9
        1riJqlyS1F0Vcp+ObnXKRKspCmM6szABbA==
X-Google-Smtp-Source: ABdhPJxK1VFdg+3XVnliG3EK2ZxnewTK/eSwFCOASyfVpyZxC+q+7c/H/WSgcQPkHOagyAztW0AJWw==
X-Received: by 2002:a17:907:204b:: with SMTP id pg11mr3937147ejb.433.1620801508799;
        Tue, 11 May 2021 23:38:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 03/25] trace-cmd: Check if file version is supported
Date:   Wed, 12 May 2021 09:38:01 +0300
Message-Id: <20210512063823.324610-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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
index 9726e994..b095004d 100644
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

