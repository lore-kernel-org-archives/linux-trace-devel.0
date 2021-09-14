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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C518AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A57D1610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhINNOA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNN7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:59 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E20C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:42 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l18-20020a05600c4f1200b002f8cf606262so2058620wmq.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=V9Y3FnQkwto649k6Haw/IZoJP8YREpA1zAcGSN46IwZfy8JTXUmhayM+SxbuyZjKDG
         DHYTy+EEunmY90N6Qp+HU1hgeHcfuaTI/u//GsvtkJiE99F7+MZBbqoKk419JDNJxD8G
         Hpcus81yIPT+LcEdet4vzpyo+4tlioYm5UoxBP639/x3iHiTD+Hj19//dGsnMZeaf9Pp
         6R+FvtyPfGaSJStFyTBupf68dgDY04p+n88Oqz72xvK9SgINxqjb10jIQ9zQoqO+QiOr
         LsJUI5EdUMk7SWnonDGu6sCM5+PjULwxWIF24xmSjo8+/A2lihBnQcE43wK5NAYmqkW7
         IUCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeyT15SqFOCewNiJ5wWZIoGsE6RejnJ66ku3xcCgS5c=;
        b=r4JFpD0/M4GFD0qPz+14ypice868cBoF3ZlyBz1ph0VM0Qd/PB/8FmwsmCkALT1CWY
         3yO89hi3VnhlAp60rmfAKMYUSYvgFwVcjxoPkCvS2zupIX1Xw3UIclrdBkQRav4KM+gB
         EpuYmrj3ppN9+Cc+ainLothd+rD8ydCKbA2y7ypn2gZAYdQTfv05YDA6UE+HkBOz9DJK
         q35AEuXI0s9x7CdMOsfViHgqbcoR2KDpr69kSyJ0ve1Ei+v3SHviYiXLXWITUB3HNSzC
         kK/bfybTiLB/YBHJtFcBEgdJ/cJR0mKQPv/NfmYVItkbYvk40mQmbzkkVMyJ9yPoGCex
         uIjg==
X-Gm-Message-State: AOAM5318xyCRxk1h0F+t2z9sQWilsbq6tTuVOA+XzEdFzpU8C4jDu8kB
        1fj0plVRrirzaxYqNDFSm4atN/GmVHE=
X-Google-Smtp-Source: ABdhPJy9Bs6OviwvLf5ogcQwSKX4fqIMbw0/JakowkPRyN7pbfbjrthBnc+tDkUYWHmtRRdZ8Laptw==
X-Received: by 2002:a05:600c:3790:: with SMTP id o16mr2130105wmr.157.1631625160692;
        Tue, 14 Sep 2021 06:12:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/21] trace-cmd library: Do not pass guests list to a buffer instance
Date:   Tue, 14 Sep 2021 16:12:16 +0300
Message-Id: <20210914131232.3964615-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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

