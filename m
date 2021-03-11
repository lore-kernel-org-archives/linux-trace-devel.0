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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666E4C43332
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B97A64FAA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbhCKIts (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhCKItV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:21 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB97C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:21 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id r17so44491830ejy.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vUcvTEjKkWIcmMOByMKvh5s8F0YAO/OkTuBFL0Uy31Y=;
        b=ZWF79Zn/ru3DwZcTmNdqkCdai7AO5SS9HJ6qcgThu4T39cmg+xyh9RayrKOncfUghC
         WAEEWvid2HVwoRKsP/Amw24pCBoDRnz13q3QAl2FYtuCZqAsTkVDxy3qwv9t4g9OMBZ6
         Ir34dNWlKHs8a6oJTrhxh1seGOczkyOmcKKJFgPM7cLDMSER2tjGVRpgKR/WXJSqu7MN
         nb9Tnn+czgDalM2vc/CzbVnXROhLCEuvvB5jQk01ZlJO5baJBrIAncRJkCdyuN31dB9n
         /+Ocf8+1q0TiajU3U7vXRHy+lQWKmd7xOxVimQeGZpGCLVGExwY3Kf8FOq9ADuPXXEW7
         Kfbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vUcvTEjKkWIcmMOByMKvh5s8F0YAO/OkTuBFL0Uy31Y=;
        b=C7Pw4zB6La43YmDp5Iz0+OXgLLvssw6oRhlqALmQ7fAzWQ+Y8z4CEJwIKFpBvxmcaf
         Q5zmK9vs3g3xkJoqbVH0F4g2+Oi0W0CdIAk18EhWr/t8+BkCvasUPvyAIo4N8V+M86J6
         ClAr0968pc0HaVD9C+/1A3kop/u910Scxtnx7T3jQRZGzrYPsm7x4QG3+I3YXWXGPRq/
         Pgk6QqenpskQLMYLMiTsYZUDeItMwm+46R+LC1PK2lYFalxwW09hf3j1K23pR2eYFVnA
         IqvjNhTRVhNVrsT6CeYt+K++vEt9VoKZVeNOW1LbW1070yKnL1SjUwsBvwkxexhhKoJ0
         HUvg==
X-Gm-Message-State: AOAM5335jI2U3ufmm5BWpnNWSlo9nCcdYUC3R257YM4SPWX75QhlDSkz
        RzU3MWCaa1+0Mns6fAFRNF57XMMlLnvhrg==
X-Google-Smtp-Source: ABdhPJyn2cLsKmJwLnztnXdzpai1N6VGsphvUTK7jU1jiDtzTQZ4QgH071kI5axVyEsWqQnbcugUuA==
X-Received: by 2002:a17:907:2513:: with SMTP id y19mr2021738ejl.241.1615452560267;
        Thu, 11 Mar 2021 00:49:20 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:19 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 14/16] trace-cmd: Remove unneeded multiply in events timestamp reading
Date:   Thu, 11 Mar 2021 10:48:55 +0200
Message-Id: <20210311084857.1919805-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When the event timestamp is converted to seconds, the local variable
that holds this timestamp is converted to seconds also. As this
variable is not used in the function later, this conversion in not
needed.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1a3133e8..9bdf9da7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1944,10 +1944,8 @@ read_again:
 
 	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, cpu, handle);
 
-	if (handle->ts2secs) {
+	if (handle->ts2secs)
 		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
-		ts *= handle->ts2secs;
-	}
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.29.2

