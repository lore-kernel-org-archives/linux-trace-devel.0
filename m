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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A068C433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44CB164E6F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Feb 2021 10:35:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhBKKfU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Feb 2021 05:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhBKKdE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Feb 2021 05:33:04 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA759C061786
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:23 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id b9so9213451ejy.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Feb 2021 02:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G4XnnSPEFwz6ybwMmQh5Ff1BkSFr87krInZBmQ1upb8=;
        b=dzjpCg71GBB2Ft83lijuR0NlSix2kzc4Q5ffATxDIwqL42bjEhRAeRGhLJ4WiCPAb8
         BnWGiZDVoBQwZrK/yJ/r08SX3OXQWDL3rg+RoBT4EUDU7VJa9waAzvObrvjGfnJI02D3
         vgGoO7FXvtvxgNXswQ7+sLkqV8/tnveHL20xhS9fIbohPtzQXouZUciV1vXqnQisMsmt
         9NoFrZ3yfKRRJa0BwlVkL99rNog+xPg77Fg/qwo5dvWUWHA0WQwok0O2kb6nGtsyKPPA
         eHtk2QMyW55csal0ZQr+JX7+7xkOlkp2I6LA/BeUb/wSC3YYgqu2Id1OjhsXIXGjzmfI
         XhPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G4XnnSPEFwz6ybwMmQh5Ff1BkSFr87krInZBmQ1upb8=;
        b=A3a5y4NsJ//YnvyhDuR81ETAx3f6CHOZQ2TYGEBTma8Hk4msmZHwvk1Dfiq/0QTdw+
         g6VgcXx2pUy0/2nDvRB6bypsYWOjpRLF02UG3mGcw7/ogjVawSlDlzd+UpG2wqc53E+i
         bNtgeS/yej/zJBT9BtPs0av/dftWMjcZ0lckIENOhSWsMGmYYoQy0rjScM+boGVhaEeH
         ZXXYVY0q6fNKn+VAjCGZKRAkoIUSBAue2MskWNV3GhveVpjyM8TRf8fl30RtliYDp/z5
         BLYBDaTtdXaFdvqVSFezYWg5m+QhZScAUegAKf96FJj3C2gIMZDrE7iLfRp9yimOnmB+
         cIYw==
X-Gm-Message-State: AOAM533pSoi5wHiiCqfz+Cw18RL5juZWiFfZl6rQpkuwzoof2OpArzTt
        bi2/X8zSsth7HFbqd6pNmX8=
X-Google-Smtp-Source: ABdhPJxm2/pS/r6NW/gXwLfFaCA0aGYiY3YTb1a2R2159D/6pQZDzOfRjinN5FmBrgG/J8Hs8iy+Cg==
X-Received: by 2002:a17:906:f259:: with SMTP id gy25mr2351684ejb.330.1613039542711;
        Thu, 11 Feb 2021 02:32:22 -0800 (PST)
Received: from localhost.localdomain (212-39-89-223.ip.btc-net.bg. [212.39.89.223])
        by smtp.gmail.com with ESMTPSA id bd27sm3514031edb.37.2021.02.11.02.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 02:32:22 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 02/27] kernel-shark: Do proper reset in kshark_close_all()
Date:   Thu, 11 Feb 2021 12:31:40 +0200
Message-Id: <20210211103205.418588-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211103205.418588-1-y.karadz@gmail.com>
References: <20210211103205.418588-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function is supposed to close all Data streams and reset the
session context object (kshark_ctx). However, this is not happening
completely, because after closing the individual streams, the context
still contains the history of all closed stream Ids, recorded inside
the array of data stream descriptors. In this patch we add a proper
resetting of this array and its info descriptor.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/src/libkshark.c b/src/libkshark.c
index c57ca01..dc58dcf 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -37,6 +37,7 @@ static bool kshark_default_context(struct kshark_context **context)
 	kshark_ctx->stream = calloc(KS_DEFAULT_NUM_STREAMS,
 				    sizeof(*kshark_ctx->stream));
 	kshark_ctx->stream_info.array_size = KS_DEFAULT_NUM_STREAMS;
+	kshark_ctx->stream_info.next_free_stream_id = 0;
 	kshark_ctx->stream_info.max_stream_id = -1;
 
 	/* Will free kshark_context_handler. */
@@ -484,10 +485,22 @@ int kshark_close(struct kshark_context *kshark_ctx, int sd)
  */
 void kshark_close_all(struct kshark_context *kshark_ctx)
 {
+	size_t mem_reset_size;
 	int i;
 
+	if (kshark_ctx->stream_info.max_stream_id < 0)
+		return;
+
 	for (i = 0; i <= kshark_ctx->stream_info.max_stream_id; ++i)
 		kshark_close(kshark_ctx, i);
+
+	/* Reset the array of data stream descriptors. */
+	mem_reset_size = (kshark_ctx->stream_info.max_stream_id + 1 ) *
+			 sizeof(*kshark_ctx->stream);
+	memset(kshark_ctx->stream, 0, mem_reset_size);
+
+	kshark_ctx->stream_info.next_free_stream_id = 0;
+	kshark_ctx->stream_info.max_stream_id = -1;
 }
 
 /**
-- 
2.25.1

