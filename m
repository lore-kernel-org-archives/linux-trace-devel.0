Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB8EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F0AD60F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhJHEV5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhJHEV5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:21:57 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2F7C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g8so31244080edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nHOSuhB0J7XLH+XfPxBovuQ6b1IVvyjntZDxi7rkSmE=;
        b=PPfFr2l9tS63wPyHpk7W4eC1fhTBrPg0m/IcXlLq/x/L4tuhKa4JUL/PTsQCRVdcxF
         RMMWwLh0mfSxDFVwGaKcfXMtcbM/XpigwQgWrKNBPfcdibtsXak/oz+dP/uhvMLKIhwT
         u6t5A2esOMCcQBKjvoztL94FM9YodT/aeVixyLuwUDFABAxTGSR7DRbnPawxy5UjISIJ
         ksxc5EVqlzh9Gnl13KgyoEQ16Bx38hkW6u0Cuu7ypuF27tBd5AK4hxS96KEY7v/yA4MX
         BivTdHBeaT9io8HujQw7y20wfXm4txWVLnzBo0poG6+dSYJHALvnzL/0bD9GJCfmh7XO
         NNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHOSuhB0J7XLH+XfPxBovuQ6b1IVvyjntZDxi7rkSmE=;
        b=4Xwm2SCdEAXKSUUS3Kq7e+Z5KUfl0qIlXD1skFAHWZPwFZBef3THQt+TSi6xnloir+
         TcPNQdiE8A4pXPKfPHGziMrTSilnIeMdoARoWrojz7++woeVIxA4/fQJazFTFvSI++sv
         q6IUF3/7p+JaZHOxK8R7EaVQt8t+gt5i/+GXWoK5ix5XrZTy4dz3EC/Ep5uqayeblB9N
         HYx2p1u2EerszVH89aP5sqykrpTTddAPTuiaFhkwujCde5hu2/pe5D9rJbt9v7Tnc5jm
         cF3MhmQ7rZ8MH8QXTv/5vBFnQ4JOxoZCNa4J8M1+b2Dwagh4/bW3ndYKt11u5JAGDClP
         MCHA==
X-Gm-Message-State: AOAM532DTHVnl88c9KL7Is2VKju1wjdFGRINy7HqLYdnv3MfuyE4krFJ
        7neNkfXu+XDLkU+OHjpzvs9zJZxQTuBk+g==
X-Google-Smtp-Source: ABdhPJx1ZPX5FvIxQPrGkoXGD5vIgcziIxHuT/rS8QKmdXbLYzmLt2Ew8imB+vHXi5gTR0ybZvveLQ==
X-Received: by 2002:a17:906:f24c:: with SMTP id gy12mr1316357ejb.478.1633666801379;
        Thu, 07 Oct 2021 21:20:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 01/25] trace-cmd library: Define trace file version 7
Date:   Fri,  8 Oct 2021 07:19:34 +0300
Message-Id: <20211008041958.976309-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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
index a0d6f0a6..a025c0fa 100644
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
index 248e633f..6c2f5c18 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -83,6 +83,8 @@ struct list_event_system {
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
 	handle->big_endian = tracecmd_host_bigendian();
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 3b2d40ee..9c0f047b 100644
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
index 3a84e116..757dab0f 100644
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

