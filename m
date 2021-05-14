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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98EDC43470
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24BF6145D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 14 May 2021 12:18:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhENMT5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 14 May 2021 08:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbhENMTx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 May 2021 08:19:53 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4181CC061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:41 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id df21so7229665edb.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 14 May 2021 05:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H8H19MfKEzKlMMeMpUQNLaugzc0L7lI2BG6f2PIOKyc=;
        b=gJ8zQ5Tw7GPa7yz/ceUB2VL7tgCFgjhDnlCJ3biN71FHR0r8LZ7tpIZ9yZrfYOw6dq
         ihSMtluEsECS3AQ8WgnPSv8A9ZIqeohxt2I19ZQyMGtF+DAFS6z6Rzn5mAEAcGXp/Sb9
         ++YksNbIXbqbB3D02VmQhhYiwCbeVNYuZQYpdzH28e2Crp0cYd9tdxnVh9AlEU9CoyXW
         NHGHR+Fq+fG4uhfBWF40TIV3zro5RsTj3QaGpRRGmfLu+3R/fEDu19KAq4v2qyELwTrL
         7QmZrHMoMQQZRaSI/sNysRyS1Y3niGK7+2hAJTKAKRwhbIM3AhM052lsVVoLU+EoM7lC
         R6hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H8H19MfKEzKlMMeMpUQNLaugzc0L7lI2BG6f2PIOKyc=;
        b=LLh+3Pj1yMFLA2TIn5wyaTzO7bd+073Ho/lkJhAM09xfkeq25iyslAvIwxK/oT1VZu
         h4/ULSMBfnAXEchQ6dbsW7jwVMFe2x3cWE00EpS/qQrUrx5YZIq4HifSYd737P/s8I/J
         9siO2Z+4E0oplLrZxcuAEqG3900VgqyFYZa5ptRPsXuyZyFpNtn3bEvxZSStLaU/5kO6
         atKa4QHvxUF2an0HiJSAcBDMYcjoyJIYeOtsxdf7uiA/uNqcgm1F54JNQSvO6Aqgg1Bv
         nuSDi+TdtSlChplvJoc5LZEmvwfZo3BLyf1OfivMBuXzLS8MLvXGNUGhak0Zos+Q0l9E
         QAsw==
X-Gm-Message-State: AOAM531wnwUFYmDae7uzhoum/DxhPNuPHTGDmWt8m59FWG/17Qjp4Qep
        BQ4hlln+DWrCt5+PRhJv1XBClagg8JY=
X-Google-Smtp-Source: ABdhPJyQ2Q2qjJn4wTMZO9y6cB63yJA8mzEgpCERkB+cwcq2X6fBTyncRjm+FqeEqyrbKgoQ6gndUg==
X-Received: by 2002:aa7:d58b:: with SMTP id r11mr12412475edq.231.1620994719766;
        Fri, 14 May 2021 05:18:39 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id cr21sm3435157ejc.2.2021.05.14.05.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 05:18:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/7] kernel-shark: Clear before loading new session
Date:   Fri, 14 May 2021 15:18:22 +0300
Message-Id: <20210514121826.161749-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210514121826.161749-1-y.karadz@gmail.com>
References: <20210514121826.161749-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Make sure that all already loaded Data streams are properly closed,
before loading a new configuration from session description file.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsSession.cpp | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/KsSession.cpp b/src/KsSession.cpp
index 1e19a5f..b9edb3a 100644
--- a/src/KsSession.cpp
+++ b/src/KsSession.cpp
@@ -128,6 +128,7 @@ void KsSession::loadDataStreams(kshark_context *kshark_ctx,
 
 	data->unregisterCPUCollections();
 
+	kshark_close_all(kshark_ctx);
 	dataSize = kshark_import_all_dstreams(kshark_ctx,
 					      _config,
 					      data->rows_r());
-- 
2.27.0

