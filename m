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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D507C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1360660F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhIMMbI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239946AbhIMMbH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:07 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1AE6C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id t8so9381895wrq.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stxY2oTkiNEg1LC3hOrVJthZen3reRGH4g54+R0BwvE=;
        b=iWCVPdeo7Lc+RKQ6yVhgDORCa6hsfmQ0gTMCafb5ukhr1tGHGnZ/STHL/dfUbp2nrs
         /6cENBIQ9QIrLGc9ojGT+1q1YEfG+mdB1tImlW0TDjizXkTmkuyVTUhF4qZ99EQJSxle
         O+dpAAOXAwQN8QxOJiSzjHGPFW3pujOYmvMfTORtpXKM0V/s60r9P90qwVLD4Z4RgFaE
         6HIzq3T6BnZyzg5hP2qzCbSv+YdtwiNAjF3Jwbmpcjp9Uqrgx7bdgm9s9FXscUK/Atd2
         5jN5sPq119iUmYN5VApuEBFkKvhXhQCVObKmEwhUb2zwJ3V199qhyv5YT675NGVz+lbz
         eSIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stxY2oTkiNEg1LC3hOrVJthZen3reRGH4g54+R0BwvE=;
        b=3YJGSWHFMEEEir5SqSoyM1RS9upF2ZY4H0BrnsTGQ1mFMgdzqPxSknWjZMp9noLJXW
         Zbze51yHJ6NdWf4Zto10PWPiTY6vAompYeY5W1F80ox0n4p98+J/88MX941xFVHPzZ6z
         +ZxcOLLuPQgpFNalw0dxD34Fy1l08wsTo/VVTzLcXglJ048BAk+eCnxaw0BjYf0HqqeN
         7AxDBjXA+UFjbZ+0nf8XcMs8hj9EaeJaUPExnEbe7DNoI1co6LoCh95ejXheqck4iUhB
         2gCSmrSOEFAfWuJZfHSiI31nGoGXpikjlXGTc5Fth2GxJ6UQaaOQJQKNI0sF8J/JBTLl
         G08A==
X-Gm-Message-State: AOAM533ebO0qoj0Gs2POWuCCdEuaGr17kNQtlsDQ4X07Y4IO1JlqS2Q0
        HxXw5v17MPlZ4xByjTbM6OEI24tofOw=
X-Google-Smtp-Source: ABdhPJyVZI8MPfKdkBQAPfoHL3fZJFv12KIs/15yO9F9JrwFJa1y/Lpf9ifMGKWt7zzQDhuDrltk6A==
X-Received: by 2002:a05:6000:160f:: with SMTP id u15mr12422368wrb.166.1631536190565;
        Mon, 13 Sep 2021 05:29:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:29:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/25] trace-cmd library: Define trace file version 7
Date:   Mon, 13 Sep 2021 15:29:23 +0300
Message-Id: <20210913122947.3673239-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a define for file version 7, but keep the default file version to
6. Defined the new file version as the first version that supports trace
file sections.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 6 ++++++
 lib/trace-cmd/include/trace-cmd-local.h           | 7 -------
 lib/trace-cmd/trace-output.c                      | 4 +++-
 lib/trace-cmd/trace-util.c                        | 2 +-
 tracecmd/trace-record.c                           | 2 ++
 5 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 97cd82f8..e21bc3bf 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -31,6 +31,12 @@ struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
 
+#define FILE_VERSION_DEFAULT		6
+#define FILE_VERSION_MIN		6
+#define FILE_VERSION_MAX		7
+
+#define FILE_VERSION_SECTIONS		7
+
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
 	RINGBUF_TYPE_TIME_EXTEND	= 30,
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 547ee5c3..e11dce58 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -14,13 +14,6 @@ void tracecmd_warning(const char *fmt, ...);
 void tracecmd_critical(const char *fmt, ...);
 void tracecmd_info(const char *fmt, ...);
 
-/* trace.dat file format version */
-#define FILE_VERSION 6
-
-#define _STR(x)	#x
-#define STR(x)	_STR(x)
-#define FILE_VERSION_STRING STR(FILE_VERSION)
-
 #ifndef htonll
 # if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x) __bswap_64(x)
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 59f0e245..f9c0515d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -84,6 +84,8 @@ struct list_event_system {
 	char				*name;
 };
 
+#define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
+
 static stsize_t
 do_write_check(struct tracecmd_output *handle, const void *data, tsize_t size)
 {
@@ -919,7 +921,7 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 
 	handle->fd = fd;
 
-	handle->file_version = FILE_VERSION;
+	handle->file_version = FILE_VERSION_DEFAULT;
 
 	handle->page_size = getpagesize();
 
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index db7ce7ee..d28b6ec2 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -620,7 +620,7 @@ unsigned long long tracecmd_generate_traceid(void)
 
 bool tracecmd_is_version_supported(unsigned int version)
 {
-	if (version <= FILE_VERSION)
+	if (version >= FILE_VERSION_MIN && version <= FILE_VERSION_MAX)
 		return true;
 	return false;
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 78b0f5ec..35d9ee5f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -214,6 +214,7 @@ struct common_record_context {
 	int topt;
 	int run_command;
 	int saved_cmdlines_size;
+	int file_version;
 };
 
 static void add_reset_file(const char *file, const char *val, int prio)
@@ -5974,6 +5975,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
 	local_cpu_count = tracecmd_count_cpus();
+	ctx->file_version = FILE_VERSION_DEFAULT;
 	init_top_instance();
 }
 
-- 
2.31.1

