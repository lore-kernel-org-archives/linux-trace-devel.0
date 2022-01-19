Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A8D6C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352406AbiASIZg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352411AbiASIZg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:36 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6B1C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:35 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id j23so2431513edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SUbztSKT+SLSn9t/AeyyCMEBQgpxxCttBQHltz2dzwg=;
        b=KjesvOkDP0Tpm+Ag4r6B+xRHUz6fUoVRxT6QI1dp4jAaWjPnEtmIrTvQzOUrNTcR6i
         kIeV7SwXuXQhNtlgM0NolD6WLXtWbHhlKOd/XgKC2bsJfBQC/6p39VtyHcNl0qlLvBbK
         Bd6nie/u2s1695RDLzosscCDe8LLq7zntQ2L6gzHC2AHqGVL3T3DojPtPAL1Lo+6c0TQ
         66o7SmiXQM4Fm+0ur2WoiP00ldx6HCsrZf16VwHDRrZWykBkPoL46SjzqyZA20Pwc23g
         JXU349gT9jDhbNlu3T7KWNtEWmJOfxBDrMocAsSIi6mYvpm8acbikwn0coDFt6tOqJbH
         nCbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SUbztSKT+SLSn9t/AeyyCMEBQgpxxCttBQHltz2dzwg=;
        b=ga0vXUW8Gm5mEKKy6/21AZYOUr/2Jm5tO+aw+wbxpp2SQzhB89MlhY7omqNlP7G69h
         F7JW0Wbtv+2EMFlvKqOyjGNAiSBxKY2JvwHvz0pbfOFXtOxzvvz5iVyTNV6hGYzE6m3r
         GTK2AsF4BvFGqCb62HfTnrH4zzMi2t40EgHv6Cf65Jv5LKTnjuEVM4qFhaO2Tc7bB6/N
         IFYPOK/elJFG1wn3GgJ2C0SxUhRAl609X9MJ8ukPzGX9FVUj+PcaUxiLMUzM6n38uAG/
         Snl1D5fMZaGu4XSEdsj4pZK7MDCnI8SvY/FdvlUJrCiEuihJeIB1e5GKk6OGOpLJSJU3
         dyTA==
X-Gm-Message-State: AOAM533t9K+fycyVTDKZ3D940v8FFEn6K7rqCBxLOB4+oX7wnc9DQVqo
        pXDlenISWkOtRwIUBvpl5Uwu1VbisDo=
X-Google-Smtp-Source: ABdhPJzHyVulAqm/1Xzx9zIprWXSO18sKo9htqrffJ1TgL0/Y7zIP0mv12E8AzknxlaHaUwK08PyLQ==
X-Received: by 2002:a17:906:14d8:: with SMTP id y24mr3805828ejc.62.1642580734460;
        Wed, 19 Jan 2022 00:25:34 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:34 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 24/25] trace-cmd: Write buffers metadata in trace files version 6
Date:   Wed, 19 Jan 2022 10:25:06 +0200
Message-Id: <20220119082507.245600-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a trace file, tracecmd_write_buffer_info() should be
called, to write buffers metadata in file version 6 trace files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-listen.c | 3 +++
 tracecmd/trace-record.c | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
index 45ba1211..874ecd61 100644
--- a/tracecmd/trace-listen.c
+++ b/tracecmd/trace-listen.c
@@ -604,6 +604,9 @@ static int put_together_file(int cpus, int ofd, const char *node,
 
 	if (write_options) {
 		ret = tracecmd_write_cpus(handle, cpus);
+		if (ret)
+			goto out;
+		ret = tracecmd_write_buffer_info(handle);
 		if (ret)
 			goto out;
 		ret = tracecmd_write_options(handle);
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 2dea79dc..8567ae5c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3729,6 +3729,9 @@ setup_connection(struct buffer_instance *instance, struct common_record_context
 		if (ret)
 			goto error;
 		ret = tracecmd_write_cpus(network_handle, instance->cpu_count);
+		if (ret)
+			goto error;
+		ret = tracecmd_write_buffer_info(network_handle);
 		if (ret)
 			goto error;
 		ret = tracecmd_write_options(network_handle);
@@ -4092,6 +4095,7 @@ static void setup_agent(struct buffer_instance *instance,
 	add_options(network_handle, ctx);
 	tracecmd_write_cmdlines(network_handle);
 	tracecmd_write_cpus(network_handle, instance->cpu_count);
+	tracecmd_write_buffer_info(network_handle);
 	tracecmd_write_options(network_handle);
 	tracecmd_write_meta_strings(network_handle);
 	tracecmd_msg_finish_sending_data(instance->msg_handle);
-- 
2.34.1

