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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458E8C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1467B61155
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhEJGR4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhEJGR4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:56 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A20C061573
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r9so22729136ejj.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5oBkqkfRb/7DbHtTUlAiivS5Sd8qlVQn/10Ibn2GGcs=;
        b=dVLpTlEFqKPs8FPpW6tLuoUqsQAhITOJslRqvR2TfpVWVdkz6xtECGV4idjMXmqdsD
         z+Rs78c6W/SWoZ0mwhI0ak/ComW6Kw4FEIaK20djnODCxssBXslO1dSiXSRl2uewJp3e
         cZvqPwyscPwAgrAi6qn/GHoVnYL6BOJEQQAjxbZjJOUg/JQbVRW+ZZUc9/Q90cXgWCwN
         gpn9/S4SDFclBXykPnv6p4zB2sBCPbQu1DKmDg9V/w3AaSyBHzmNTYBLKVJZ0pWSciyI
         Cf2B7edzB268vOQ4OZiyy70WzMXiJuLvs2y437AGJBs9HRcg5JvxAEa5k2aVv867idXf
         nEZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5oBkqkfRb/7DbHtTUlAiivS5Sd8qlVQn/10Ibn2GGcs=;
        b=J0LDpjfwh6DayB2G0sm6fN4t8UC3FSes0JWFj78Wf9TCvSz6ofK3CWXSq1skilkQ3R
         Dbkw/KcPFHK4NkTFL1/dZwRQ9JqQXn5GQA6PY1ww2HNf0S/NYdKuJ9UuP/FqgrIJBgwY
         LQziTF4Rq4l+YSh4iG4Tms7sBGogDGx5299tnXWDBprkZa5wEyfqTnlLMdK0lGMFb46S
         dGbd2fE/a3A6NHF7qqDSMQ58PfLebxurTKCvb4BVdX6mz9h74tNsky2SzmwfIJ4Juzw1
         Mi217OiaCiry3sV/rNTs+TPjZv/nu/YOcGBvZQegIsZzcaJi2HnvU7XoXT4QJ7O6uanl
         d6Ow==
X-Gm-Message-State: AOAM53122rpzftK0upivY1LecRtBXIXod0uRYgfkVTApv6I6MI3IfraY
        OkhvzDOrHXAjj7XMbKW6mx/NOsnytIQWow==
X-Google-Smtp-Source: ABdhPJzvl9yO5EpPXrzpg7fpahhNbya4waf81lijWWCePvPMXKzNqSt6TiEEVJEvQGItcESW/WgNzw==
X-Received: by 2002:a17:906:7e51:: with SMTP id z17mr24500042ejr.92.1620627410202;
        Sun, 09 May 2021 23:16:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/21] trace-cmd library: Add new API to get compression of input handler
Date:   Mon, 10 May 2021 09:16:27 +0300
Message-Id: <20210510061636.1794357-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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
index 43a6b014..f3b01db3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4150,6 +4150,22 @@ unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
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

