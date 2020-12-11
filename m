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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E88C4361B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 944C223BAB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 11 Dec 2020 15:55:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437709AbgLKPLZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 11 Dec 2020 10:11:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392736AbgLKPKa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 11 Dec 2020 10:10:30 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EFCC0619DA
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:48 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id q18so1847740wrn.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 11 Dec 2020 07:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUWBfZ26wexvniEj7Ku7Ku7CEywO7ZiFvPGFqaZnChE=;
        b=hKQQ+8BLGJFQfC4gD5ikpkyJ6mKHS9+CQJkWEwC/g8k7rYYqQbRqSSVTzTSd8zG/ME
         Hks8qdl3y+DbtYHhO2rf1Dd0VfhHblqw2ZUZh/xeiwUDN5JSndcCR8rLiS77kLxyaTsl
         3TtKb2C2aI0wmu1xqDEH+vojG1HSF2NTnlEB064iD6Af2KfX0HIH6yFlvCqOKqgCobb9
         OuPUa1GSClq3QiAEJYP0KpM7KcTf5SsVyL4vzghKnRvNJ6+RnVJBX0/0ikde5WW93c1i
         YaOc0nu0z+WRcvmFtvTWff4oa9CWpauPCeQ5GxdLKO9e7Zo15bK1Nwelh/h2jAfYB3y3
         zlmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUWBfZ26wexvniEj7Ku7Ku7CEywO7ZiFvPGFqaZnChE=;
        b=ufh6goB8CLYmybu2eQush+K7Hd8CV3fYwpPBNDLqZxKd8NdXj0DF3TDC3AZDoid4yE
         mfYtw8sHoUFfldCOHIdHWAIIQtlBP+ebpxVOtP7Xptsifg+SsDlYmV9ji+O5pxbYFB1B
         wROFtnb1uQzouJWr+PI+Y9ZAx6bAEf5DQlc9KKfWZrL+ZFccfLJLy8KRM/MT/3yZLCRu
         ren834kEqZoe0RIkgNbf4sa/OJg6ZTSxsiqWoGPl70bR7IgnnOfDWdHrviVr43um9rfF
         DGjl4GQX6lvJ0kT3J12bEXNqPj1inCt3Hbuw3G0EM6di2dAEePv74U6SYI3VWODOL3RI
         D6cQ==
X-Gm-Message-State: AOAM533dNCDPzZ/3FT2N6iofhAUFeRAJgni/Ck244Vtnq3vsb22W+Wqr
        hH2t72muLl0Nf54K6t9qAAE=
X-Google-Smtp-Source: ABdhPJwKTy8UODZqVINqROV7nUj7rAK6jywzDuLtywAMt164zhJtZsGR4a6QPDIsih5MAxr21TSSKg==
X-Received: by 2002:adf:ee4d:: with SMTP id w13mr1803998wro.216.1607699326932;
        Fri, 11 Dec 2020 07:08:46 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id w17sm15620948wru.82.2020.12.11.07.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 07:08:46 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v7 30/32] kernel-shark: Do not use the ARRAY_SIZE macro
Date:   Fri, 11 Dec 2020 17:07:54 +0200
Message-Id: <20201211150756.577366-31-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201211150756.577366-1-y.karadz@gmail.com>
References: <20201211150756.577366-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This macro is no longer available in the trace-cmd public header.
Since it is used in only one place, we will just replace it with
the corresponding code.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index 0b23912..5fc1eb8 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1261,10 +1261,11 @@ const char *tep_plugin_names[] = {
  */
 int kshark_tep_handle_plugins(struct kshark_context *kshark_ctx, int sd)
 {
-	int i, n_tep_plugins = ARRAY_SIZE(tep_plugin_names);
 	struct kshark_plugin_list *plugin;
 	struct kshark_data_stream *stream;
+	int i, n_tep_plugins;
 
+	n_tep_plugins = (sizeof(tep_plugin_names) / sizeof((tep_plugin_names)[0]));
 	stream = kshark_get_data_stream(kshark_ctx, sd);
 	if (!stream)
 		return -EEXIST;
-- 
2.25.1

