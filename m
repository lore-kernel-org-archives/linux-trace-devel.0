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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324F0C49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 156F261352
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbhFNHwj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhFNHwj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5BCC061767
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ce15so15022963ejb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K/wi6U7hzPtl4la0xaLhqgtGsmlwcZ2Gfg6Lcb4Uo4I=;
        b=MCXDc4hyPCmO7+2hpgCdHowZwmARcJNrHYomUI1iXwuEKJPVgBZW0JyIRaeZM9sTZr
         xuEAUdgTUHlcBSoy1S3p0/8mm5O+UM/iMlxqzdoJGVoQB5lp7NoDi2lwspJfemIfXFA+
         yyGyPPeUXWse42+SOyg4olljS6LDs9mJ8pLz5o4V7pljEPE6v2S4VpWWRfmLKxodXqSe
         xV79LTHAP+dYZsWQap+BbR1dg/Jkl2ZGDzshKgDr/MeHv1UqUey16kPtoasYIY//neR7
         H+uuVrJHxbYpaaLAS5nbi6XpbNMlvRHLGw30bY/vDCpiTpZJ9jQetvNZS1MKuYCiKq54
         WlPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/wi6U7hzPtl4la0xaLhqgtGsmlwcZ2Gfg6Lcb4Uo4I=;
        b=QqGSLcRc0l59WVvf92FtpQFi7dlvgzFB5HeIiUkz1Q2E+JGCFKaUzrzce4AE0YI1oC
         775ZIj6JWBU9MIueTnuU4wOI1vHUYKVWUmwBac9A/F2dLM4lx0ntgOT6IG3+Ab2mq6W2
         CHWiMW+J6nO7hYsitnVSkzikCg3D5T026O7pxOxy3diagMksSh8gQhRo91muUDxHHgb9
         vRsRbxGwNAumPnIdaJ1mX4PHnEpB9le8nCMlsXoDNqwYPaFdQj9DE6L4vaapjGsQcNsd
         PTTMtUjb7YMocs1ISnucwVkZHyE0Vo7EfM42LaXaR5ON7Th1br15hwlW7KKVIAR5oODF
         JWBg==
X-Gm-Message-State: AOAM533l1jaIZx9IUe4JribhVuqkYOsrj32oCUQ8+H+V7CLOceRrOPWP
        h+Dr1mZHHR5DvnOZTyEY5LJQXIjsHxLpuw==
X-Google-Smtp-Source: ABdhPJwmxeFFKrPZLnh8xhfXca/5CfBAtrWrDUJFFnpf7BoUwHvkjxik24hX1rgOsOrIM0i6QR+xHQ==
X-Received: by 2002:a17:906:5488:: with SMTP id r8mr14260199ejo.374.1623657035620;
        Mon, 14 Jun 2021 00:50:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 04/45] trace-cmd library: Add new API to get file version of input handler
Date:   Mon, 14 Jun 2021 10:49:48 +0300
Message-Id: <20210614075029.598048-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_in_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6fc18938..01b12c47 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 97ad0a5d..46619ac7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4046,6 +4046,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_in_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_in_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1

