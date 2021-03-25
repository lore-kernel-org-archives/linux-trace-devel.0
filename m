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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1A7C433EA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8A761A10
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbhCYGli (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhCYGlJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:09 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F70EC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id c8so1078377wrq.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bNPGgh/lMzmMxbBchjr7g7nlX6is0KgzagoVUlvw+ig=;
        b=ZVhc2LD02eIdGseukPJfJW3/gUBRkZcxnzWUWjyEf2U+8mLWzK9SKk7U//JzWnYCWC
         Vc7H0TjLRx14reZpfRvTEdlB+W3vkhkq6DQjU7PZpnGMGuZw7Lee1Up/RMxzIa4L6Wrt
         jx2N38rNCdPpVSZdf0nsvVy9Gfgee6MSnDbCHZyYj5herzeJECCcTr/l+0QJrzMMTNIP
         Xhb6xbA11IhvEuGRGD7NecdJq48af4Z21SQz9sfMOEzRaHzD7zi5/4kzLU1FmYJipQi2
         S/1T7CO3nFi+z501Zz1yJQoPBThNC5qBKxUxpiNdIOwj7zyAceTiGrtzWqg6fFJAVxuX
         SzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bNPGgh/lMzmMxbBchjr7g7nlX6is0KgzagoVUlvw+ig=;
        b=dLkFoilvwZV8N6B7tjli4O3zjoi7kJ6ie5FDtpRa9lD4tBFW6/0ySt6rajM5sntLwf
         ECAglxi6FZEtPjMzkzcCRwwpCXvCFaGWs+nNiTZDUWoS/4Zdl9GEANbs+XAsdPRWhP3Q
         N+zj7VCDteMFw0Oa52pW04DIbC8VJe6IBlBYIL3YOAVGH27+iJveEztA6CGcovjEFlg2
         FPJ9BFl58HEMP18j56w1xLU07XiSvIzlBldtpAD1rt0eXQB4wrl/ONN6Xr/ly8MPIWU1
         tn/LAfgdTcgbJ2VExKppwq68PYwdz476uaufshW645ekCk+XiW68TuI/1OC+KrnzF6gi
         Xkxg==
X-Gm-Message-State: AOAM531FnsO7Hpee+cJTWCN9JxaFtyO446WOS6dN/yneklsSGrIDW5b/
        qvUtI7pccoXLabElV3BOXww=
X-Google-Smtp-Source: ABdhPJzShYOBd7wpTwbM3xR3PawD3U/HFxNU87Til+hMUaG1XfZRvQgAh+6gH7hyWU5iAx0lp0rfPg==
X-Received: by 2002:a5d:526b:: with SMTP id l11mr6981849wrc.385.1616654468087;
        Wed, 24 Mar 2021 23:41:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 11/23] trace-cmd: Append new options into guest trace file at the end of the tracing session
Date:   Thu, 25 Mar 2021 08:40:43 +0200
Message-Id: <20210325064055.539554-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved the logic for appending new options into guest trace file from
tracecmd_write_guest_time_shift() to host_tsync_complete() context.
The guest time shift may not be the only option to append, the right
place for this logic is when the tracing session is completed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync.c | 1 -
 tracecmd/trace-record.c        | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 4c03052d..0097ce15 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -834,7 +834,6 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	vector[5].iov_len = 8 * count;
 	vector[5].iov_base = scalings;
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
-	tracecmd_append_options(handle);
 #ifdef TSYNC_DEBUG
 	if (count > 1)
 		printf("Got %d timestamp synch samples in %lld ns trace\n\r",
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index b7f6f438..4e4ad127 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -703,6 +703,7 @@ static void host_tsync_complete(struct common_record_context *ctx,
 			add_tsc2nsec(handle, &ctx->tsc2nsec);
 
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
+		tracecmd_append_options(handle);
 		tracecmd_output_close(handle);
 	}
 
-- 
2.30.2

