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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2753BC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 140DB61019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbhG1NdL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236661AbhG1NdI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:08 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3B6C061796
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:05 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id v21so4685059ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbQOJdUfRJzpGeEB/1s2xwAKz7y+X57DsEnL9v3nIzs=;
        b=vhU4Yfh49H/0PIS1aSFHAFE9YXS8u/m+fk/iGTG6NG+hCZFQdCr0NUEuYMWOpOeOm+
         gnvu+XSMbNy5YOa2IW6zkyXXRAMknWn/dLSS0F4N/4QMN3nEcYpRvoJQokmmhvab2CB7
         Tb25dQCksA1aVpmQZKRqhHC0S3oEmMQFH2HTIS6kReyI6cFfj64UpcVBdwl+zoKP5LMR
         VjBdJVuqWjN61+f65faZCupT8puMhmL5md9VbkB6xylHSCcDnCHwt9Y1j63Y3QHUUzeP
         JnHSTfG2at7Vf9vVj9tO+PRCKzbC597RA4YOom45UhzEmgBy23s/whCSYrK8E5GF7MRa
         Z4NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbQOJdUfRJzpGeEB/1s2xwAKz7y+X57DsEnL9v3nIzs=;
        b=IMF8+L24mt+T75VPrWOpxOuV7TiL9OH+lfzxqwYsSROeQIupTZPlXOAxanqc8yfZzl
         8UnPCJc6F6lPgvS91iN45Y0WfRxdae0oVzCXjbOZ4wHUBnp+ApZl6kGsE4NWg/t4Jrbp
         YGbrr3yCBolhcFTsL6LpYdpMhD+ZxKUDEaafgpWIIE99P7P9ThBXWqqacOVVRp8oryb6
         AeiY9DHyHAWAH616ngHfWn9SILw7lbCojcvUDNzIF+HbBouoCTeJanXjMjwe4Gr88rfd
         FY0Z/tuBt7sSpDbZUQ6GSDqFF/GzObyTCT/s6N4JsWQUmLrJCl3E933KLoa4OwagbR30
         /z1Q==
X-Gm-Message-State: AOAM532X6mazPIPAV/pvrc2AnOftPbVSyiCUdrFrbTrqBFJ9M8Uj3YeE
        IYIDsuE6hnvqSMVQlVriQBw=
X-Google-Smtp-Source: ABdhPJxclEB15Cd3qvdIetQ2odxz8UgXbVMz8Y+qY2Bj5tENTvpzD2XAsLovVMOo+814HHoWJv2ysQ==
X-Received: by 2002:a17:906:4f97:: with SMTP id o23mr20874814eju.418.1627479184146;
        Wed, 28 Jul 2021 06:33:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:03 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/87] trace-cmd library: Define trace file version 7
Date:   Wed, 28 Jul 2021 16:31:35 +0300
Message-Id: <20210728133250.234140-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 670af8e4..faeb3de2 100644
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
index c97c633b..7f9765ac 100644
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

