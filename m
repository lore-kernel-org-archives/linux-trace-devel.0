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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F34C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7CE322B2A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 21 Dec 2020 06:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgLUGDK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 21 Dec 2020 01:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgLUGDJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 21 Dec 2020 01:03:09 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DB4C061282
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:28 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w1so11765911ejf.11
        for <linux-trace-devel@vger.kernel.org>; Sun, 20 Dec 2020 22:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6lW05kqySe25bMztFYPDSu7848Dd7zwGJDabA/ReVI=;
        b=nIVdX/LKLo2VC+yG8ZRHwRV2GBNFklCRDJBDOlHKM/f5jUjX/35bdJKyX2Egm7Nr9A
         /HgNT7jqSrOjmWPNpuZPc0PenK7Voa4VUYTTao28MjZJz+EVWjS6olDn84vJ7O5LnBui
         xxXOK11Q6GJWDQIZtxKhfjs93fl+7GbBKrtm7Ye9dbdR8ZMEb7oQ8FDa/qsEP/ir/9BX
         sS2VOwNoceh5fhFAH0ZA1aSqs5YejRMJEE1Z13IomYFwiXHKJa+IbbtHteN18O39ii84
         DRZqXzXAFGf2sfqHIc+LBRaaAS25aZ8wQNouoXheACUojLwCFZqaQXjUaw4le/Bs9+6A
         qGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K6lW05kqySe25bMztFYPDSu7848Dd7zwGJDabA/ReVI=;
        b=QZI/nB2dIg5XpY1dtylnDy5DlrMUtuV23XYtIfJc3jZGXD63LCYrmmnCW0mneCpoG5
         HwIpS0Er8FAeCGXr29Z62e63CwqzGhLGIPZykQJP6+gXYQJ1fU94Wzbu1Mg+XLl1YQHi
         qEoPtXWLC05FtcbcL0yWeTeSKhScQ8nk3WoQIKK6YmJSdElBdw+6FHmI/DPihRAN4KhF
         /JFo9Yqf9SpS6vYRgvXyjsuZ9T0Johq2s+WUpD/7s1qoqX1YKIktJYEWUiTgpRcdExH+
         +wWQDnaGp9G50m0+PnzkUBjW9AizomMASs3gbXPJH0osQsM2MG2Tyo1OF5D0Wdz1AebV
         Fw6g==
X-Gm-Message-State: AOAM531wFNDOFuExoIr4MEU15rGxc0WdnbTVB3uZk1icC70HMTJw5yOq
        120wLnDd46UJULTwLb8ZeKCNxQojpGzANlxs
X-Google-Smtp-Source: ABdhPJyp4llJAe8WczdH5bOXXoq0bWGRgUPBfAEIdN2vBnmrCsRr3UBUSz9sB0oI8nfaBLOK1bKaZQ==
X-Received: by 2002:a17:906:400a:: with SMTP id v10mr14076710ejj.302.1608530547461;
        Sun, 20 Dec 2020 22:02:27 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l12sm8722984ejk.10.2020.12.20.22.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Dec 2020 22:02:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Force unit test to use local library
Date:   Mon, 21 Dec 2020 08:02:25 +0200
Message-Id: <20201221060225.177587-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Unit test must test the library located in thre

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 utest/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/Makefile b/utest/Makefile
index 6505a3e..403540a 100644
--- a/utest/Makefile
+++ b/utest/Makefile
@@ -12,7 +12,7 @@ OBJS += tracefs-utest.o
 
 LIBS += -lcunit				\
 	-ldl				\
-	-L$(bdir) -ltracefs
+	-L$(obj)/lib/tracefs -ltracefs
 
 OBJS := $(OBJS:%.o=$(bdir)/%.o)
 DEPS := $(OBJS:$(bdir)/%.o=$(bdir)/.%.d)
-- 
2.28.0

