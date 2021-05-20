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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DDBC433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29B90611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhETDVk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhETDVj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ED5C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n2so22938781ejy.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9zzLZoywnemuYA+f+nKTzbbPz0GVFLrD2sFUUhvin54=;
        b=Y6eQVbtBtAYn0j/PdInkvot4mro6+9KX4HFucC3Ml/WolnhzTuiVJtqnlxy9rZOtkp
         CD00KW9/phZq4CJkcPyu5s6SNI8+QV88F1OufTTEr3zaFGnwQbDuE3DJX4+jdbafAkRA
         krmWI9ZlVsvsuPbP7893Y3GVSJcEjl4EwDw5ddMg/bs5xUXbVrGewxiut1LbF/58dwJ6
         xgjCm2ICcTCGRlsPxfVURJ43nRfrnbkcbPSNiqVhn6xOe8mON6kKb80eIvLhX2SEt3tW
         FbhCQX94Tzec4B8EhewMkQ9txxI2N5xKZqkAYxeVVqOHClwQzKTK6SlQYawqyErOCRwE
         hsoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9zzLZoywnemuYA+f+nKTzbbPz0GVFLrD2sFUUhvin54=;
        b=Y3X/H5yWqkId3g8X0OKopwm2SGq3VkgruzbM6JlMcwzTYb+CqV+Et3jVokWqEcIRui
         c7uAtC6KsQhyi/MYxtF8UFBzSOQEhG+jGwnWYgF/97iR8PFxd5dwKGYRflQH3Mk6vIrR
         M+JRelqPQzmEjBpML+tGr9xO7J+Lacxyqh2sBFcz7YOxss9XPJ3aLP7P0FVwowlxYUuf
         uWIQ/BGLuuS0aIyqy4ZWfJRtYk9cpA5Hexft7P2k9pYxAYlequIz0DucnADr7bRMh/Na
         MGw4yieYGhvUQvG6lDzCOF1nBOulTWLaItHj/iELzJgyIDQFm/Fr7O1u9ZrafcixhHwl
         7aYw==
X-Gm-Message-State: AOAM531sHACx5zhQShIfKCxCMxaj/6FlV0HCmD2BtddDBFjY6/DOiw6x
        fXrHjhAPIVUGDSe8s8uaBKtCBb8hkM0klw==
X-Google-Smtp-Source: ABdhPJygI8Xv+9UoOMoar1vVEHsO6CkRwd7V3gwlTgB5WfY2xfvaSxqfjD7ACtRNeKIAseK6fyuBbg==
X-Received: by 2002:a17:906:6c96:: with SMTP id s22mr2480591ejr.468.1621480815876;
        Wed, 19 May 2021 20:20:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 12/29] trace-cmd library: Add new API to get compression of input handler
Date:   Thu, 20 May 2021 06:19:42 +0300
Message-Id: <20210520031959.346165-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API returns name and version of the compression algorithm,
used to compress the trace file associated with given input file handler:
 tracecmd_get_file_compress_proto()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h          |  2 ++
 lib/trace-cmd/trace-input.c                      | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 602817cb..4265e37a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -236,6 +236,8 @@ unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
 unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version);
 
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1bfa26d7..e32789a8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4148,6 +4148,22 @@ unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
 	return handle->file_version;
 }
 
+/**
+ * tracecmd_get_file_compress_proto - get name and version of compression algorithm,
+ *				      used to compress the trace file
+ * @handle: input handle for the trace.dat file
+ * @name: return, name of the compression algorithm.
+ * @version: return, version of the compression algorithm.
+ *
+ * Returns 0 on success, or -1 in case of an error. If 0 is returned, the name and version of the
+ * algorithm are stored in @name and @version. The returned strings must *not* be freed.
+ */
+int tracecmd_get_file_compress_proto(struct tracecmd_input *handle,
+				     const char **name, const char **version)
+{
+	return tracecmd_compress_proto_get_name(handle->compress, name, version);
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1

