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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7204C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7589611CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhIJNwR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhIJNwQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:16 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E01C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id eb14so2579717edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2/Hx6vPFqVPFH+itREcdetHRc65dK2IElxbnR4WwPME=;
        b=aEIy6JWI/5OmLvaUxieDEwwTkE6KYrwcCW7bth7/X8hA1W3bV+VmPa0jwQLUQ4AcF8
         kPPHAhb3sIkNl0LTk7L8XU7wPUsTpJ8tgNVWPMgAYypZYscRrfM01pkJMbS8m/PYYLtC
         vZKkaHaHs6vn6imDOw27qGnhMjYd1Ca01xrzBRJEh8AZJ4/vLLsnuLSULiB0nBNbs1wV
         wjSX9rCAMxMzDxtel0Np7p4GwA4ZxAaxIdQ7PvJ6F6ZomYWH1ozo2midn1mnp0rVXBpT
         kg0AmmoY+a3SxfPRw3xoB0/oIIaWuEDcZ5kp5G2lXjIDaoUM25K/MFe66gNwIxliytsr
         qjHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2/Hx6vPFqVPFH+itREcdetHRc65dK2IElxbnR4WwPME=;
        b=crC4LQsNZXa2D+bUkHreU/fuD2qYowkphEMwaMZAxJQB9KVlqOSSx7B8ONOhFndyqC
         k9ZvxkM89qWA/57G3v2Zysl4kxcwZVW/2juWlGuRT7ldNrRwH9J4ClYoD+SayqqqIRzs
         BoDk2U8yfhEKNb+t7HMo5Te9Y/zYlzZovpuVh1O0fHcw9rZpg64EThhp/5Wdy4HkvW/Q
         hRRf52X4zCUrjEnzmOHkAFSEBTkHWVMw2VHNPaUY+0mLNEBxvmo+8BBNyiy2omVJCTmg
         RoxvucNEzP5bJNgsD2lJF0oIG1eYaNOLIUdYRaTo3im7Fi7Raw02/eVZNYuyq1vgLh8g
         d7SQ==
X-Gm-Message-State: AOAM5316FK0fQL6/wcxJy9fbFWKnB+0KqTMXAfpLMOXNiED8CCUNSehi
        K7SnjXs9vTK7RsN3D4LMuY3AParsNCI=
X-Google-Smtp-Source: ABdhPJy/Vzs5g0LGRTZOxIAGEo2fyvsvClTxSo/D5u4DrDLKFckVkpXrSAipV5zlGxhj+6bnxwV1kw==
X-Received: by 2002:aa7:cb92:: with SMTP id r18mr9317102edt.282.1631281863929;
        Fri, 10 Sep 2021 06:51:03 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/25] trace-cmd library: Define trace file version 7
Date:   Fri, 10 Sep 2021 16:50:37 +0300
Message-Id: <20210910135101.2865226-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index ad18fa9f..a9a577e0 100644
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

