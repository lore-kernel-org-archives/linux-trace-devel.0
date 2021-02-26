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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1D1C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C1C64EEE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 12:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBZMN7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 26 Feb 2021 07:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbhBZMNw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 26 Feb 2021 07:13:52 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4A9C061786
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:12 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id h10so10647096edl.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Feb 2021 04:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JC8VCuGUrXIqpOlYclXrHjQRJT3leND0pE/WdnqdN44=;
        b=DSq9t12nFyOAhwjBS5RsqDPLRZJyFNpyzvUbAnHfeYKOH9248hGlupo3VXCog6g4Hu
         LDcYM28HobL6llBm8QXtKhgQYGRKba83gu31JN39TmmUBR1vTAxgafBIp7eGyobM8k7K
         jI0U4Ne+6ww3QhcnsmL71hAoch/gx8pG5RqUA4jPaVzTQ3T5JMbVczWs6DIC70w1AewG
         h2lWhi/LM14lf2FqvwZi1dCBcLIitzhxYpjq7k/LeMbsXZsOVQKuIx4wWFvYxEVzorDH
         lvhtX31EFLle1hBtY0uWKheQC9MznlkercBS3VibNlaKNKXnWlbAIgHoLHGQ1+5lzVGj
         XVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JC8VCuGUrXIqpOlYclXrHjQRJT3leND0pE/WdnqdN44=;
        b=ot/XANEsGykYNf6Dafpkb2gqYGO7CJRLAaDTvZoxmV5x6w2WPJguis1DnTEz9okOaP
         ZI/iKSdsAikGDn/aPc3SxB8/EgSd4Gz/lpE0IB9prScOV4AmIRYUjhVX7CoUZWYHYIza
         MsdlrHIwYmmFonQJv+MqhjEDrKR/bIgaBrN2GII9Uv5oKB9YC2mGfa3Y7c2AepEiI7my
         nsGq2PPnzFV07YJg2vkO6cN/uLYL9tcCOJD7m45D+Iu7EHsRUOLq/oVaKIclObhdgG0K
         A8x8T+h3eXpoiA2kKy19e/2BajuLBPrXYQ6WzOW8fvYd/n4hkbsa6oJ/FCqAjfev0hfQ
         dNdw==
X-Gm-Message-State: AOAM532bWUJk7zxyTSTVjVt4EInByaKWFP3aWK+NkVofcGMb0kCRr4ho
        Sk5jeMMujpkDUCo7T17SL+8=
X-Google-Smtp-Source: ABdhPJyAHBA9IHzSF58LFNgr5JRCrrkByPROtY7algC+nbQ+o0EjitoWQyO13VEArks4st6OZr2YEA==
X-Received: by 2002:a05:6402:4391:: with SMTP id o17mr2955655edc.196.1614341590840;
        Fri, 26 Feb 2021 04:13:10 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n2sm5266773ejl.1.2021.02.26.04.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 04:13:10 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/5] trace-cmd: Do not use trace plugins when reading partial trace files
Date:   Fri, 26 Feb 2021 14:13:04 +0200
Message-Id: <20210226121306.216757-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226121306.216757-1-tz.stoyanov@gmail.com>
References: <20210226121306.216757-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_get_output_handle_fd() is used to open an output handler
to partially written trace files, in most cases with no tracing data
yet. Loading trace plugins when opening such files is useless, as
we are interested only on the file headers, not on the trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index b087f5fa..e1571814 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1422,7 +1422,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 		return NULL;
 
 	/* get a input handle from this */
-	ihandle = tracecmd_alloc_fd(fd2, 0);
+	ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!ihandle)
 		return NULL;
 
-- 
2.29.2

