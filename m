Return-Path: <SRS0=Qydk=DB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC70BC4346E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:06:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6E42388A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Sep 2020 07:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CxnuObQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgIXHGN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Sep 2020 03:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgIXHGN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Sep 2020 03:06:13 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D804C0613CE
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:06:13 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y15so2438274wmi.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2020 00:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXOtDu28hvGnGfqhqQhUgnXt5SXZ6HuvpIMNVdQEGVs=;
        b=CxnuObQ3XQnwAD941SIlCPohjPQwmJuir+mTy22o6wUxeBzG2kjowacFJdiNaaSMAC
         u/F744H2iAlOSGh9FvICSpzoiW0L6iO6eDIi521Etws2a4cnjaVaFU/JOtBe7TuEfW2g
         FxryLwOwvWGMSlDqz89QYgG3oyONMzZ0B3UdOOkI1osaAbpKSnaMNdFFF+5CrZIG83Dl
         DT8CbYZsu9YKFjGZW6PkK10ALE4bNvN6LdHU0mKqMNPsVHMf+7AHuR1+d/vEDjyYjq1Q
         AaEM3p4kCo01knO8+R71lNQVxSHYSkeDcokBxJssaCOTpYNZeb7v3CbYbt6IsxLIt0C7
         oTJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXOtDu28hvGnGfqhqQhUgnXt5SXZ6HuvpIMNVdQEGVs=;
        b=UtCobpYAq1fWjBDIYyJXQePGo0AWYDCxfL/u9xcuPPcgCtjWpDIVCslTc9sfpdqy4v
         n6v6nl/+aYFdcZQXzsXhpwYr7LtYk32RTML8ydz06GCKCHLv4/Xeq688mPQSkUkZ2OGA
         cQgyiGgdfGS1m08wGVX+ZsGsoNF9wzzAoytIeF7qeB1g4qq5HJKnS9bmS+2ZKCUYnZTQ
         iA7LqhNdYFQxHAG6wYp8UUuRQNbPrxCBahy8Sfx+fAvYp5Al+HX4KGQOwp5hGtN5MSf1
         5WPwkND8xhzXl/nNROfGZqrg3ibJgLVFzkvqGW4+3Bi/KW9ZsADyHrbt2IlF/O/TbMDx
         kHyQ==
X-Gm-Message-State: AOAM530PLX6JQv//dUBCB11rfoRTAPU6DVUfb6VpuQt5lj5XJ0TeWOY9
        D1GjNZwQT6gMyTRW1XKSyst80BihdSENrA==
X-Google-Smtp-Source: ABdhPJzL49Z1kqRPmSK471/Sw/anrXRJ/GKoP2x17YVmtGzI2ZhQG7jn8KNEi6BjtNOZvMauH2/T8A==
X-Received: by 2002:a05:600c:2257:: with SMTP id a23mr3296325wmm.102.1600931172125;
        Thu, 24 Sep 2020 00:06:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h2sm2434675wrp.69.2020.09.24.00.06.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 00:06:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd libtraceevent: Fix build warning on 32-bit arches
Date:   Thu, 24 Sep 2020 10:06:08 +0300
Message-Id: <20200924070609.100771-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed a compilation warning for casting to pointer from integer of
different size on 32-bit platforms.

Reported-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 186fee33..06fa3dd0 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5305,7 +5305,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 	default:
 		ret = 0;
 		val = eval_num_arg(data, size, event, arg);
-		trace_seq_printf(s, "%p", (void *)val);
+		trace_seq_printf(s, "%p", (void *)(intptr_t)val);
 		break;
 	}
 
-- 
2.26.2

