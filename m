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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42253C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C5B61450
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Apr 2021 04:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbhD2ECN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Apr 2021 00:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhD2ECN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Apr 2021 00:02:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB3FC06138C
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:26 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i24so17256418edy.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 21:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0oxvIo367n5ZcnF0JSYULJMP8eja6XARiF+mak0nbbA=;
        b=slYW/LmduA01pQE68UTDpNnzx1PlGuqBcAiPikPRfBCHCF/pBqAmDzzJueY4GzFI4T
         qwUpPryLfC6qVMJtchrUPFVXGlaQ437dN56rBxRFkv7/IJltb0lziCF/bmp6X9vrhNno
         epK9bq0jEnuBSYB6TTiVWI+Swpp3736GFFx8J9V0bVBv7LfxYzgHwMUVSK9lkYic0rIt
         OzMsjKSrfJ8jwPTZZrocTCbGZJIQ5oRSY8E5p4dq+NXx8FNRd8Kz4uTgmhLajfshqWVd
         ajdlOxQV2/Y990Y22QDIQjWrqBvszMiIGLs9+oJz2dy6WaUoQlYy21jUPjLxz4h9ekJ5
         G/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0oxvIo367n5ZcnF0JSYULJMP8eja6XARiF+mak0nbbA=;
        b=XNBccIfB9/OSxo1UNrOQ8odVwz5cA3bKbYz+JcAMNQ+vmBP9eMKmwTk/rECj2qO3oz
         lX+fkDjHzRZ5+xvo/W14r83mvZFdXvG4LjP0SgX5Mx+FomI/uvfeRoKUumfwtt1QDGcx
         o2ssVN3KLndgmFBxft8HYcdqWOJYrjovm7aVkBtSee9+COmqQn5gCOrtfy7svIazP4hm
         jsIiVxvZAglnsIkXsB0DLiA37OeJGLMmvCs9W5oLzkLqlwGtsNSXnlXcBwY8n3TyqnAW
         UtgyURQxDUIrKttB5dneBAmCenc2uLbir0m/fN8EUYdKni/SDnyeYoPxgkIRHbCnADZW
         IlnQ==
X-Gm-Message-State: AOAM532wv3b7hgZ+CfJqVFT8Lt1YFhGUljnFpWm8ZVvx0R8pNDMzFLSD
        iOVYBdYSNF1TJR4zd4WSQjRCrpjxecx9gg==
X-Google-Smtp-Source: ABdhPJyfzwRRuPnx0eabttE3iuE07LPKCodBEoBlOWy86xvCHR+zhXBswFbHWN+uAfgR9kZrsdD3ww==
X-Received: by 2002:aa7:d705:: with SMTP id t5mr7392830edq.141.1619668885478;
        Wed, 28 Apr 2021 21:01:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z26sm1040740ejl.38.2021.04.28.21.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 21:01:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/7] trace-cmd library: Add new API to get file version of input handler
Date:   Thu, 29 Apr 2021 07:01:16 +0300
Message-Id: <20210429040119.843617-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210429040119.843617-1-tz.stoyanov@gmail.com>
References: <20210429040119.843617-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index cbd8dc1f..29e56271 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index a00fa982..b2a03ab8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4034,6 +4034,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.30.2

