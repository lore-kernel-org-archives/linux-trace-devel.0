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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D916C43219
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 350F1611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhIJNtX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:17 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3811AC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eb14so2567479edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=LaYG8DjKF5Zm+ovhEGKCkZUt2fDVpIpDY6/YLWgrJiuOc8GSwBi5S4of4TQ/zwrrER
         VkDk6G7Vy2mUwUYK+pGdQTU7yHV2b0R1oZaORpJlZjPKq1AoNhilvml0mD2pePch0/XZ
         pLF8DYGZCpvtz+ffhjM62qMnT3NgVzPmHps5vTvjYVf83bpMFIQ7JpyjHdBVHS/E6kmw
         araWoNMZu9xMd4++33SsQv95e9XRNYeHs44ux/rqHk7Gd/xwVWqu68PR5CbUaeYwhMDw
         4ay+w6f1554DXf1MGUWpxHk8sTbdjrLeUBW9ep6AE9Qzpn18B4aMkLOYZSTa/rWtBtY0
         sVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=Xg/rhx5dO0AvkFThoxfQd7z3kiFi3efwgQ20PUDThOCy5wKIQgwMXzHupJ6lsxQNPX
         yf609tYK78Z6AsLNJyq5ZOss4f+cw5zZupNBjVCMQqD+LxwYvqX6+AhyQ8+eCffYzYeh
         F0a/Ay2MhQuluzqGFooLsYPPKldhmagxoyWHQr28uc7ZYHz2yJsjfYuIgLNih5HJ0/At
         5DtLNsq4rRUgqFnVqswMetaHhrnss7Plegr6R5JSma+B7cSu15sMvqyTa8yzbTuuKG0d
         uf62TtHFWw/ypedWAkLNYohr9ivlcF2SL6Utdrjh8cn1rfiC5aAcpDPkyQjYoe3jSAXl
         94tg==
X-Gm-Message-State: AOAM532H8tRVPGBgiljTfPBfblxovHCmrmrBVX8M2+JOVC+CGm2EWmiv
        /Re22rr9l9tNmb4dQ3qcC+6pnqlehp8=
X-Google-Smtp-Source: ABdhPJxEw/GuFA2xvNS//BTHte1OwYRvFUZ5xMu8K0jnT8uL36u8HKJsephzmBYliBpXyXww1vEe5g==
X-Received: by 2002:aa7:c952:: with SMTP id h18mr9222522edt.18.1631281684827;
        Fri, 10 Sep 2021 06:48:04 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:04 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/21] trace-cmd library: Do not pass guests list to a buffer instance
Date:   Fri, 10 Sep 2021 16:47:41 +0300
Message-Id: <20210910134757.2863982-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace buffer is read from the trace file, a new input handler
is duplicated from the top one. The pointer to the guests list should
not be duplicated, as it could lead to a memory corruption on
handler close.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ffe87e8a..e5c8c332 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3966,6 +3966,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
 	new_handle->version = NULL;
+	new_handle->guest = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
-- 
2.31.1

