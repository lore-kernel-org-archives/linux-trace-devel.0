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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B404FC43331
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 839C164F1A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhBZMN5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 07:13:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBZMNv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 07:13:51 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2A6C061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:11 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l12so10674069edt.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BeUL1QLGD7gXLBL1C5c7qtl12Gu5xCBC/LrlzRdIh2E=;
        b=p836aorRwF49RR7LmiZoBE2+EYm6MJZZfwnAK8rn3LNH7tUT5bjpGKOTDRLWH+inMw
         57r3iFOrkGXlu3QLr9o/Sqx8HLMgBdzK0Jrxv8cZKNXxLFJok9RBnAJJ51IcXTEQjKTG
         DB6tGOMMIP+thIzSGgcXQTwKNVKh0cfnFSye3o9VC2CppAfs13iuoqsOwR7wWUzZL5jj
         J1nhmK7F0eUlLYyyrosp02NYeJssdMsMIDXRD4UnkypXyRTaoXJbFX6uOQOa77Y9iYGz
         PyStcAf1B3JVILq36nx25y343dPfA0uP5/RFtsU/YPWoDgBo9LQBFWGY1ksMmKNWDeZZ
         Xqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BeUL1QLGD7gXLBL1C5c7qtl12Gu5xCBC/LrlzRdIh2E=;
        b=cShvu3k1kLvg6rsOPR6pgVFNofq7nWEqARCw6R4Zd+LLZjIH1N7WIFmxDexeP0HbNS
         vAk04UQpjAi6l1fphEflSbY4p6KiO5rhXikYAQZVtcymmFeCvrx40zOufH26ml6qFkQ8
         u9Exkt+0WNYwLydGM6h9x2RwlYCzl9psE6A/e4/sdVzWnx/DenYo8TwigXmoKMJH+w9K
         5ykuzbhoKcWMgJLfP/CSA8Rff7EYaVOO3NPA5ROGRCbW3anHTuSER7++HWm3Hsi6uFbu
         cXXKcZ0RnS9e+rReBsKpEYVRJHV5DCyZWidfB/pc6XEV6qgalL/cP8AabARZOkCJzxRJ
         Wx4w==
X-Gm-Message-State: AOAM5339tyxsD4SMLNWWM0mG8ErahXvfKDRj49Om979NlBdNoOyiU1rH
        3yDMlDDEao1EZLtE+WFJIw0=
X-Google-Smtp-Source: ABdhPJwBwP2+g8QFWEfYXDEPVt/14d/KK0GX8KrXzgUy8odnYC6rUuwooXDXEBSnEX1eQs8QgntBkQ==
X-Received: by 2002:a05:6402:1155:: with SMTP id g21mr2919882edw.279.1614341589883;
        Fri, 26 Feb 2021 04:13:09 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n2sm5266773ejl.1.2021.02.26.04.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:13:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 2/5] trace-cmd: Update long size in the tep handler right after it is read from the trace file
Date:   Fri, 26 Feb 2021 14:13:03 +0200
Message-Id: <20210226121306.216757-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226121306.216757-1-tz.stoyanov@gmail.com>
References: <20210226121306.216757-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_read_headers() API reads available headers from a trace
file. When a header is successfully read, the information gathered from it
should be applied in the internal structures, before continuing with the
next header. This will hek not to loose the information, in case not all
of the headers are in the file. This is useful for reading partial trace
file, used in trace-cmd listener and agent logic.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 76bcb215..2004114d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -782,6 +782,7 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	ret = read_header_files(handle);
 	if (ret < 0)
 		return -1;
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	ret = read_ftrace_files(handle, NULL);
 	if (ret < 0)
@@ -808,8 +809,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle)
 	if (read_options_type(handle) < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	return 0;
 }
 
-- 
2.29.2

