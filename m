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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90BCDC4338F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 710E461A8D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 27 Jul 2021 13:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhG0Num (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 09:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhG0Num (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 09:50:42 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C96DC061757
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:50:42 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l4so15310129wrs.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Jul 2021 06:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RikzM6cTsYzhnVVh1sROd7OhkUxUTi9rVZY1ONcNHEU=;
        b=HB/dLy6e0KLXn9SySEJNCawsCwSjpsVhWIQnynSrS1UpRHH0PqCDN/bpmOoXpMP2R0
         bjS5TD7gz2drybcQVT9eWlAvxpBFdQg6lRDmQvmTSiEZKki4Joh76Qf3XM6lSX5LB3BT
         a+mfOnKKmOe5Oo9ZtPL2KDOibKFOyaSStQec4Yt2rt0aySPq3iqjgczttiqXaIapqVYG
         xWxMiuNDQkxN0WbaaXh0cen2VMq1Nh41u6f8+3SKb/KYuyP82AEc3cn/zAw44L2LoGzM
         ICjJd6VNyr8bmQdK1GMlbg/WiPMMz5M2sP9Dq7gWDX/F3L6ta/aUZ10lTncgTakvGG6v
         rJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RikzM6cTsYzhnVVh1sROd7OhkUxUTi9rVZY1ONcNHEU=;
        b=n97dbKkFbGmusmpmrMrgPAWrDSgajyDS3XU+Am2aMlugh85hn6A4HfklqC1YzGnjSF
         PXnPvHovW47XMHrl65l9CP1sjYDGj3tgddnjlOLGz5S0tgGdD1tI/tAar8sWmmaQFx8r
         zIsbBn0XbRaYZoVF18x3jWkjldTb8EckLY7DDDP4PzmQVBKBCsWC1jb42tMMCgzz4H9G
         GsadheJtpAxJzYbtyUe9+WDtmxlXtPln26S8EWL9TklFAqs5FL1hCyUz2q+UKbZ/BB9i
         Z4MlnsX4GL1kv413a7VALj4dVNyx2eDIZsSu13Pbl7e3w6cFYsrujWnQOIRFPRFL3hpY
         nxQg==
X-Gm-Message-State: AOAM533OVk5agKkdzFiaMPwYR3K4Vzq8B5ICdcFmJWlJrZrndoQOeQYm
        QKgt4wcC9oh1AwOSrQd8Tn1pSlu1BQc=
X-Google-Smtp-Source: ABdhPJykcX2lfV0QkeEZDJlQvEtWGxPhYSUcpVU/7iBOg/zFf1pV3N0yLPPSRI7Qzk8uGPiVrbzwNQ==
X-Received: by 2002:a5d:610b:: with SMTP id v11mr24910950wrt.58.1627393840786;
        Tue, 27 Jul 2021 06:50:40 -0700 (PDT)
Received: from crow.eng.vmware.com ([146.247.46.133])
        by smtp.gmail.com with ESMTPSA id q20sm3026432wmj.27.2021.07.27.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 06:50:40 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Do not use "or" as function parameter name
Date:   Tue, 27 Jul 2021 16:50:30 +0300
Message-Id: <20210727135030.25914-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"or" is a keyword in C++. Using it as a function argument name in
the public header of the library makes it impossible to include
this header from C++ code.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---

Hi Steven,

This patch is optional. Us it only if it makes sense to you.
Note that this fix is not needed by KernelShark.

Thanks,
Yordan

 include/tracefs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 9cfd257..877e03a 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -355,12 +355,12 @@ int tracefs_synth_add_start_filter(struct tracefs_synth *synth,
 				   const char *field,
 				   enum tracefs_synth_compare compare,
 				   const char *val,
-				   bool neg, bool or);
+				   bool neg, bool do_OR);
 int tracefs_synth_add_end_filter(struct tracefs_synth *synth,
 				 const char *field,
 				 enum tracefs_synth_compare compare,
 				 const char *val,
-				 bool neg, bool or);
+				 bool neg, bool do_OR);
 int tracefs_synth_create(struct tracefs_instance *instance,
 			 struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_instance *instance,
-- 
2.30.2

