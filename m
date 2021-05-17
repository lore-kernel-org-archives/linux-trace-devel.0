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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1565BC43462
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4523610A1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbhEQPBI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbhEQO7H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:59:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8A3C08E89A
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:55 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id u21so9413436ejo.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ULNvnvi4EPBXgjFJ6GGT87XhDpqkwwO0rwMfrOQc7vY=;
        b=OUejYcEN7taegVIJhAUXqfiC6yABQ2MVKvh1DHYV97PKqTgerKdvAD+24bVGjFXwbR
         orDyRwPHug+eYFgGd1WgcPM5irExf4eZwZOqzcwlvNg70ZsVleJBJ3tzLD5zAd68ignd
         Zb54ykMiJKwZDVwUx1gjA0HZOkt/ImgbSpL9v7uFgBxqddcY9vRWLzb4s3aOOvHISAlq
         dznObutAAsCqgtSNytPBgOtXnGXwOv79g7EOasvSRs4FPJ9doNhn3wEZtnh3Xj5m9iTc
         G04F3jF86PwtudKZAO+9HWXlf6FP2u2WFzDiyhikBDtN1dHh24TdOPJkpumpmHSiz+BC
         6nYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ULNvnvi4EPBXgjFJ6GGT87XhDpqkwwO0rwMfrOQc7vY=;
        b=Evm0vzwwsXI+8qCv/wNIuLQfJil397k7tBhQWI6GvnsSx43hgHNQ+t4AL8o7UQszjS
         ar/MVQ+IZXj6UpI3b3r/hFbuNOnd2qquxlsGXszWFhn7a3IOFVPdT5UPYeQfZyqOmH/d
         NQGVIBwvQ1RiVbr+xtYxjJ6ratWnQh2+UHOd7gJJ8rP43690lb9vf/Xl2QvSo4gkFbl+
         aRCwBfwqVlEmvNZQQLcUEXhtnfDSnKybbWKohLbXmyq9p9ZDgYcXSOdKQwFdYI3/xsvH
         YI17s+siUHKGjbGou+kxInXR9S0brmNHpCZOrZJhItPdDv4trU2kfDUyN09GWLTpl7oE
         WlFA==
X-Gm-Message-State: AOAM531ByYYwwcjgLCgLkY91ufu4FqrwDB0Bb5ak0qSTHIaBpQq3Au1Q
        DVmwxSGQMPIaSgIqafQLSOupoF6jdjI=
X-Google-Smtp-Source: ABdhPJw44bgDBGqd9WUBWz/MPdGYQhkgGYM+nc8OvdgHRQufA4D8leqqx6fjkEH8z1JPNkp+FwwCVQ==
X-Received: by 2002:a17:907:3f16:: with SMTP id hq22mr190760ejc.20.1621261313902;
        Mon, 17 May 2021 07:21:53 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:53 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 6/7] kernel-shark: Fix the checking if "trace_seq" was destroyed
Date:   Mon, 17 May 2021 17:21:39 +0300
Message-Id: <20210517142140.286153-7-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When closing a "tep" data stream we destroy the "trace_seq" object.
However, trace_seq_destroy() sets the buffer to "TRACE_SEQ_POISON"
which is different from NULL.

Because TRACE_SEQ_POISON is an internal definition of libtraceevent,
we have to set the buffer to NULL in order to indicate that it was
destroyed.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-tepdata.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-tepdata.c b/src/libkshark-tepdata.c
index bc5babb..acc554b 100644
--- a/src/libkshark-tepdata.c
+++ b/src/libkshark-tepdata.c
@@ -1615,8 +1615,10 @@ int kshark_tep_close_interface(struct kshark_data_stream *stream)
 	if (!tep_handle)
 		return -EFAULT;
 
-	if (seq.buffer)
+	if (seq.buffer) {
 		trace_seq_destroy(&seq);
+		seq.buffer = NULL;
+	}
 
 	if (tep_handle->advanced_event_filter) {
 		tep_filter_reset(tep_handle->advanced_event_filter);
-- 
2.27.0

