Return-Path: <SRS0=D6y3=CL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2FC7C433E7
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 10:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717192071B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Sep 2020 10:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="abvralT1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgIBKb0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 06:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgIBKbZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 06:31:25 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132E8C061244
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Sep 2020 03:31:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c15so4631358wrs.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Sep 2020 03:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8McVpFKVMkzeEHjTz3iPyrDoVZUkptzw4W7+FRs7lQ=;
        b=abvralT1GCSwtocjkJL38zB5kcFQEJXtZaArVIMVcQopqITMc8CS0LMv/Y8LPluyB3
         nsWdh1kRvHUBArvK58HI7gJu9T1A5t9pW9S5WSJdfUfHsL4G9oRyxxmSzC1pWNsZNvKr
         Y0rcHm8Yye+ui9smrdPPWMuOJzX37mxuXLCY/g+trvdxI4GF90+mUXYSJd+4P959gCnJ
         S747aTfF38MkBF/H3K8WNxCznZHLw973X0sXtLq47ZiKR6IkdK8iOVExdGjnmorkU78X
         73QuaLhzncj525Q1Mkz5LQQsPRFV15a0p0Fs/t5+Q3S71iw/7LBdZeEb9KbtEUOFG6Fo
         l3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M8McVpFKVMkzeEHjTz3iPyrDoVZUkptzw4W7+FRs7lQ=;
        b=aJ83V8KGVKZTw8DbWgwiYJyzrvr0EOM2lBECrxelFEr04vsmxl2qZwAGyvmFDSHx+A
         Cg2XxjjtTqlDZL/Xrfali+P/6Z1BkY2mdVFv4WkzlhLnSvPvu90Swcy938Blq4J0KmFv
         nXQfzTwwJsDvdTXz+oQEZWwPrFduLNlApEOla1qH5gGtAsv0t8N0WxvywSHO+oGloDnR
         9LhxxmZ5sGpEfqJ3EW2YHLyZxYkOfDD8zLfUxwvdKZ9BBKEXQAiinGdg/rVbHWkdrBYf
         eNZ3cA+3RnwGPHsJJNSfOB7kHmPvpgf2dUZRoE0B3NlP46R7YE5ZLG7gEGy0fl9seD7F
         Anig==
X-Gm-Message-State: AOAM532TXO5i/hnrwYajmeUyOCJFHROBK+9y7hOaSUIQ1MQYiBXCvzmz
        CAhTyrQX37Eh6V6W3ylebfg=
X-Google-Smtp-Source: ABdhPJw5yyww/qRi+AquFjp2PLnyCLAi74OgkLkQgMDdJY3suSkE6cbYHPupdyggIE4tFANcpvK00A==
X-Received: by 2002:adf:f984:: with SMTP id f4mr6464493wrr.102.1599042683590;
        Wed, 02 Sep 2020 03:31:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b76sm2582437wme.45.2020.09.02.03.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 03:31:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, arnaldo.melo@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools/lib/traceevent: Fix build warning on 32-bit arches
Date:   Wed,  2 Sep 2020 13:31:21 +0300
Message-Id: <20200902103121.345626-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fixed a compilation warning for casting to pointer from integer of
different size on 32-bit platforms.

Reported-by: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tools/lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 3ba566de821c..5acc18b32606 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5259,7 +5259,7 @@ static int print_arg_pointer(struct trace_seq *s, const char *format, int plen,
 	default:
 		ret = 0;
 		val = eval_num_arg(data, size, event, arg);
-		trace_seq_printf(s, "%p", (void *)val);
+		trace_seq_printf(s, "%p", (void *)(intptr_t)val);
 		break;
 	}
 
-- 
2.26.2

