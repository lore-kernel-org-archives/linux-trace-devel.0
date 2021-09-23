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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1617FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFD5861107
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 09:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhIWJW5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 Sep 2021 05:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbhIWJWz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 05:22:55 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDF3C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:21:23 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y89so10408897ede.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 Sep 2021 02:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpBQecJQJ5HuepUfEPVapqgW6YqChlq221DadmU69x4=;
        b=pm2h3zKQ/3+XfG6Ef3xHPV9TGwc8lVyPazIeGuU/EiDmILfQuPCgrj+Ldqt42vR/i9
         D3JJrac7B1sYwrITfRUliYrD2JCGCuMr/DUuQxB2NaPh+x6rsWQB0e9OrPTAOPwT45ok
         w0T8i/2fwly9qKH3X0pr2WnVvEBnE+ujEMx6/V+zS8ZAnzA1M9K0NLbpt4nHE/YyNcBH
         ZJDzdur4GX4nM2w8IFhhWyEYbhtQ4/NuiIpUPFuJ4UjZOepwN3vVnK+J6H7aRWBfXfSr
         yJe7Ck2dXn3HeLmgUYXwnKH/b32xMZl1kOPFqST4590PBlM0fpCQyOQ5lPZh/jTpPfYk
         45Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpBQecJQJ5HuepUfEPVapqgW6YqChlq221DadmU69x4=;
        b=kc6pSwApWET0taQO91JUoIc46/w4c/bu6N+VU4ph/Asww7j0MEiFwxMM7UU98ssLyw
         LWbGOSV2nTnAPLNcsUMeh2xmIH82hwkKcbAcSK6fwbNa0IB/C3+ZSiUgvslUDaiHibN/
         rW6N9zLOW1Tj89/nJ9JRzvkpDUtu2HRoLam0Ji8QTzowe8K/goJZxshcSqM/oM2LKYlB
         ck3qJTasy69Zfq9idmb3JNuOICdv2P7oAvkFsRn9hf5NWtjiXq0R1qWAaK1HzgbL2VcR
         BsgthzcM61xvN4Bjnno68cSc2t1LZR8yLrUCFgEVPV1mew4Vn2Vycqn81CqJj5++Yim3
         pf3w==
X-Gm-Message-State: AOAM530+C7OQr/JCVJv1Lxhw5OucFkjHckiwcNm0CBb0godSviGK+b+8
        ArpYuqCIP95Tf9PoZYko4Ww=
X-Google-Smtp-Source: ABdhPJxQoOOCtgX6+ZnYwQf1IO6296zBhScbl9IsxGNl/nm/AQPXVuF9+bqDOgruh58L0Rd0Zg2sMQ==
X-Received: by 2002:aa7:dd8c:: with SMTP id g12mr4276493edv.280.1632388881598;
        Thu, 23 Sep 2021 02:21:21 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id v25sm2574280eja.83.2021.09.23.02.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 02:21:21 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] libtracefs: Fix add_sort_key()
Date:   Thu, 23 Sep 2021 12:21:10 +0300
Message-Id: <20210923092110.84812-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The histogram can have no 'values'. A check is required in order to
prevent segfault.

Fixes: 5d1c2ea(libtracefs: Implement API to create / modify and display histograms)
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/tracefs-hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index eeb8374..c112b68 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -364,7 +364,7 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
 			break;
 	}
 
-	if (!key_list[i]) {
+	if (!key_list[i] && val_list) {
 		for (i = 0; val_list[i]; i++) {
 			if (strcmp(val_list[i], sort_key) == 0)
 				break;
-- 
2.30.2

