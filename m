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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117EBC64E7B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF777246EB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8C+z4OT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgKROup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbgKROup (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:45 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E25C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:45 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id d142so3276214wmd.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=A8C+z4OTknmG+Si43kG5KspRzkfrpP9aTYPSQexWPwcoTIMxyHDzZOfcP/+wk4RavK
         p0PQd1B45/jIPIXLekyCZaUkKrzBPFvQTDcI6+x2DCt9QPmrw3gA4CbV4GgoKIVoMAaL
         Jj8+bYqqPplJ5nMWEj1YPBKo/YxlgSu93OuLMMzMPscPlIVqFp7eZSLreiwj/j+KyEY+
         MgDpSwHzmYOEIu8Swb9Kbc63q0Rn3U6va+diy9DSHD6eWvqYOYBxTC7FgNrVUU4gMyG9
         ouFfGSjkuGgjxMJekDvmSB6GWIYwM04nKw7GlRGMXGErFAuXHpiTTRn7vMTHvSZfvXCW
         510A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=j2le1hrIAz3C2O9DSsNRo5WXDurB5Zbd7IjoD8+PBuPkOG50KHv30wndkrS9lKXH73
         VPh1ofsqekzXt8mjR9RgqdtFTOeFknpMlxTg0ufEBre9VUmgkpA+6iZjft8QDvFCjx2u
         l/vF41/SRv9GT4j/Peu8LeT2tqfs0FaiRa/28AZGR67fNLluMUjNk4w0KThXa7+Iatj3
         e+Uggb6TPgMbVcU/BlVZU7tqTpMTRqeWKhPncZUWoObJYoxX3N+bJPYKepxsPCwVbo31
         fQI1WwBej1wajCC/4vfgOgHE/P3qh+8xLyiT9054CfFzowsVxKt+1SWqi+RFlIZBS8+H
         032Q==
X-Gm-Message-State: AOAM530sqWE/ej4jFUXyDj9edhvZvgLgWdVToWY9w2ceB+1LGf0Duqtm
        JmY3DlfkLHmxJPGzywzZLnPjVywJtso=
X-Google-Smtp-Source: ABdhPJzsoQhH6hjdyiALEw5xbX5Zx7HWsWspvL4cZC+KzMCq/2ZQSUkik/pylb+/nQv2x8oItLYhDQ==
X-Received: by 2002:a1c:21c1:: with SMTP id h184mr452628wmh.106.1605711044041;
        Wed, 18 Nov 2020 06:50:44 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:43 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 18/20] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Wed, 18 Nov 2020 16:50:01 +0200
Message-Id: <20201118145003.156542-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Handle the case when the number of bins is zero or negative.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-model.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index 2301b069..44f829d6 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -97,8 +97,19 @@ static void ksmodel_set_in_range_bining(struct kshark_trace_histo *histo,
 	int64_t corrected_range, delta_range, range = max - min;
 	struct kshark_entry *last;
 
+	if (n <= 0) {
+		histo->n_bins = histo->bin_size = 0;
+		histo->min = min;
+		histo->max = max;
+
+		free(histo->bin_count);
+		free(histo->map);
+
+		return;
+	}
+
 	/* The size of the bin must be >= 1, hence the range must be >= n. */
-	if (n == 0 || range < n) {
+	if (range < n) {
 		range = n;
 		max = min + n;
 	}
-- 
2.25.1

