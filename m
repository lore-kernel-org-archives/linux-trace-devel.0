Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB95C001DF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 03:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjHCDKG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 23:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjHCDKE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 23:10:04 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462E21BF0
        for <linux-trace-devel@vger.kernel.org>; Wed,  2 Aug 2023 20:10:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-686b879f605so329893b3a.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Aug 2023 20:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691032202; x=1691637002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=u8lpjzm6rHULKX3RnedYfP137m4qvGL5uKJaH+JzOyE=;
        b=Y0TbEdn58SoHTye3Mbxo2J9WAbHaj0hE5oFF3fLtOhIk8AX9VRFLd7VLv8sdhUVCsi
         SPMDi2fHjfoMeRrdbecvwp6GPUUlXWuEvOtfAMGgh37FDUi9/kL2uyNQsY3h3JdKDoQr
         +44T1ooEnTn37OxQbwnN92rTwdxDL5WYVa9J3FxmC5WUFI1Co9aX1I6af3usMtOt/aG0
         umgXm3uBsA1M7LHnzIOkkvxJd0VySvmxP2/AegCz+zKB5g8DvNdounRMRhQZTUDsr+k8
         CznKm5bxmBOBupChuK3lRfiX2Xpooj0QfJF1grD7gMZ0uy1ywuAfuKmInly4rN5vf2N3
         rWDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691032202; x=1691637002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u8lpjzm6rHULKX3RnedYfP137m4qvGL5uKJaH+JzOyE=;
        b=dLcaTsOWuenqf5C9NPsvxtImAQppqiut32827VbntALo3BpWI5e+T4l3rwpiMy9+jL
         qAnDlXfbaQICPMKwdD72gVfEJgdAqEm87HcUJdNWQ76NDzuoI+zV41nA7uE9/12bEM4M
         8qlxX+Ni2spZKOSmEtUFpj1Ih0QcdZJNeSoqm4lEMG/qb9h4NfWfF+YGjdrtdOJcwSq6
         EJ5NKffdk2sLx8nk05P3K2CNI03TIrucrzWmKsW0RB36dOqUR6vlB5k0FOXzryWXGR4y
         eSL9XRPMVHti2khU7DlL+a8TUxPppSewoSm1T2U1YFvBHn+NlBNNFLlHUkdLzNVTQ0O1
         RsiA==
X-Gm-Message-State: ABy/qLa0pTsKdqffgsfIxOrXWdAN8Eyw6gFbXyzrdlxak0n8W3GkhcOU
        1muJ67kLUhkwo5z3zMzkED0=
X-Google-Smtp-Source: APBJJlFIdJblMmV7w5YSs8jp2jkniGVwWICuJSshrJ6IrYVFxZDCYro3ojrq2CvUXiI0cxqGbE5Zow==
X-Received: by 2002:a17:90b:4b47:b0:267:c21f:ce0d with SMTP id mi7-20020a17090b4b4700b00267c21fce0dmr13742324pjb.27.1691032202418;
        Wed, 02 Aug 2023 20:10:02 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.87])
        by smtp.googlemail.com with ESMTPSA id g5-20020a17090adac500b00262e5449dbcsm1682401pjx.24.2023.08.02.20.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 20:10:02 -0700 (PDT)
From:   Ze Gao <zegao2021@gmail.com>
X-Google-Original-From: Ze Gao <zegao@tencent.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, Ze Gao <zegao@tencent.com>
Subject: [PATCH v6 1/2] libtraceevent: sync state char array with the kernel
Date:   Wed,  2 Aug 2023 23:09:54 -0400
Message-ID: <20230803030955.380537-1-zegao@tencent.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Update state char array to match the latest kernel
definitions.

Signed-off-by: Ze Gao <zegao@tencent.com>
---
 plugins/plugin_sched_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/plugins/plugin_sched_switch.c b/plugins/plugin_sched_switch.c
index 8752cae..e0986ac 100644
--- a/plugins/plugin_sched_switch.c
+++ b/plugins/plugin_sched_switch.c
@@ -11,7 +11,7 @@
 
 static void write_state(struct trace_seq *s, int val)
 {
-	const char states[] = "SDTtZXxW";
+	const char states[] = "SDTtXZPI";
 	int found = 0;
 	int i;
 
-- 
2.41.0

