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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DDBC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C52BD64E05
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbhCDNMU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:12:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241159AbhCDNL5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 08:11:57 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5457C06175F
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Mar 2021 05:11:16 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id u125so9606346wmg.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Mar 2021 05:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6LaAxiOBg67rcdzSR4uVw9HURB7ZktYlgso3x/oOomw=;
        b=W5IQNORS2Xxy0FKUjrJtWcBDvdqoNSfs7KsuV0NBuFMgW2+50XvQ2BKvASdeqmIpsO
         w5EO9jalGNs0jnvOvsAS7HT95P8ht2MFXPm2jX3xnKmpAXAZd3P6625J5ubQxTNn5w2/
         AVd6CPjCmw1wwvWbBrYzZx3A+zOo7sZgYH43r87WCZZ+iXM3gMX90DeM10qw+zbhBjzO
         cxsg88uAJq1KBUI9a9hcZ1eadlVcVpJnjFw/PtSJYrPbBczs0993zKC9q+en+B9LYqst
         pT+o4+7/4T7hkZUt/MtTSbWqFd0HWWfkgwuUFVna8YW6vurGXzdkLAc43URY6Ncqssk4
         4Bsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6LaAxiOBg67rcdzSR4uVw9HURB7ZktYlgso3x/oOomw=;
        b=TO7nLRofFGKsYBzTbaBj/dCgxhY8ulXY5spGD30gbBt0iVjVOzR5wat/UdiDmmwxvL
         7roJfmMEUtAtfrTSl6FVEY0ZA5U1gma/TXjTBvHjicO8flPVVhwI6ABoK+oXAIj2koyx
         Sy/Cts95Jm6woC2OD1hnuunUBj96IeaHEF67VADOVHfGavDzWyXMLttqmtDxM7/sIpJC
         JwBcpA2L88WNko7EnXNtnJkSXUsswdQKFZRcxQ2dSzeNVtNba0/TFPwJJaTNE444FLvG
         SqS2J3XgMihwZeJE8BkPhkfn3mgDrMQXGw/pmhYfi2yx9qIUaNXEi2fmBwZyHLzl2tI0
         oobg==
X-Gm-Message-State: AOAM532y59hFm8bk2+zahuwp0I6XvQn4yUzV5sxbj3hQvp7lf5hk28xh
        kVJ8E+4tMaMoHtkHiO4hBWJ7UQcbE+XvxA==
X-Google-Smtp-Source: ABdhPJyQfHGQSOJ223ix1+PvSQ5W7ViSXJseolK5O3ZRzMwUYVRFOL1fWldxn9qjp3FEzfa0I+nH1g==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr3912320wmk.98.1614863475420;
        Thu, 04 Mar 2021 05:11:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f16sm35250546wrt.21.2021.03.04.05.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 05:11:15 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] trace-cmd: Enable TS correction by default
Date:   Thu,  4 Mar 2021 15:11:11 +0200
Message-Id: <20210304131112.204294-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210304131112.204294-1-tz.stoyanov@gmail.com>
References: <20210304131112.204294-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When opening a trace.dat file with trace-cmd library, apply time stamps
corrections from the file's metadata by default. This default behaviour
can be disabled with flag TRACECMD_FL_IGNORE_DATE using tracecmd_set_flag()
API, before reading the tracing data. There is also a "trace-cmd report"
option for ignoring any timestamp corrections: "--nodate".

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9ef7b9f1..134f6220 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1167,6 +1167,9 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 	struct host_trace_info	*host = &handle->host;
 	int min, mid, max;
 
+	if (handle->flags & TRACECMD_FL_IGNORE_DATE)
+		return ts;
+
 	if (handle->ts_offset)
 		return ts + handle->ts_offset;
 
@@ -2585,6 +2588,7 @@ static int handle_options(struct tracecmd_input *handle)
 			if (!handle->host.ts_samples)
 				return -ENOMEM;
 			tsync_offset_load(handle, buf + 16);
+			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-- 
2.29.2

