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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F93C433DB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC3C023730
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Jan 2021 05:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbhAOFEV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Jan 2021 00:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbhAOFEV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Jan 2021 00:04:21 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CF3C061575
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:03:38 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id 6so11553837ejz.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Jan 2021 21:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=grqZIJvyBH6nPu/fxR69s5NzMuJMziBxvw4qZHlcRoo=;
        b=ASsifQhhr5DvvIv4+T5SzdI6z4QMqHTFO5ZudOjBBbywesb3NtvKHp3DFqAlByU/5A
         UGWfCKINTaad9nh1ip65qLnQwyU9tyFRrJqQ+QMyqOTjG1FJDKQEsW9Ux5RHFigB//M9
         42MNtq38Mwlc3N478NJB8ZpT6wAqn4jvEHKLCNQJXQeKqfNump8l+kg++EtiIVtEv25m
         TjsR8t70ClaAlF/X410U3maMTSQLPz0cbewU8asr4eIXMCGp3T5CB4F2dDldUyCB99fM
         oNuN0qQmk2q72y6baMHZUf0rFmQa/3gpn/jE5Hzr2QzGdTaWBbDb5Mvry96vxn4H5xrY
         H5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=grqZIJvyBH6nPu/fxR69s5NzMuJMziBxvw4qZHlcRoo=;
        b=M2cYsBu0Il6l832W5tef6QsY7TGKp+o+LepEDYEIquFbzSRpc6db4IFfcAkAN2J/Di
         T/eUD12WD+R6W3iwB9sIl/Y8laMsf5KqhXA67f2F0eK7Do8Q9Whn4RC6AB/8yjsspRZf
         nnSvOWarLoHgHVoV4lX8sk/LOd/nM8FyR9cAfPUg8L7yEaEdbnqO9IBUpi24scvpJElL
         jrotTD7h2A0zsWmUUH9ky/HWttAgb4FIt78QEYfArjR1KvhRUBw7BpJ/S5Onb1tm9bPH
         1vy1YWvZkxzAS4fLZ284rEHsffjG2feLEVnYZUUMWOb0tXiKPAqUVuHnNC3V/2KKatG+
         HBRw==
X-Gm-Message-State: AOAM531p1BABuQBbKBOu6J8Fhczf0pSSw/ACTBE45DieXgrgQadbEFjq
        JaL5pLc3PmlRrkg2UBRfn+Dw53vw3LzF1JrS
X-Google-Smtp-Source: ABdhPJyCMilc60xyaALBZ0H5iRqTrxs21QPY0nmDAi6wm++zsBoEoT6z2rWxeY6Ka6zyXfQLcXrKCg==
X-Received: by 2002:a17:906:1f8e:: with SMTP id t14mr7655983ejr.350.1610687017618;
        Thu, 14 Jan 2021 21:03:37 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h15sm2819946ejq.29.2021.01.14.21.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 21:03:36 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtracefs: Link unit test to use static local library
Date:   Fri, 15 Jan 2021 07:03:35 +0200
Message-Id: <20210115050335.1193851-1-tz.stoyanov@gmail.com>
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
v2 changes:
  - Link with local static library, as Steven suggested.

 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 403540a..4899365 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(obj)/lib/tracefs -ltracefs
+	$(obj)/lib/tracefs/libtracefs.a
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.29.2

