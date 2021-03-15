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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FF5C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B54F64E4A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhCOGS7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhCOGSk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05ED9C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w18so15919447edc.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DUvx8Sw0GCOD8wA06mV/AFdvFVKBBzlJ2eua6c1F8UQ=;
        b=eeF6oBfbdI1IojJDz51HBEPs4pj/WLqt4exYtcgq5B4xlirOg4I55CNIDGDgBQYO31
         ZjV/9hYVw6SQ1BAVBKmY9IciU9d5DDV+KfmUfSXt6aR744v4GW0R3wvhpSMrblYKTJpn
         jTRjP7hVASaqjmZ7aSIeRRQjQSTLS8O5BqRTblb8dlinmwED8l7Yq3omWPmypHe3Xshq
         WdqJfG0QPer622QJSdYFoUWdld8S6TMuxLSH2DGizB/6LedjISHTQ/515S5g0nV7CfZA
         VtH43IVf2qUTexAD5m07DQFLSTONlUwgatmOmU77THiGMOvoZNHO0kWtds44S208Si5K
         v8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUvx8Sw0GCOD8wA06mV/AFdvFVKBBzlJ2eua6c1F8UQ=;
        b=haiWwSXMsnyb+fscxjNpMY4hwkT3ApJK3nkwadP971x5+kBMQ0CHqw6OYWBfpPAaVr
         49i/17YPZgXc+hLrYagEVMeja8Q8eLO3zva0PXodBGLlDmUb3JBRYDICJmnhzCbhy46P
         f2SYIj0OWTZbUIlFziXw8yyBmD16/RGCrGz1P8v0UMw12BMIzlfaC4qNU0QWkos1Kurx
         bo/gOvJfCpGYLVGEg6ME13ItndMbprixMD0s5xGa67i4aqkKIQ5JmtRuWWGiex1Bx7WM
         XL2tOrbb4Bq4qjUnbfJcvdmnmEpPo5FfgmKH2D/3gw0HZSjU72ktJwKtNmHpKTVAncje
         TEwA==
X-Gm-Message-State: AOAM532QL9RxmCOkdK34Lg444pqVh1Q4KUVB5vEiPFyscxEZdqWu9P5p
        9YiEYP2yVQoUy4UnpgAy/yYkKl28mBKA4w==
X-Google-Smtp-Source: ABdhPJxuS1KniejwH+0VNW6hZ0cTKTmMCwEYB6L+9PajRSWD+EO+FG772yxUmh1Hzov7QBliEQErzw==
X-Received: by 2002:a05:6402:1115:: with SMTP id u21mr28124645edv.383.1615789118825;
        Sun, 14 Mar 2021 23:18:38 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/12] trace-cmd: Append new options into guest trace file at the end of the tracing session
Date:   Mon, 15 Mar 2021 08:18:23 +0200
Message-Id: <20210315061832.168495-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
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
index 5995551e..85a57f23 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -840,7 +840,6 @@ int tracecmd_write_guest_time_shift(struct tracecmd_output *handle,
 	vector[5].iov_len = 8 * count;
 	vector[5].iov_base = scalings;
 	tracecmd_add_option_v(handle, TRACECMD_OPTION_TIME_SHIFT, vector, 6);
-	tracecmd_append_options(handle);
 #ifdef TSYNC_DEBUG
 	if (count > 1)
 		printf("Got %d timestamp synch samples in %lld ns trace\n\r",
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 117e4f17..b064a1ff 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -681,6 +681,7 @@ static void host_tsync_complete(struct buffer_instance *instance)
 		if (!handle)
 			die("cannot create output handle");
 		tracecmd_write_guest_time_shift(handle, instance->tsync);
+		tracecmd_append_options(handle);
 		tracecmd_output_close(handle);
 	}
 
-- 
2.29.2

