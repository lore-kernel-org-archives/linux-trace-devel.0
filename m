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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95020C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 736FD61158
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 08:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhDOIP7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbhDOIP6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 04:15:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 687FAC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:34 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id r9so35515745ejj.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 15 Apr 2021 01:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oZMC7NoUg9LIINTegPsbuVUROEyAkRjeJaskAY2xw1Y=;
        b=Evm5EyVKV+geB/KgZKG7bhxmc+bj+pRDSWMFK93AlTAu1aQImjmS66eK1CEVI9dz+X
         ajP8lHpsaZwh5ZNOegGpfKb3DRnfiS0EW4DKR1rl89aDJmvI56hNEk/5ZeMISzpDAtT4
         xYZyX13OpueXlWxbWQvPV4Ic9bu/fVQ7WQU+IxtNgi5L9esEeGKFwo/XvopD67NA6lrG
         F5tJ58ylEDW5uB0VteAA7ID4qxcf80QOUE5xrqHdCK/CH97QxWVI2P9JcP9yLavCbJnh
         5udnFuuLbePiRktMxIYG8zlEV63qZdbsgGO6euDrbdOSpbZM/7V+cO/ReMCrFe1kHc5A
         4lUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oZMC7NoUg9LIINTegPsbuVUROEyAkRjeJaskAY2xw1Y=;
        b=DzK/w00lS7MdErq4jPCzyMWIj2XKYrQCaqp8BSzXDoamOcjNnxreTUFSUi8KhSBKVE
         c3KIp4XbovSm6+MWUTKEEqegzbgf3VVrP4HgShEfyxpYffJFaj7onUcmdPsqhiq3vi21
         oVZN/vXhBz1qFIg5K/ChPh3bwbRNE5YZWMGUrer95E8mDALRVU8DDxGcmgD5ZScUVCd0
         MdJGvxFZviyEL9gfCe/i2Ur/LfWToKyWNYZHwOjQyVuh3wNv7yM01X1xiaxp1oI8tgC6
         hG03a9YkiJpH4EXcsHKHtDDvy4g3t2wSYZje6T9rLDyn2PPA3/l9hz6zrTTxMHTz3kg8
         RnGw==
X-Gm-Message-State: AOAM5336l5aKF3Yge8LkKg5OWCkNgECHACBYnLG+LYIO00KOFGo71WWS
        Y3Y5Sw48XZfZeYLSIg11HYI=
X-Google-Smtp-Source: ABdhPJyow7W4fwzEB5Nccu3KUdVaKg8U1f/Gh2DElPaU0EJvqyzbte/8EFgTKGA34kwfmz0I/6gsXQ==
X-Received: by 2002:a17:906:5855:: with SMTP id h21mr2188489ejs.522.1618474533238;
        Thu, 15 Apr 2021 01:15:33 -0700 (PDT)
Received: from oberon.zico.biz ([151.251.243.123])
        by smtp.gmail.com with ESMTPSA id r19sm1312840ejr.55.2021.04.15.01.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 01:15:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Suppress trace library warnings
Date:   Thu, 15 Apr 2021 11:15:25 +0300
Message-Id: <20210415081527.3483835-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Suppress all warnings from libtraceevent, libtracefs and libtracecmd if
the trace-cmd application does not run in debug mode.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tracecmd/trace-cmd.c b/tracecmd/trace-cmd.c
index 7376c5a5..7de0671e 100644
--- a/tracecmd/trace-cmd.c
+++ b/tracecmd/trace-cmd.c
@@ -35,6 +35,23 @@ void warning(const char *fmt, ...)
 	fprintf(stderr, "\n");
 }
 
+int tep_vwarning(const char *name, const char *fmt, va_list ap)
+{
+	int ret = errno;
+
+	if (!tracecmd_get_debug())
+		return ret;
+
+	if (errno)
+		perror(name);
+
+	fprintf(stderr, "  ");
+	vfprintf(stderr, fmt, ap);
+	fprintf(stderr, "\n");
+
+	return ret;
+}
+
 void pr_stat(const char *fmt, ...)
 {
 	va_list ap;
-- 
2.30.2

