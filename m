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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD4CC433EA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34C8B61974
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCVKAf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCVKAE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 06:00:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0441C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:03 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hq27so20177838ejc.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 03:00:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zm+BFXucsZyphQSVHYTcZQBOKWvv5kzSkT5G321QS7Y=;
        b=tiGIfjWy8tTyHlOd/C0y1nWORKF4B6Ld+pnPltLLXSrlJDqhm0PLJjf31oT5s2pshp
         iEWuK9cp2hjqssvjiKO4VAICB9l9Ups+wIsjbmeNCvEoNuMsbWa1iGLEDl7mAFYBEr99
         V/TSBguQlNQb9xRQImVx8PhWT07j04OEY7bePO+ztYJm3Oa5VjH+CrgKNVgzeIoRcfSF
         ubOVkW+9AbAf43pnfzwVZZscLOTmY9zgIxCz6YORTWq8kF9cijUC5qY89lfgA9OrFelZ
         nEcBAl9bWs0bJQryvhKLCtyQ4QGxdsV2uqpIlO00Te3wmCDbhbumutdnppIlSQj48pHc
         vOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zm+BFXucsZyphQSVHYTcZQBOKWvv5kzSkT5G321QS7Y=;
        b=dRLI722K38hLRU5xnOx3VjE10rjW3uf64qbUkicpx1DEw9olSKxbTNAH5g1rWpFSqw
         +swxVN8GeqgFekGzcJOx2B30xAmntBcDsV988LxQw0GQEnF9VGVnbV4wszfeoI9PP2xH
         9neFwNebPNATKKNQEbDgk5N5OsP4T1ZqqnRAmXOYzj2K1VBvlEnp+2YXNMfKBMx/TOPX
         muYmg21s6tTdqvm/KJVFcH9uGLPn1qsZc1XnI6WfVyazbAfFJtozOcljYBLCzrrAi6Gf
         nU97/umb+OwkwywPpGVohBxbUpPIcLfbZoU8pmy8+5b5IwoV9snb2zGioX/7s0dlTxvG
         fpfg==
X-Gm-Message-State: AOAM530ZabQLR/0GIgjTc26sgd77kS74Dqig+dTqu+0if5LOlJKyhADs
        /gej4mcKqM6wjItPulXSmy6u172s+VbWDA==
X-Google-Smtp-Source: ABdhPJw1yUTHczAF1/7zjwri7OIk5ij7JCgRlMlIM9jayWC2eXMbPBhh/oXtd6LSVWZcy9h0acvQTg==
X-Received: by 2002:a17:907:2112:: with SMTP id qn18mr17925081ejb.220.1616407202434;
        Mon, 22 Mar 2021 03:00:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.03.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 03:00:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 16/18] trace-cmd: Print times in TimeShift options as unsigned in trace-cmd dump
Date:   Mon, 22 Mar 2021 11:59:43 +0200
Message-Id: <20210322095945.259300-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed "trace-cmd dump" subcommand to print unsigned times from
Time Shift option in a trace.dat file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 31b9d201..f5b864f7 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -373,7 +373,7 @@ static void dump_option_timeshift(int fd, int size)
 {
 	long long *scalings = NULL;
 	long long *offsets = NULL;
-	long long *times = NULL;
+	unsigned long long *times = NULL;
 	long long trace_id;
 	unsigned int count;
 	unsigned int flags;
-- 
2.30.2

