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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB5AC433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DC726198D
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCVKAa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhCVJ75 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:57 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CCC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id dm8so18544107edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gLmHgyv83IrgZDXtaFwHHBDrIsd/4q/WIVuAKAx5xNM=;
        b=MI95kiZmX4Hn0hHH6sTuqj+VZE7UcOZvlMEM3DEam7latx+Ul17q94dGCHKmbsjucl
         rJAuQbyKqa9mCSVbefUiRgsQ9L/932JWZsY6lKTw1j/YikhZLV4ItXcbO0NqE5V/nNq3
         VdmHM36xl5G4+YU0pco50Ss4bPP6Mef6Q9WB4qBP0KhwQeH0NqHUIfFF7PGCcWpO/IUq
         TeQ1FLo3feCzQxRzdjykMFZPPk3bDkK1ohc1jGxda3Xn0unMdukI1v1G3cJfNJnVxPFZ
         soKgxzxO3Zm+ueRMiV7BNN8C1j12ZLSmwgTwvjBwVxUUKEpWqQxE796Xx/7PWadX8qeM
         K7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gLmHgyv83IrgZDXtaFwHHBDrIsd/4q/WIVuAKAx5xNM=;
        b=KaWhMUVqf83mvoISaYZcREo/ValhDQmcZWhiRE4V7Gj5n0rsDDj753zMQ/8USnKH8u
         v6xcjQO6xgPgQaNBygvgR9bBnEN6L2b1KAJ682d/sGX9H2xyWRpo3rlETtFq5DicCtfL
         cK+whKNTxLi00DlFkbWXHMpBtCLeiPnPR0B+E9pl3bdeGws4EntZgGuYZyzYZktAcdDC
         tl7Mg71hpa7sezshDmFCAt8QTyEuNjR+skyVQ4TeUlXdCJJ1DYdV6EAzC4WNes7ZqJ+E
         Tem6AN4Z2rp/kiRrB9ymsI6WaZty4LCPyNOaGTtPlk2wCCyDlpEDsFGegtuRbfdrjopk
         wN7A==
X-Gm-Message-State: AOAM531LbSpKc3to1n9ck4KTe1FKsmeEiNGtGGaJkji+Oz0pYqP1YhDa
        HaJ553itPK6+Oys/sRsRyhIUZCvAut75iw==
X-Google-Smtp-Source: ABdhPJzI84JGIh0noChQNlx8DaXJ2A+KZCrievK/RVo7YTJfBrPrXghub4T8ZYNLWRkxVV3waQnQxA==
X-Received: by 2002:aa7:d0c2:: with SMTP id u2mr24513464edo.158.1616407195849;
        Mon, 22 Mar 2021 02:59:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/18] trace-cmd: Append new options into guest trace file at the end of the tracing session
Date:   Mon, 22 Mar 2021 11:59:36 +0200
Message-Id: <20210322095945.259300-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
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
index 9ae6e032..54e4b6de 100644
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

