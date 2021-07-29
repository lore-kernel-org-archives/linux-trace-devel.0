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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CD43C43214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECA4D61052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhG2FKR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhG2FKR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:17 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBEEC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:14 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id nd39so8462726ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V9e8J9vDPgVv4rZzvSB1N/0tzTS074J4DavFjtJMvLo=;
        b=uyY0AtkxpJjCtZQA9uRTSWRK/JXxBij2BeaDJsNhg4uYLu/jkto2H2ynV7hVt13Ku/
         lh81N53nDGQ43ViE7sZ/2ZdglkXhhrGp3Ui2xrMPrYk/zdJGg3QZJZTTSMD7kSD2qvVv
         6G/l7kTYj4SJIyuMuOciuZokxWGayBAot8NhInsK5xcdq0Ebu1dN2T3Y2u0mxQnjaZzo
         RDcOv/1Ub6QoaM0MlK0nYOcDJu4v3v7jXW71HaBulxJXcO9IJZEPdwag7Kq1lEJ4VA6/
         S5g2O7k3ZhxLLIHWzOqBa6vkHM4FSgCXT8EIH7e20ac2fHvWqEYUvtjt5LrEv5cSIf1F
         +cag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V9e8J9vDPgVv4rZzvSB1N/0tzTS074J4DavFjtJMvLo=;
        b=cqdx5dE+hpZP+dsg+95vY6LzJExRRoeYSr2tEZEbN55a4zOW/lljydHQumNQ0mIwH/
         ksFre4wUT8HGzI3nqKDfbKgPz7XlpSCybEbJ3Wwbjv/lIbLOzQVeLIKDTPX2Mhwl5beH
         78qeQCxiZMOt2Z8LD8gJPSRzXhDAIQYUKUup+pcL1gv7zJxy+MJHBzL33lbTJ34YkPKb
         DYWfmJ6OhaiG4SsnEOsXijRj+9riEQ3inqTQYjfDAnfDEBppvJXASIQF1SN6PDKmstDN
         z0kwsrhCrs6D+WyX3MskrkiuwnvIZs3S49e2lsxNA7QgwyMMYeeM02d47RnkCN4ciQpl
         agcA==
X-Gm-Message-State: AOAM532C4lEu1cohMgm4r2TTGf4AVDejD1AGdSmD20QibwMzAcX3L6k2
        2s5OVyfiqpfIQMqrLE6N0LH+2Uk+Jrjk4w==
X-Google-Smtp-Source: ABdhPJx+DhTBIjKfsvcj1k0MFi/+d+BT2JxIplHIuYCH74wJsAgUYh+OAmqVI3xkpF3b2G4SH0J6zA==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr3015301ejc.188.1627535413360;
        Wed, 28 Jul 2021 22:10:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/87] trace-cmd library: Define trace file version 7
Date:   Thu, 29 Jul 2021 08:08:44 +0300
Message-Id: <20210729050959.12263-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a define for file version 7, but keep the default file version to
6.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 3 +++
 lib/trace-cmd/include/trace-cmd-local.h           | 7 -------
 lib/trace-cmd/trace-output.c                      | 2 +-
 lib/trace-cmd/trace-util.c                        | 2 +-
 tracecmd/trace-record.c                           | 2 ++
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 72729c57..c3b407a0 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -31,6 +31,9 @@ struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
 
+#define FILE_VERSION_DEFAULT	6
+#define FILE_VERSION_MIN	6
+#define FILE_VERSION_MAX	7
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
 	RINGBUF_TYPE_TIME_EXTEND	= 30,
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 271c55a7..ad3f7e1f 100644
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
index 552889c6..ae35c12d 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -976,7 +976,7 @@ static int select_file_version(struct tracecmd_output *handle,
 	if (ihandle)
 		handle->file_version = tracecmd_get_in_file_version(ihandle);
 	else
-		handle->file_version = FILE_VERSION;
+		handle->file_version = FILE_VERSION_DEFAULT;
 
 	return 0;
 }
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 4e1b8427..00246076 100644
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
index 1767a6c6..9780cedd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -214,6 +214,7 @@ struct common_record_context {
 	int topt;
 	int run_command;
 	int saved_cmdlines_size;
+	int file_version;
 };
 
 static void add_reset_file(const char *file, const char *val, int prio)
@@ -5937,6 +5938,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
 	local_cpu_count = tracecmd_count_cpus();
+	ctx->file_version = FILE_VERSION_DEFAULT;
 	init_top_instance();
 }
 
-- 
2.31.1

