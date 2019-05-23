Return-Path: <SRS0=hb2W=TX=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F323EC282DD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D58F920856
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 May 2019 15:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfEWPKI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 23 May 2019 11:10:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39017 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730756AbfEWPKI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 23 May 2019 11:10:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so2103761wma.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 23 May 2019 08:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UsHaSwSYqaEfZCjR8nTLFDCgOG8KHp7nw1/cLADerdA=;
        b=R7ltQqcJzf7RXokKGxg+iLJKCnNliYsDPeKV6hrFRWioKHltbPmK70KHA++s7kt9aq
         YkdSRaXffqXw3BjCx9mbUVw2GsVJVnz8GhhJD5+URvshP/GR3BYFl9FWC8UIjW7Rn53a
         jQeazI+plWhpPmF/Ts/COUV0rYKm6dLw4W6lR2/1scScD+Iv6V4c7/VZOVY7nhHxuJYj
         GOkEC3l7hrD6VdJMcO60RA8rxG5t1L7bgX21Dkj5stHiZo+JTItoF3HCcSRz1ni6TqAW
         eicBuQMGd8QtmBQEg2nbkBOgLAmyUkiFQ+bEr2nlTTvMESiVQjKVRiuBej9aUEEyy3Mj
         9fjA==
X-Gm-Message-State: APjAAAUHcC+lH6yB+xBLgdDu1RFgKJdDDeJ4EubJj9NCf7h2DBToRg1+
        aPF0Lmk2X2YoerRlx18yyC8=
X-Google-Smtp-Source: APXvYqy2hD3Rdql+5tGVQNXhKRbcu6lPWnhOwhByZvy8r7VjY2GPZFzxE/vLAOexBKNgM91zigl1Mw==
X-Received: by 2002:a1c:9a14:: with SMTP id c20mr12925861wme.61.1558624206436;
        Thu, 23 May 2019 08:10:06 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k63sm10721996wmf.35.2019.05.23.08.10.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 08:10:06 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 3/3] kernel-shark: Correct memory management when data loading fails
Date:   Thu, 23 May 2019 18:09:46 +0300
Message-Id: <20190523150946.30769-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523150946.30769-1-ykaradzhov@vmware.com>
References: <20190523150946.30769-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The erroneous case, when the memory allocation failed during data loading,
hasn't been properly handled.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/libkshark.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/kernel-shark/src/libkshark.c b/kernel-shark/src/libkshark.c
index b0018f8..175279c 100644
--- a/kernel-shark/src/libkshark.c
+++ b/kernel-shark/src/libkshark.c
@@ -889,12 +889,6 @@ ssize_t kshark_load_data_entries(struct kshark_context *kshark_ctx,
 
  fail_free:
 	free_rec_list(rec_list, n_cpus, type);
-	for (count = 0; count < total; count++) {
-		if (!rows[count])
-			break;
-		free(rows[count]);
-	}
-	free(rows);
 
  fail:
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
@@ -924,15 +918,15 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	ssize_t count, total = 0;
 	int n_cpus;
 
-	total = get_records(kshark_ctx, &rec_list, REC_RECORD);
+	total = get_records(kshark_ctx, &rec_list, type);
 	if (total < 0)
 		goto fail;
 
+	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+
 	rows = calloc(total, sizeof(struct tep_record *));
 	if (!rows)
-		goto fail;
-
-	n_cpus = tracecmd_cpus(kshark_ctx->handle);
+		goto fail_free;
 
 	for (count = 0; count < total; count++) {
 		int next_cpu;
@@ -955,6 +949,9 @@ ssize_t kshark_load_data_records(struct kshark_context *kshark_ctx,
 	*data_rows = rows;
 	return total;
 
+ fail_free:
+	free_rec_list(rec_list, n_cpus, type);
+
  fail:
 	fprintf(stderr, "Failed to allocate memory during data loading.\n");
 	return -ENOMEM;
-- 
2.20.1

