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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2960DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F815610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbhINNQA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbhINNQA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:00 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2318C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:42 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q26so20140016wrc.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BZCtjHFPlHFe/7TFK53gM0VIBu7ki6VB+TSybcYxPsg=;
        b=bWXZy9xeB5f61Tix1fDrs+xQaqSWRFN3TClIOk34T4njW7MTyGFvUefRpv94nexBB6
         Ub7oye1WCHcEunFDVyFw1c3Chp7LXVesQGk1vaRHMueDH3CInLlGXlsugXOOYhR4bF6f
         InC52jAWeRVl8lqRcRmJcjof/V70BMYpNMzqgkR+YywoIo+9keAFBpk+OQyQxmrK0EW9
         7fMNR/aRzfhSsT41IXwrDRbDwCuOgBDX2HXRlCUZdAAOft9shF7mtZvMWOMVhSB4gPrQ
         iiBBp/2aPzVak+71T9JIcrlMiitoDg1f9eIYFRBJndzLBfugubtnklm84AzV+8g947zw
         43dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BZCtjHFPlHFe/7TFK53gM0VIBu7ki6VB+TSybcYxPsg=;
        b=KJIPw5tl04ftKsk501KjCW4zI6uKnwdjh6Q7dJZTRZziDgDKBjHUj06zr+bjKTndNE
         Ryv77HWn63xnRBYSr68lW8dcotsOOvpDW2MIdgirqKQV7MxcnryFzNVjO9qCzSvYSdev
         md05oCUHjksPp6xTv2mJtaxNr0uc39Fl3v9w2d+XTOo0VcCcmeW6/tI19ZMj4fCW1Tl0
         jeaK/SR8blPqzHuJtqv1rwz6WjBAOLu01S5x8f58Hp83VE/RkLw5qWzNApETvJWH7W80
         pz+W2nJVramD/tdmBAECdiLCIKN+Vtj+mf8WqAaUmcgrV39wqJ9yz4OE7Nizj0o5jSF+
         1Ghg==
X-Gm-Message-State: AOAM5335uPjeOIHHyQ1B0gLO20uqOvLw3kAr5wxLsjtiIeKquD06iO3/
        m/3yksx9q7/8CtL6PHYVbFw6Kkz4KVs=
X-Google-Smtp-Source: ABdhPJzSKsbBBJ+z6G9140odax+gyAQjrW/o0pppsMxSFevW9IwFEEdt8TFraat5YpOQYd7eKCjOKA==
X-Received: by 2002:adf:82a8:: with SMTP id 37mr19052775wrc.409.1631625281454;
        Tue, 14 Sep 2021 06:14:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:14:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/25] trace-cmd library: Define trace file version 7
Date:   Tue, 14 Sep 2021 16:14:14 +0300
Message-Id: <20210914131438.3965484-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
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
index c1bfcb66..3d7c0e85 100644
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

