Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A0AC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D883220449
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfCGPFl (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:05:41 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40376 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbfCGPFl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:05:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id g20so9487162wmh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:05:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ThKcWGp17T1PGZIGkYv9fgJ3BuOcNijCTQQSZYbvuBQ=;
        b=GHHycF8T44mOkFd7JSmVfbJUxpPEoGTms1x/Pyq9mbvENUKFTOy+o8g4cyGNg/6n/V
         VIXxY5ECS7PQlVHZrh2S0K0OqXwEW40e6puUHNwyCtKY9yUu6DBB6keFZSPqPFjo5nIS
         Pls7R37TOFuH7VZDFtdoLHfHlihilRP+GtGCUyPLmcVDIaXLeDasIpOZ8fnezjD7ubZc
         UysBKuP4bRmjudpcWOF0vrutoQkCTY0odfV3xEcmsXvy0uqNxeqyqY6WYu/0rhe0ny0X
         btzVpCZxdGVN331hDXkJo0NIPg4wQsbSfFGkOI1jTdOJziYFoTc8fb0OsfrVII//47A+
         5vWA==
X-Gm-Message-State: APjAAAVrUVEXG2oakPFXSloWMLhxv4S8G0o9byMfQ6BLXnX2hsr1xmlo
        7D8UTUiSfo1nlqOJMHbB5z8=
X-Google-Smtp-Source: APXvYqzSjkxds6HixxnbT2jVWjiY8m8/AszlmFBM0TVhwpu9tcxnP68uSTft2NSte1a+H17rFhu3Ng==
X-Received: by 2002:a1c:4e19:: with SMTP id g25mr6298701wmh.106.1551971139896;
        Thu, 07 Mar 2019 07:05:39 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d15sm10281274wrw.36.2019.03.07.07.05.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:05:39 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 2/4] kernel-shark: Fix a bug in ksmodel_zoom
Date:   Thu,  7 Mar 2019 17:05:09 +0200
Message-Id: <20190307150511.17246-3-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307150511.17246-1-ykaradzhov@vmware.com>
References: <20190307150511.17246-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When zooming-in the model is supposed to avoid over-zooming by
recalculation the Scale factor. The new value of the Scale factor is
supposed to be such that the size of the bin cannot be smaller than 5
ns. This patch fixes a naive bug in the way the new scale value is
calculated. The bug was introduced in

f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")

but had no effect until

94efea960 ("kernel-shark-qt: Handle the case when the range of the model is too small")

because the ridiculous value of the Scale factor resulted in a very
small model range and because of this such modification of the model
was always rejected.

Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model used by the Qt-based KS")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark-model.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index 4bd1e2c..7574cbe 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -648,8 +648,8 @@ static void ksmodel_zoom(struct kshark_trace_histo *histo,
 	 * Avoid overzooming. If needed, adjust the Scale factor to a the value
 	 * which provides bin_size >= 5.
 	 */
-	if (zoom_in && range * (1 - r) < histo->n_bins * 5)
-		r = 1 - (histo->n_bins * 5) / range;
+	if (zoom_in && int (range * (1. - r)) < histo->n_bins * 5)
+		r = 1. - (histo->n_bins * 5.) / range;
 
 	/*
 	 * Now calculate the new range of the histo. Use the bin of the marker
-- 
2.19.1

