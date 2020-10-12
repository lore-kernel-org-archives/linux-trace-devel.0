Return-Path: <SRS0=H9Ya=DT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E1CEC43467
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A6321BE5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AO4CFrAQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbgJLNh3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730989AbgJLNhM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC80AC0613DA
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 13so17211638wmf.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=AO4CFrAQPM/4NjVAULdIRxWMC5/ZTQaZzmbrSFXs/fiNya5NS6OEpPA3N7xtG80Tm9
         Z2Qr0RaaaIP2ofwJvxgzSMZjLAdaz83LyPs7PJNbBgYIxtiaGP3htxw0LthGYsVCIpb0
         L7YDYQnqv8ZjkkKhbZEPuHDi/3j10ZfkrDs6xJwDVQWRVwLUNVJDtlPI4cC8BeF3RSgq
         /NOLXSx/IQNUQpIbHh4PdLmmlTCPZRh3YmEL71f03xWX7E1FteadSpoOQL2EvTS/w9kd
         7lxDXZgT4u8NuE+mgG5wlg3WqcCQHe9OuLLwHJ82gbSk+/xdTM11ZSEdCmjVAB0BmJaU
         AyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=S0hK6fmkPocvs/YIwH1UyE9Ms+CDkvhhVT7DGcD94zoj2cMElvq+0P46zgI8+bbXmQ
         JcjFxr0CSGJc+IaqYLQ2gKksJvgiHLlgfP0UjbZ/UHygyiXdNXdS5NmsfE6WzXdaLfbG
         uS726pB/8Qtf6gENSe/VivrnsCoZy5GpL494iOXrwmPtqjyry5W7A88CnpQUBrNIbUb4
         4yRDs6vjEYqEF76Kye9MkgLotyg29slnSG86JS5NT8F8n5L8yF8zxX6dqdvTtIryrIJv
         OzF7GvIzJBRgAV4KReHiIY2h56VzsYzf/sWDA203j1yEdjcuiv4CY2SXyGHfOysND/yS
         FXSg==
X-Gm-Message-State: AOAM531uja7hxwM8n4MHqxN1AZTURuzc4SOOIZrOlQGGdQV0XOaWFj91
        ASzgQNxnEoaMUdvJpkABZ18=
X-Google-Smtp-Source: ABdhPJyNqPzn13oOFSIMOsSZwa8KegoShY4Sb+r1kdFYuxKb0yT3HwUU/cNiIlOrWPddRNiIrrNOiA==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr10414094wmj.145.1602509798504;
        Mon, 12 Oct 2020 06:36:38 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 17/20] kernel-shark: Add ksmodel_get_bin()
Date:   Mon, 12 Oct 2020 16:35:20 +0300
Message-Id: <20201012133523.469040-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
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

