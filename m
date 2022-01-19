Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B947BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352486AbiASIaf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiASIae (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:30:34 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE9DC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:34 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cx27so7738164edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5gYC8ONSeCJ8BvnmorRHJFxsyZlO4Wj4pR1xXb63xs=;
        b=WoV5c4fa8Rp99a8H1a3a9VNmVLa9wnbRkmP140mEPD7iThlFTuGJLQdDFR2QhY/vaL
         6vCNG13MjWKCa1Sl1zIde9DlBb3Zf9ym2odMaZ9BGOt5zVCr/AtuS32kwba94RSNv7YB
         lnav1FvI8kiCeaNeQl7ZNryH+oelU9WuQ3Xhlez3P16Haf8XEsishJKNBO+H3Gyz0ddL
         x02Z7Q/rf6TEEcW6lAGUXGJCichqWSYULnHx/Tw4bXc4zjZvAENQEDDw0RB7JyzEVibz
         E9VbydIXu4RLXzCLZNVKHm4fTr0iUnYAAIpujr5NzAp9bd+ysK4sJGhabzaZck/rEgu+
         Nxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5gYC8ONSeCJ8BvnmorRHJFxsyZlO4Wj4pR1xXb63xs=;
        b=H3q/REONRUrSkIchs55KmBVbyniCQoIFSwpIm+1vjuDSsh4pnZXYJ0Z7ZXEK1cISj9
         OTsAwdnSrErGAKAHschvvZyeA3MlfnD7HNpocvYX4ZM7VIdehaXIPV1NU3iSGnGNbKSn
         5alnce4ElZ7fUD/8LiRWbUVfpjV+OrZWsoNKCV77z4ujH4uBUe7U3IUvPkFPan36LWD7
         fakd4O0ql4ve7+GS1kTE70+/g9UpPoS2/iuNhKBbXvWn07HHHTGW9MmxCIvPBYuKBSbJ
         WAEwQ0yJHr1lUNWyMFKL1NdNCSiNjA0YMzMO7MldVgxmDOhnQJnZ9ph5gTrx1D2imAyg
         UOdA==
X-Gm-Message-State: AOAM532O20NLUj/8LsnpeGwhfoqg0oham8lOf+cznJYpBdCDqoD3WaFI
        y9ZWGTRV5P9RSfDuS0V/LkLWcwyzVT4=
X-Google-Smtp-Source: ABdhPJw4HeYNz6kWfpNWeUqcQ1pNgdsGoJ/F99IRZVMQLl6t3+Kr54w6TfbnG/Wdihtv0zL6sHV7ZA==
X-Received: by 2002:a05:6402:5216:: with SMTP id s22mr29490115edd.132.1642581032654;
        Wed, 19 Jan 2022 00:30:32 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id la7sm6095530ejc.94.2022.01.19.00.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:30:32 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 11/11] trace-cmd dump: Align better the output of flyrecord dump
Date:   Wed, 19 Jan 2022 10:30:19 +0200
Message-Id: <20220119083019.246153-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083019.246153-1-tz.stoyanov@gmail.com>
References: <20220119083019.246153-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The flyrecord dump prints various file offsets and sizes, that can be
huge numbers. Add format arguments to align better the output.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index fd9008fd..70adb816 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -959,7 +959,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.34.1

