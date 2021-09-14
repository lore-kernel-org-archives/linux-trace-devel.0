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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76164C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2B560ED8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhINNXU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbhINNXS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:23:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC46C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:22:01 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t6so18463745edi.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=GTeypRUKCQWi0uP1B1EZ3E306WTwu9hwv0KGptN0y2miOYZDIH8TitptLUmc5Qa+1m
         o7Ag2xI/4xCetNKV+RPOApSK2GqFf+Wq2mWcwfHmWodrcLM5nZ3/U3DqbyFWm2cBJnT9
         iGRdjFUXRY4G0uKeIF7Lzt2cP6dY9WKt8Ghs6LzBZSPyTabmsZgfdqUcvqjOISjsrOL4
         nCiM0w3VRTt9VTxxUZJ3b9cuKI8j3YLezjHaJEciNXVEMIZyOETl13TUUiTsnaS3taNZ
         tnFASk4y0bF+6+Kyk4iiwtvWA4f0S9Yi6lVzZiLvbbw/zD61VxCh61n1lrm2RnLnu1u4
         BYdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=84YBfQkP8YMHELb1tKO3NWhuSj1uaCA+g4kG3U3Va6g=;
        b=qlJ+6RLpL+eGTMnLCOsbzZeFWw3QdZ8KMPgd7L2Fn9dHonvBjmTvcwCsouQ+Jm4t/W
         Yv7m3UDoOaMunI3xsHoBusvYPK3uTFw2uaRd8YCQNiGaWruZC6PsZHnO+kSt3k6PBWx/
         KjXXsfuEdO4OqIX9bBnrCrdo8Y8P1dlvmbiOwWEpYw/P6/Uw7xHn5m0b1NxJGA3zY7iL
         cC2xd74odABHEiY9JslV7N0nMTI0YAf1lHXPt8MWmmNunMY+2DTEMxKzaSTisJ7j8vT2
         m3ASSOTBJS00GI3iixhiXiY48/GxY/kLO9BnpIqNKg24d23AlCP9CTC+QpbX/Vd4h+XD
         N5PA==
X-Gm-Message-State: AOAM532H42JfJ5WnhTyNkdredqcF3mHcLIvZWzo0F/P1xRM+Q7LZdttF
        eU2uCb2WjxyrqfUxQWwBgh0gV3+rraU=
X-Google-Smtp-Source: ABdhPJwalzVytd0jaHlRwtBFsrn6ooUx4uTwXLdC9I6eLG7OSA95UxOL+LRu+OKWzxkgJWTuhacrdg==
X-Received: by 2002:a05:6402:34c2:: with SMTP id w2mr19015112edc.36.1631625719903;
        Tue, 14 Sep 2021 06:21:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l7sm5708431edb.26.2021.09.14.06.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:21:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 10/10] trace-cmd dump: Align better the output of flyrecord dump
Date:   Tue, 14 Sep 2021 16:21:48 +0300
Message-Id: <20210914132148.3968401-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
References: <20210914132148.3968401-1-tz.stoyanov@gmail.com>
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
index ab2fa2e5..6a148cae 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -898,7 +898,7 @@ static void dump_flyrecord(int fd)
 			die("cannot read the cpu %d offset", i);
 		if (read_file_number(fd, &cpu_size, 8))
 			die("cannot read the cpu %d size", i);
-		do_print(FLYRECORD, "\t\t %lld %lld\t[offset, size of cpu %d]\n",
+		do_print(FLYRECORD, "\t %10.lld %10.lld\t[offset, size of cpu %d]\n",
 			 cpu_offset, cpu_size, i);
 	}
 	dump_clock(fd);
-- 
2.31.1

