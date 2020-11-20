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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8D0C6379F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F10822227
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:43:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rEP3t1ds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgKTJnn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbgKTJnm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:43:42 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F29C0617A7
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:42 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id f20so11981314ejz.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:43:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=rEP3t1dspgH7LYZTDe1xvE4DpKfbJisNv6gH1f3acAdY59yQYQVmdYa2bakv9JKoLd
         pnbKXL/ENq4LPaS4VfqogWXXyo3DNayQ+Z5mGSp21c1UcRiuKvarDBdvwAQSpS6dXQ9K
         m5oPXcx4n7ulsWYslWo8gAZC/lLydOoNF36dTQulv1YdZsKyAZguqmrNwJ0GnglCZLC3
         /+BdLvc/9YaQX+5vJTOQzMEhdnuvH6YiFdcboQx37X4Q9RFzizQYbqLeo2P8H/nTxKCw
         i0CroxxKjkcPZaunUFbAO5m0kWIovlZOVn3X9kB3YstZrOZffBV4q7expic03T3FLvF7
         3RLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=tpGAK772cl0EW4dKBuZ6YSJ6rAAcoaLVS+nFVVUNNCQ69hA0GNylFxhF4GmhsxuCn9
         71d7RBCbt22DmytTdS2HwHjEHcId3KY2I2Qb3f+Dalfpac0rHRWgq6Ktzmc9ohiOpxZ3
         FtUm9OXyLmPmhOF15uwLiKNv5hzMOwnNgK/h1SlM1y2jp2RXfKGhvfVUgXqOyqaPNMTL
         IT0/XtM9l+J3ngcz9LFhSWEgLzhkp+v0XIuDhDylmxoxwqCK/x49jkSY/nTB1a/Vrut9
         mHiWD4n3cvV9x1r5grDCpLjfLJt95+d344fly71s2KRPi+qvmS3HFvZcbzBraIQ+A0/c
         0zyg==
X-Gm-Message-State: AOAM531OxT+mChy0S9qD7z91m5D0i5g8O4qHAZuxhmI1MKCq+xAFqiRN
        yEwAibcTyPbqNkVgFcdpIE0=
X-Google-Smtp-Source: ABdhPJzmZhYYQt0OIScST/CWg9ljV7ubDhxd5tgmlmQmcWKmX0UquTDPQBWcupNprsFRWS6j43pPWg==
X-Received: by 2002:a17:906:4e90:: with SMTP id v16mr33518480eju.477.1605865421198;
        Fri, 20 Nov 2020 01:43:41 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id h2sm897006ejx.55.2020.11.20.01.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:43:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v5 17/20] kernel-shark: Add ksmodel_get_bin()
Date:   Fri, 20 Nov 2020 11:43:01 +0200
Message-Id: <20201120094304.271502-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201120094304.271502-1-y.karadz@gmail.com>
References: <20201120094304.271502-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The method retrieves the Id of the bin of the model that contains
given entry.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-model.c | 27 +++++++++++++++++++++++++++
 src/libkshark-model.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/src/libkshark-model.c b/src/libkshark-model.c
index f3864bfd..2301b069 100644
--- a/src/libkshark-model.c
+++ b/src/libkshark-model.c
@@ -1325,3 +1325,30 @@ ksmodel_get_task_missed_events(struct kshark_trace_histo *histo,
 				       match_pid_missed_events, sd, &pid,
 				       col, index);
 }
+
+/**
+ * @brief Find the bin Id of a give entry.
+ *
+ * @param histo: Input location for the model descriptor.
+ * @param entry: Input location for entry.
+ *
+ * @returns If the timestamp of the entry is inside the range of the model the
+ * 	    function returns the Id of the bin it belongs to.
+ * 	    If the timestamp of the entry is outside of the range of the model
+ * 	    the function returns UPPER_OVERFLOW_BIN or LOWER_OVERFLOW_BIN
+ * 	    (negative values).
+ */
+int ksmodel_get_bin(struct kshark_trace_histo *histo,
+		    const struct kshark_entry *entry)
+{
+	if (entry->ts < histo->min)
+		return UPPER_OVERFLOW_BIN;
+
+	if (entry->ts > histo->max)
+		return LOWER_OVERFLOW_BIN;
+
+	if (entry->ts == histo->max)
+		return histo->n_bins - 1;
+
+	return  (entry->ts - histo->min) / histo->bin_size;
+}
diff --git a/src/libkshark-model.h b/src/libkshark-model.h
index b8624809..8989ee0e 100644
--- a/src/libkshark-model.h
+++ b/src/libkshark-model.h
@@ -175,6 +175,9 @@ static inline double ksmodel_bin_time(struct kshark_trace_histo *histo,
 	return ksmodel_bin_ts(histo, bin) * 1e-9;
 }
 
+int ksmodel_get_bin(struct kshark_trace_histo *histo,
+		    const struct kshark_entry *entry);
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
-- 
2.25.1

