Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217F9C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhLJK6s (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 05:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbhLJK6s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 05:58:48 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2CCC061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:13 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z5so29159653edd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mFu74OqumgfTFgp80oaCOf7UcNefbnUCIVVDYQM7P5g=;
        b=Aqh+zr2V7py9ToS/3S9nZX9mDIBLiq1Pnqy6KcK2OFCatEK6/1wrBdgZVqhU0rLdOj
         Nj6QbTXSaRxnrjyeM9IcmmgH6t/l0JiVCTuiIiqHnKo8SGHUOBz7NcS94YcroAZsKSdv
         BJi0sImMd981X/+jAcpK7XkE4T4OgCYfH1Hhu9t3yPJPAv/2/vu+vlz18nw68hYqZywc
         hzspzcf5bg+vv49mZZ8zqqK1jfNLksoYsRb3KGN0PDA/2CZRKhZL4znYIpu79nwuISRF
         3lD9Dxido4GtyTgLWRN+jSuZZELjdrqs3h82hl5xNQ6lIFM+Cp0wJA4oXTeBJZeknY1i
         maKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mFu74OqumgfTFgp80oaCOf7UcNefbnUCIVVDYQM7P5g=;
        b=Cl7lU1LrLVp7rI1aElmyE26+CSO7bPkwpjQF93u5swIoPit/L/KtRJBhOOmXQ4ruXb
         hHlV3ONPSHzNxpVWArFfNtHBvkT6C6jzSV5jiBlQ2ptvybb+cafixgXrNsO9x4xpC2e+
         e+lSdw2xAMoGkjSRP9hZCmYnsITJp5onctp05/nDN2XJdFq6O5OIPwutVW/pzKqp40XE
         ev3jzUT261U63nd0Bo9RMlk3/e6e1XeXhMJoJNjUyvpUeppx1JhnO428WFp/GcWVaik+
         Zpp/9L12REw8JDpmzAU7Bm4zgz/O2VFh9T3QY6QJjmcBy6/San/yuwSCJWVNFWBHgrty
         IX9w==
X-Gm-Message-State: AOAM530bqUELzgpyfIZmE1Wg3+IbyiB7AGOz1ljkhoUyRVNI9lP9bw+5
        Dg7Wv6XYLTc1gX5HGIZoJyEiBrTAX00=
X-Google-Smtp-Source: ABdhPJzVg1Tkp+BmOAbVmo19qUhssVfxjPgSiB4Iyfsgs86eTatKqr3zDeJsZwrgAHZebFtE+jKTfw==
X-Received: by 2002:a05:6402:280c:: with SMTP id h12mr38424762ede.120.1639133711722;
        Fri, 10 Dec 2021 02:55:11 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x7sm1306314edd.28.2021.12.10.02.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:55:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 24/25] trace-cmd: Write buffers metadata in trace files version 6
Date:   Fri, 10 Dec 2021 12:54:47 +0200
Message-Id: <20211210105448.97850-25-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105448.97850-1-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
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
2.33.1

