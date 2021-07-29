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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6938DC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 475B260FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhG2FKU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhG2FKU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:20 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3516C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id v21so8497454ejg.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Estd870NraakHStXcUkj5oDHqTId6qDCNYNSfMNX1Wo=;
        b=G2a7r4guJ9A9JJJrqhjaNrqahTl06Cv0dMZSzVRb0r80kqBbayp4wbpRhaNgBxKkhM
         6otuFIi86uH4exvO4RluFKIYTMXh8sBwIkRJmu0iBOcLgppV179N2Dn3YZc5oik2Iz83
         lZUPxWcYKF1caC7gkrWcO9O+mmnG7teRbraO0vovQ1p283D+UL4KU95YLU1xjHs/QibJ
         lGRXeGK1x9szlz8PztOL6IEA/Gjlxd4fZ4PF8Wo3gyW5OVmdfETNopdkHV0ndgd1lnmz
         zZ7yf/M05yzHuaMSUNP9fAAIZks0t0uh3LN2kII3GdYdEoryBL5t34lG3Jy8/JsZC+Bn
         h5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Estd870NraakHStXcUkj5oDHqTId6qDCNYNSfMNX1Wo=;
        b=W9E10qE1oStp1sBq5VF0OujwpvDnRx2rVNo8LxoONihjEv6c1vlWgYdnp4c9RQpSot
         zO4dWqkEHynK0PeQv3J9P6v/RoGs0yPkaBE+q2djuTabz/oqx8bNTub7GBhp7zchHQ0Y
         7oBAQyzF4RM9CM915HE1faUFs90bUv3ioOCmd0JaLCFURipLfuS/JSaidBzv2dnTdeLZ
         fqWYVerQit9hhJKo07IpXgb3zssQan1MNbYM+cz7+xVj93FUM/JhFJn3FOpaNRaZmQLn
         QagHjiRUfWp96QBAthBCwVENugKBn/bWV+XxAR0DSyeFmEsknaCO9zA88Qj5alHNwBkv
         OMSA==
X-Gm-Message-State: AOAM533V8eojw3gBrTPkJkwaNZ7jjJBzrBs0WIipvsqsYAIZtcWWjQby
        tSuzq/Ecb6F09MO58+kCxrM=
X-Google-Smtp-Source: ABdhPJwMcan+ZHlA8XhGIueQr5BPMEGd7Hif3P30x+zXGlilH1gxtJYA8bihXMB5O7pxSI7wXLfyKA==
X-Received: by 2002:a17:906:e241:: with SMTP id gq1mr3036145ejb.87.1627535416405;
        Wed, 28 Jul 2021 22:10:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 15/87] trace-cmd library: New API to get the version of output handler
Date:   Thu, 29 Jul 2021 08:08:47 +0300
Message-Id: <20210729050959.12263-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where the version of the file, associated with given
output handler must be retrieved. Added a new API to get that version:
  tracecmd_get_out_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-output.c                      | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 16dbed56..2fb15026 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -316,6 +316,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    int cpus, char * const *cpu_data_files);
 
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8e402d35..50a91cf4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1843,3 +1843,11 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
-- 
2.31.1

