Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15551C56201
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6DAA22248
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 14:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0o7CHp1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgKLOYi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 09:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgKLOYi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 09:24:38 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C119DC0613D1
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:37 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p22so5432394wmg.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Nov 2020 06:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=G0o7CHp1zEWXeZPRHsoN8iwflUm8E+NC34jv+FB0uUt1vUyDlJThp6TBQGnm/VHK+f
         OeAU/+sld3qfj7g3okv5n0Rbgl/bpSlKdYF/934FqPO3MtZw/5ecx+Oq6QLbQzmH7J7v
         9D1xMjDXt+rZllVM4GBY4SYpw+sHIedxpsd7r0Zc0SaiFRqQSMIecF6/kiERDFx/JWCg
         tMWNHVwKwvJUqpjZNsspXUxPIBf2KMIj6STO2Sw7WDcWYsLzxrT175YAc+Vu+MhkF+Jn
         c5zKNFiStmBbFeXO+4Tw3k+jvv8MvtU1bVR0TledXfEf58XdwFFIY7lXY7pqnloD92oc
         vlgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=WEZCrU0DoMV6VyVOzvDKJhFPbdyrzT67Q0C3BC1KIh+G06cqp0SN7x4WwSyVmM6NBl
         QW/rjIGh8ZXYe1Ze1I469twg0IVaqJPyV4Z0VihgP9/W+dVt3Gduu1UlA8/cyYhXnWxL
         yg5COTjcjdTktPWI/Inyw/1D9GOjOS/y5nMkfsmCisxCW2Pa64mIFRe/8f7nrsjLOpu+
         p23d5pCsng1G3QYQjox9cchGRWPOOy6JasYThXOOu9R2MWIFGaR1cJ5mcBr9pX3/Ob3M
         PxoHUWYxnyP5VgQdodGPPZrqqoFnipRkv9iJ8G+Ju+fBKWfcLjc623lTCOcpw3lV4fCn
         Pttg==
X-Gm-Message-State: AOAM5303nYGy2ZTauZOOnRo8rKC5HLyJIiYbFCRNJLiKkAlTjbgvuEjv
        Fjy1DUeAMN0Bv/cizY7P4Vs=
X-Google-Smtp-Source: ABdhPJwW78/j1TrSU8I7R8NZvLC8agbDG71wuKCoU17PIpfkBPXzheW1BLC7I1LqJjJ+1SdizBlxkw==
X-Received: by 2002:a7b:c841:: with SMTP id c1mr9858946wml.31.1605191076581;
        Thu, 12 Nov 2020 06:24:36 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.214])
        by smtp.gmail.com with ESMTPSA id h15sm6950685wrw.15.2020.11.12.06.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 06:24:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 17/20] kernel-shark: Add ksmodel_get_bin()
Date:   Thu, 12 Nov 2020 16:23:55 +0200
Message-Id: <20201112142358.36821-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112142358.36821-1-y.karadz@gmail.com>
References: <20201112142358.36821-1-y.karadz@gmail.com>
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

