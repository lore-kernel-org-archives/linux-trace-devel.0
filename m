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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5077C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B045206B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbhADRtT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbhADRtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:17 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8414EC0617BE
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:03 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id b9so37958557ejy.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=q3GcNjkBRF+0mZ+cYlr5AlismvFZRLPhWa6LotBRObndNAI7U982u9X8Ck+9CHeu93
         gphCXdgkkze0yJGihY/6DGbdoph9pzz88IiIVVubS7NWuAZNP/PgCnvA2AVaisTdOiAM
         vBvfWSkbem2ueT8vyH26XWD4PpwlG9jHtZcnCh4iPuo+VFnN+Pgi+EC4g/h/yRCVRQgj
         m7gKc/O4dRqLLQv3dPOzVOMHCqwlrjrbhPi2urkDOoKBEVvXsUL8Tz390jPUu1R7nTHI
         j6G95+SZd52O2ccjVegvqMPe6CPoa4VOoEcc1xdqiXZisxewJOTKjN1CpqNQGg82DZtU
         bY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=VBb0Bq8+FaKs9GZt64B2jmTgVa8mxVKK3QePXd7vWA1YYjuMsmnOTwCupaV7fv44sn
         cYUeph4yxT75uQQhzVbTUDKUt7+o43z8fA+0IK2aryQgid5QM5b1AbsVg7lrtsbA/IKT
         nP7iVFi2yiEx03wLBwiG54xGfqen7jsMiRfw2vS32oIxQYJvYXtksh3BchhcsZQiBlnJ
         LpSFlqZNNRpclS3wUaOeKWNMTB4A8+kCyXjOSgQBkF3hnG6Rz8cVdBtlDxEBH20/b3oo
         siBo1gW1bHpffzTeHN7O/50CcTx6C2OKFESI3X2rroOrvPWFX1HngpqQKPkqbXdmj4Dw
         uq+g==
X-Gm-Message-State: AOAM530AY5jS5SN3wXxCftNJVxVmxZqXyPykn3PoP9nKiCQH1ldMb4UM
        SI8Z+tgcX60TDuVrgQSDmIo=
X-Google-Smtp-Source: ABdhPJwvEtcMrFVzUoQIfsPd+GNeH4YCCjvRQ0DSwfbo8gCpPjld5hQ/hEtzEQVMDybxEoxrQeYb6A==
X-Received: by 2002:a17:906:5293:: with SMTP id c19mr68464483ejm.72.1609782482293;
        Mon, 04 Jan 2021 09:48:02 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:01 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 25/44] kernel-shark: Add ksmodel_get_bin()
Date:   Mon,  4 Jan 2021 19:47:05 +0200
Message-Id: <20210104174724.70404-26-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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
index f3864bf..2301b06 100644
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
index b862480..8989ee0 100644
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

