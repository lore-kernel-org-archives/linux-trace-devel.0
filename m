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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DD3C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:32:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3D2623133
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Jan 2021 08:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbhAGIcw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbhAGIcw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Jan 2021 03:32:52 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C634CC0612F5
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Jan 2021 00:32:11 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id t30so4783137wrb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Jan 2021 00:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ve4ITcPVGMm+0bopq52Vxm6jLYjrwASM4D6uETB/3es=;
        b=lJT5fcWVegiMSpcA9oSyG0Az1l64o+xpEReahfq1ZoPtHNknNyQI9+LAoWjp2pZ4yC
         IKpbp0ZP4wc/PVZo/1HQUed3itLgdbRsC4TEFO7W/DhLerUTS713FcmiBfOTz4tjZ5Pu
         gvzBq49361RBItaEyvW3x5qkJ6Ek/2Avh2Wt1NUnl2xOm0tqaZm9pGhJnCm1nRJDBvBL
         swCMfzUQMwj58m+2zfY0a9YR1T2WGa1BszuGehHsE8Vu11UizcTvhTzcbM7V1hvWc3Dg
         2Tl46OD1Dsyz2SP7xcEalXgnbt1viGBxuf2YX9coxMYCFvC66fU3NCkZb9lVajrf56Es
         hBPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ve4ITcPVGMm+0bopq52Vxm6jLYjrwASM4D6uETB/3es=;
        b=f1q+5m4OPB7blBA6/lom5OEyvyAv98CYgtu5MBv/1FPX2xRx1XEs7qDtUzhz3vg8YE
         HkqxZZVIg0LapRBNrIiGKL2RxyUZNrZFcWNMUH8XmbCcsjmXJ8DNWBYbwQ0KMsZ80Qjk
         5IGvYttUKQaMFcprdTK+T8bF1uP4YIgto+Q/TUfYu8f/samYjWVYYpdLdLZpsLHZXVTU
         NaL/GzZqdXVhS1ZwIN2RkJDKHIi+i3xh7kz/w9nd915s1UKhW8gW7UNQBPVBotEdI6O/
         KcNiIAp9V36uPVReoj6LUIthbolB7iNq18Ne4p2cB+DzjfY5GACrPehertIostIJAIkW
         svtA==
X-Gm-Message-State: AOAM530sJeiAxYX2+a0IAYEPWDSvSfOYTLLKyJGL1W/4bbC3rZ0hSMBq
        nIhtvqgquLXuE8LA7d9/dVuDEy2w1y3p6ajk
X-Google-Smtp-Source: ABdhPJzVAm9tyZN5Ph3h5UdDAy6FTbyWl7WVKwUsRavTZsGs+FfLlQwWyF1E/+6fUOI56OFJKfT2DA==
X-Received: by 2002:a5d:5913:: with SMTP id v19mr7851475wrd.207.1610008330601;
        Thu, 07 Jan 2021 00:32:10 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id t10sm6607484wrp.39.2021.01.07.00.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 00:32:09 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Link unit test to use static local library
Date:   Thu,  7 Jan 2021 10:32:08 +0200
Message-Id: <20210107083208.15967-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit test must test the library located in the sorce tree, instead the
one installed in the system.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 403540a..6e9c760 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(obj)/lib/tracefs -ltracefs
+	-L$(obj)/lib/tracefs -l:libtracefs.a
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.29.2

