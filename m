Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B147C4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EE7D2085A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 14:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbfCHOba (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 09:31:30 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36149 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfCHOba (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 09:31:30 -0500
Received: by mail-wm1-f67.google.com with SMTP id j125so12644818wmj.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 06:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9RHgqU8nn0PP+caEF3ZjBz0MN0WO4lkw5eG8njQAhCE=;
        b=IFte7Nj2u02rzaAKShZLST5ul+XPKMgFj7Q0w2feCiTeRU/R81lhCmROC+WAoiW5Bd
         /yNDpYY/nyAMuthQDQYNdoN5tClZtyd5ZCGFOuQkdldv+upHGq05B2nKuT77TOV/9TwH
         ie+cFcqorXUUz4z0dKUf8pfTAip02OX+GumoXrGHjA7LijqxBU9G3CKn28Hpwlk+Jn8F
         uRtVgtHMr+4uuvOXj0oLbdp5HGvF1TLO4j8/MH+F3ufaRY3TaDPR8BkRWNxPaYYghI+g
         /Lh5tCNyKR8MptvHTZstudIdud6VSllXYtMmuI8XX8DQdI4Xsywz+KB8UyEBmQKfw7Ji
         ExHQ==
X-Gm-Message-State: APjAAAUJiKnQcFPL9eLwYn6rXZf/10e0VTBVAqXcUaKJoEkbiT0sCWCQ
        RwcdHSWZR+2lVyxBP1Sf5fYAed/W
X-Google-Smtp-Source: APXvYqwKQiSbeqGG7Reifq6paMKROx1aC41jATU1w/T9e4K8juM5h6TMvwfPVp/tSVCD4m/BQ4wA5w==
X-Received: by 2002:a1c:1f51:: with SMTP id f78mr8878419wmf.28.1552055488206;
        Fri, 08 Mar 2019 06:31:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t3sm13495654wmc.20.2019.03.08.06.31.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Mar 2019 06:31:27 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/7] kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()
Date:   Fri,  8 Mar 2019 16:31:19 +0200
Message-Id: <20190308143125.31168-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190308143125.31168-1-tstoyanov@vmware.com>
References: <20190308143125.31168-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Yordan Karadzhov <ykaradzhov@vmware.com>

The modification of the last bin of the model makes no sense (this is
my mistake). The comment above the code that is doing this modification
is partially correct, however it speaks about increasing the size of
the last bin, while the code below the comment changes the lower edge
of this bin. The actual increase of the size of the last bin is done in
ksmodel_set_upper_edge() where the lower edge of the Upper Overflow bin
gets shifted (max + 1). This effectively increases the size of the last bin.

Link: http://lore.kernel.org/linux-trace-devel/20190221124205.21115-4-ykaradzhov@vmware.com

Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
Fixes: f97e31f00 ("kernel-shark-qt: Introduce the visualization model ..")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel-shark/src/libkshark-model.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
index b6d3612..4bd1e2c 100644
--- a/kernel-shark/src/libkshark-model.c
+++ b/kernel-shark/src/libkshark-model.c
@@ -266,15 +266,6 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
 	/* Calculate the beginning of the next bin. */
 	time = histo->min + next_bin * histo->bin_size;
 
-	/*
-	 * The timestamp of the very last entry of the dataset can be exactly
-	 * equal to the value of the upper edge of the range. This is very
-	 * likely to happen when we use ksmodel_set_in_range_bining(). In this
-	 * case we have to increase the size of the very last bin in order to
-	 * make sure that the last entry of the dataset will fall into it.
-	 */
-	if (next_bin == histo->n_bins - 1)
-		++time;
 	/*
 	 * Find the index of the first entry inside
 	 * the next bin (timestamp > time).
-- 
2.20.1

