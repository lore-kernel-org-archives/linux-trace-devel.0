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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED7DC433F4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2946A61A21
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhCYGlj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhCYGlM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:12 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE73C06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:12 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v11so1096803wro.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qvFUgy6miIeRLIu13Cf1pJ72y5BXBpHZC3n7LJ9dlbg=;
        b=BbDExBI/aURsRLooEoItQSzTVlccqQHix6NIQKDxhEh/Z4U1oqDmsNwhvyCO5rYk/A
         osa2Kf3dbEshHTwZCpAsoyHh223EXBlprcuuxiAN9eOFWzf6k0w+XqRrz/+GSEg0qjs6
         4RkCUzuQUeWBxIvQhs8ME/b40t5b8b+oLsbs976lzOI/WvuFX0h7MSph6Yafp23xu4VQ
         c2w+ih/eRM5IC2cv1DUOnjntnFJF8knd6tnPrnzO8ZNzG7oUygT+5IRg/IqZhu7GWZ0h
         slAUwo/yGxnIs0gyQVcIicpoftfvxupVv+W+YBRO40ZaNtcmWjqE2B6pn2DDGXihwULg
         ccTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qvFUgy6miIeRLIu13Cf1pJ72y5BXBpHZC3n7LJ9dlbg=;
        b=jolE7790QdFoFjgmBxzfa8gzBwLTdNkaYTo+7ZiAeMJKakKOT+vLbUvwA8FPCpj3p3
         tob8VxORJ8vjY/QV1QRqKCS3oo+cYuhrQQhlIkTAfMryvYFYSycuDppFU2q9ckI6KXMo
         57PzL7n+WFvUalNto1juDTNMk3AhFBkBgo+UtlBRO9//EhULu1mCnNrsHCBctPYJqw9u
         3ufT9tj/jvOpyFFLL3hjuNFbc+WbfPhvTCbh5m/6akYJnjzMGbVcceqT3ARLXTM7Iyx2
         tlKm4JvDC9C1vausMX5Lj83FdG2EmMWOLlTGEDIKHQFcHzw6RrQSlurTIb1a5GJBKKoH
         Xdsw==
X-Gm-Message-State: AOAM5333QJqg33Y8TVkzTQvTbN6FgRuVPIrjMLQSYMBryYxpv/nwCijl
        yDF5e3uAUXMKbk/GlP6r6lI=
X-Google-Smtp-Source: ABdhPJwIaZSX2abtpOkDf8vUlNWAEHTYVe5XEqQfVuqzm7VfYz9NUmaPdGrb43WIK5OREHsj1sF62Q==
X-Received: by 2002:a05:6000:181b:: with SMTP id m27mr7204916wrh.363.1616654470952;
        Wed, 24 Mar 2021 23:41:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 14/23] trace-cmd: Convert tsc timestamps to nanosecods when reading trace data from a file
Date:   Thu, 25 Mar 2021 08:40:46 +0200
Message-Id: <20210325064055.539554-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is information for TSC to nanoseconds conversion in the trace
file metadata, use it to recalculate the timestamps of all events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e1842cce..266b0b0c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1196,6 +1196,23 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	tracecmd_free_record(record);
 }
 
+/* This functions was taken from the Linux kernel */
+static unsigned long long mul_u64_u32_shr(unsigned long long a,
+					  unsigned long long mul, unsigned int shift)
+{
+	unsigned int ah, al;
+	unsigned long long ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = (al * mul) >> shift;
+	if (ah)
+		ret += (ah * mul) << (32 - shift);
+
+	return ret;
+}
+
 static inline unsigned long long
 timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 			  struct ts_offset_sample *min,
@@ -1283,6 +1300,10 @@ static unsigned long long timestamp_calc(unsigned long long ts,
 
 	if (handle->ts2secs)
 		ts *= handle->ts2secs;
+	else if (handle->tsc_calc.mult) {
+		ts -= handle->tsc_calc.offset;
+		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
+	}
 
 	return ts;
 }
-- 
2.30.2

