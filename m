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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E562C433E3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D1061A0F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhCXNF1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbhCXNEj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:39 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E226C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:39 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso1140002wmi.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uSi3uEcmkaXEuP6Q3gKY3I92rv2pVd6xu8pIP2dyV4I=;
        b=NPkgRpXNGmyOkIU/ECi//KX/u9Z6p6lqgWcTKlA+S0VlQ61T17Y9gH6OYCCdKadlwz
         x78tdWUjI8OwgeiKW+jotmnq22NGlOOIGOXVu1dmMafgKZGKCFAGbRTHjLpt2GcioqJQ
         OX4PCrHEPG9Nt/fG6yQxR2pkjnsSXRxHLkWdEsdLFW4RsZspkvuiBW2kx6vYZLdAiEPY
         /nEEMyk662Q6jQoDUn9ny3RNgNVt28f2jaGswr9grNIHqiqOzuWQ0gsJqio6PkPs/3m3
         6Y9bYXlZtgDCzhX58AfGn1b3w4j7Xf1A1I27E3vWOrX7fPXQ65eOf8j4zhV4dzSJmhTp
         NPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uSi3uEcmkaXEuP6Q3gKY3I92rv2pVd6xu8pIP2dyV4I=;
        b=oQB6xARY9nFYJ/EP+JhprtXQO8xtUdeoN7nDdjJ3nCySYuzrBB6RS4a7OH5u2DuxVy
         Rmy7R7K7E9/s0YoQ/7s9+wW2+VZa063WlZMdSQY5X7YEFgxkuSruwJpg3NsZietDTgSY
         BTyf5NxJTVOHasi6oNo7PYYuarwGUhQe7FhT+vzerw1NDhK+dD+O8crH9mWpM1OuNVQA
         tyCA2Hti+Vv9jkTTF+1ydJ2S6pbXdU3Eer7rHe+ALsce3arC01zAceK+UPvV6wlJPrtm
         yp1X9MEYIw0S9LnBhATKPDTn3XsyWOutynIHznM3zKQME0+SP2SRzzB4ouN+6wgtr6g/
         EjvA==
X-Gm-Message-State: AOAM5339f2EK01vzHeEARWclsF/2yBBDTdmuCAASyUuoEWfG4oQRWiva
        ynShJZ6KVumVrug6On/LKVOvqSFapsTTig==
X-Google-Smtp-Source: ABdhPJyupAZbF0Dsed5erl26iSTeQvDtGTrJD9lCmBby+Xf8C8XlrRJjdPrescZmek/mj7X3IqLWjw==
X-Received: by 2002:a05:600c:4f8e:: with SMTP id n14mr2937200wmq.34.1616591077536;
        Wed, 24 Mar 2021 06:04:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:36 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 11/23] trace-cmd: Append new options into guest trace file at the end of the tracing session
Date:   Wed, 24 Mar 2021 15:04:06 +0200
Message-Id: <20210324130418.436206-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
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
index 7d2a8013..00fd4a1d 100644
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

