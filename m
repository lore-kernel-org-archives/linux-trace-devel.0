Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8FF3C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A497C61252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhKKPLd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:11:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbhKKPLc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:11:32 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F305C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:43 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v11so25437500edc.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXQ5Y7LspDwj7wkzhT67NpKvi1WnCdTUt6QhhLF6Hk4=;
        b=gJ6BVEOea4AltqHJJuu0zGE7ZXFwOA21lmul4sYShNTZdWIdhoKnW5Cx35LhQ1xuZg
         FEeN7WXvGD1AVQrVVh5KW+Z9Sp6pO43Kc5++QJ4xrqEF1N25DgZZ2UDE022BQk8OObB5
         E2Z/IIOQjG+mX9DwBU5WKR+DAbh3FQuW21OXN0nHdLGKx1puyfXdVYkNj1l5Mx232x1R
         JvSqXinMh6/2qLMoDsxANgi/77gpYRdnz9MU4lDOF8DejxenE/gUUKKJGDPKn69UO+SE
         Gxu3VxGSXgIXM+9IiDqrVjBZkb3cRvzs+MxZZoKnU8I1zdJ7VXVycyyo/PITw7/L4Dst
         vBEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXQ5Y7LspDwj7wkzhT67NpKvi1WnCdTUt6QhhLF6Hk4=;
        b=lyucPZImjlQSNi2lOXAG5n5+p1uTBMJlUtuKRo8nYkhbrblim7JJNmjcU2P6t52APc
         NtrmpRmqCbBIXXrP2PJW6ofboyh8qfoythPe/I4/IXllmvJ60kzCApfC3kzbhsNRjQuj
         Pmfxe+3IycdR0BoBNPIaakEYYrKO61qxg3DznAqj9T7aomGTlJg31srQpUV6RmolFaeD
         JkVxKvauL6y6sbOqxWmmyYgH+o9qMHQhu2fGCNp03xjBPV5HZ/OLcAyqP+2ltqYmcmMK
         EGQN9tC9b+zlrVrWPOQNJlaJmdQEd1y5lO13Corm41+3/142CiiqoE4EbLyd/5eJL/59
         mCQQ==
X-Gm-Message-State: AOAM5318MCKmB/KqBR5j9zqipK3qMlrXc5dXWm+ZJzk24V0Q4rH8rN94
        MLOEmHEDycSzPj3Yol2wPWjOWoWUYvuaQg==
X-Google-Smtp-Source: ABdhPJwvax1up8SzFMzabHtIgnoxgTsXxwi9b8AE3GTIILXuWnoKRxkmHUqCi/SB9rPJ/Q7SHFZslg==
X-Received: by 2002:a05:6402:518f:: with SMTP id q15mr10672810edd.77.1636643321958;
        Thu, 11 Nov 2021 07:08:41 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h10sm1746465edb.59.2021.11.11.07.08.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:41 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 01/25] trace-cmd library: Define trace file version 7
Date:   Thu, 11 Nov 2021 17:08:40 +0200
Message-Id: <20211111150840.86532-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
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
index 767a63ab..02194749 100644
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
index 6272c0f8..ea7075a6 100644
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
2.33.1

