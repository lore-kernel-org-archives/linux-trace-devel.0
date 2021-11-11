Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD1F4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BB061390
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhKKPGA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhKKPF7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:05:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C14C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:10 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m14so25634499edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1CAu8is3X6uqY86zrUEK3QM/ifPbXC7s1X/vTycEMbo=;
        b=XH+InOS/iP0Y/L0yb+pKFtj8Va6ZViccbUO5PPx3fRMRBff/dv+kRBzkHaMxD+GYx6
         6tHJT9iZHJzzP/aCFw9WB1QwMM77jR1XCgvXXZtHaddxHovp4g0v7QpzBH25CHsnxWdB
         /HOlhJbshp7ZHvHS03afvp+Mos4PUPlGS4gQm1H/F0laHwPJEe72vmygu4CFpIabVDYk
         d0olH8ua8cmS4ZnYpamAskXsc1r5UOSRSrJB16iTDDqGz7sziPQKGMeqKK9cMRGW/1Uh
         2ts8QSPe59MLr9/dJeDQ/mhSrBVFh/bKlhyKeGijN2n7PAwLAEXzKRBWZWdrG3A8vdrQ
         Zt7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1CAu8is3X6uqY86zrUEK3QM/ifPbXC7s1X/vTycEMbo=;
        b=OiUZqAddn2hsltfw82DY4GauOpUNkQlT5XCmJtYgQpSwROSc+svH9kqFfn+mK4LU+Y
         9bOGIa6BU8DR4EZr+HlQ5mPww8q7fZuBfq5iByIKlZmztjFcURS0iDZ32h/GQWnfDNSr
         1epJNqoHgNVls1mkKahI88weiFY1KR3VmobAgLrx5v+KJ8aqCSm6mySspHz2Pb1cFLJ8
         +NjENxpstdGhKcnGbFdInOlLdDbp/gsyHvzpCzDLxzNdd8Q7/p7wCJ/kC37pDs1AMxgW
         3lq7jBd98WL1UnVqORth8+/622HThlcoQsO2CV9DJVjOg8QxwDGDxFIORuxCd05B5F79
         TbPg==
X-Gm-Message-State: AOAM532pTxaQNNepd/vmELuObbTU6KHw9SXOFwuE1ffyZrpBZXRYFPl9
        cyGA8MYr/o85rd8zex0MItoviRhoZSDeHw==
X-Google-Smtp-Source: ABdhPJw2k2Fz+22+2CActZHWod2DKVtUqRV1aOWw0DGGJjuLpRCMzEBM7LQ2ZbpFmoi58hssDmiqUg==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr10609096edv.162.1636642989099;
        Thu, 11 Nov 2021 07:03:09 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm1737826edj.63.2021.11.11.07.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 1/6] trace-cmd library: Do not use local variables when reading CPU stat option
Date:   Thu, 11 Nov 2021 17:03:00 +0200
Message-Id: <20211111150305.85943-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150305.85943-1-tz.stoyanov@gmail.com>
References: <20211111150305.85943-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a local variable to read all CPUSTAT options assumes that all of
them are in a single option section. While this is true for the current
trace file version format, this assumption limits the design of a more
flexible format with multiple options sections. Use input handler context
instead of the local variable.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index df2e42bd..e890f246 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -133,6 +133,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	int			file_version;
+	unsigned int		cpustats_size;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -2653,7 +2654,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2735,12 +2735,14 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
 			if (!cpustats)
 				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
@@ -2810,8 +2812,6 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
-
 	return 0;
 }
 
-- 
2.33.1

