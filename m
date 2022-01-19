Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD2AC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352346AbiASIZM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352368AbiASIZM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:12 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D5C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:11 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id c24so5170471edy.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iFXgQn14zZ1pBYi8HBoCz7AWkIK64BoR5fXq1Tc9x90=;
        b=OhAY0FhdJ71QxOIf05ke4MR5M8dYfSbSWHXNuqlD2Xgt5ohWkk3JTzlHOPBIdkZ2Eh
         kHeI76YYaf9FUFBo7XzYlE/Ex7heKztnQrASJ+ALlAqa0dfPCSHSzjEYYLqWYsPoDFLB
         umZbHmunXcWofen11kGtFkQ9OKQcXNy65p1fk0c1+n5hq5fGWMLoOVASwwphj7nvTeOx
         byyQeLEbHb+/L7G2VWZpGratKYvkPbIIpt2iJxZkIoUgBtLAL/kYCdcbNCojztERg/EC
         KGAllgKdAYySUy2u4MOviOETiDuPwctIfrmrNsNsfpF8mqqIBPxMYjDxL4mjukiw/8lr
         VnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iFXgQn14zZ1pBYi8HBoCz7AWkIK64BoR5fXq1Tc9x90=;
        b=FhQzHIWTiSYdXDJPkSgqI+7kgQF6EbiLefFeLxCnjDYL9EKMDa87NpwC6R+R2c1SP5
         OpH8GtPUbeeNX20D01H7x+9vl5CEPECVPpEuuk43SJalk4LpEitN0yLl/g5xlb3ejEvk
         zP7ggDagSPLFgz8nfTnmfCPTVoZuSRb+pKpaI90P12WgkkelF3oZssfE+MudZ+ZyGklR
         L1kfvBxA+ewMpBVvRgTxPX+DLu5gqVxa60G0kphSJIkYsqvpYTD9pe6Z7i6Ghcf1IsO+
         ODAsMy1hqHeGDRNmW8rUCEWoDGcDDjXUwFFGxualkyZPRuZj2NXU+Td/tGAFRqcfe2U9
         uuSw==
X-Gm-Message-State: AOAM532sYyMxED/6/n5Q9zlKDAVsuQJd3DbT+IjuQ3CrLZ0Gojute1g7
        eWM0Mpu4yebQuh0fFtwULzKWoqro9Pg=
X-Google-Smtp-Source: ABdhPJw306PoWKp1Pzqi/Wj9GimMSDuDss6TciQlQJO14vlb+NHUlRsrvDry4Q4cNUUSEt1I7tW6iQ==
X-Received: by 2002:a05:6402:f06:: with SMTP id i6mr28835115eda.268.1642580710435;
        Wed, 19 Jan 2022 00:25:10 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 01/25] trace-cmd library: Define trace file version 7
Date:   Wed, 19 Jan 2022 10:24:43 +0200
Message-Id: <20220119082507.245600-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a define for file version 7, but keep the default file version to
6. Defined the new file version as the first version that supports trace
file sections. A new trace-cmd library API is introduced, to get the
default trace file version if the library:
  tracecmd_default_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  6 ++++++
 lib/trace-cmd/include/trace-cmd-local.h           |  9 ++-------
 lib/trace-cmd/trace-output.c                      |  4 +++-
 lib/trace-cmd/trace-util.c                        | 12 +++++++++++-
 tracecmd/trace-record.c                           |  2 ++
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 1a7d8691..2c9d1452 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -31,6 +31,11 @@ struct tep_plugin_list *trace_load_plugins(struct tep_handle *tep, int flags);
 
 int *tracecmd_add_id(int *list, int id, int len);
 
+#define FILE_VERSION_MIN		6
+#define FILE_VERSION_MAX		7
+
+#define FILE_VERSION_SECTIONS		7
+
 enum {
 	RINGBUF_TYPE_PADDING		= 29,
 	RINGBUF_TYPE_TIME_EXTEND	= 30,
@@ -43,6 +48,7 @@ void tracecmd_set_debug(bool set_debug);
 bool tracecmd_get_debug(void);
 
 bool tracecmd_is_version_supported(unsigned int version);
+int tracecmd_default_file_version(void);
 
 struct tracecmd_output;
 struct tracecmd_recorder;
diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index a0d6f0a6..4f8f1d76 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -9,18 +9,13 @@
 #include <byteswap.h>
 #include "trace-cmd-private.h"
 
+#define FILE_VERSION_DEFAULT		6
+
 /* Can be overridden */
 void tracecmd_warning(const char *fmt, ...);
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
index f5e2574c..a524415c 100644
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
@@ -919,7 +921,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->fd = fd;
 
-	handle->file_version = FILE_VERSION;
+	handle->file_version = FILE_VERSION_DEFAULT;
 
 	handle->page_size = getpagesize();
 	handle->big_endian = tracecmd_host_bigendian();
diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 3b2d40ee..21f1b065 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -618,9 +618,19 @@ unsigned long long tracecmd_generate_traceid(void)
 	return hash;
 }
 
+/*
+ * tracecmd_default_file_version - Get default trace file version of the library
+ *
+ * Returns the default trace file version
+ */
+int tracecmd_default_file_version(void)
+{
+	return FILE_VERSION_DEFAULT;
+}
+
 bool tracecmd_is_version_supported(unsigned int version)
 {
-	if (version <= FILE_VERSION)
+	if (version >= FILE_VERSION_MIN && version <= FILE_VERSION_MAX)
 		return true;
 	return false;
 }
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b4200db1..7b2b59bb 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -214,6 +214,7 @@ struct common_record_context {
 	int topt;
 	int run_command;
 	int saved_cmdlines_size;
+	int file_version;
 };
 
 static void add_reset_file(const char *file, const char *val, int prio)
@@ -5972,6 +5973,7 @@ static void init_common_record_context(struct common_record_context *ctx,
 	ctx->instance = &top_instance;
 	ctx->curr_cmd = curr_cmd;
 	local_cpu_count = tracecmd_count_cpus();
+	ctx->file_version = tracecmd_default_file_version();
 	init_top_instance();
 }
 
-- 
2.34.1

