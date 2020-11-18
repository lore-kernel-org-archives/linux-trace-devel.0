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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8630C64E75
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F5C246EE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 18 Nov 2020 14:51:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5wnttxE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbgKROup (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 18 Nov 2020 09:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgKROuo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 18 Nov 2020 09:50:44 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F06C0613D4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:44 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id s13so2971802wmh.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 18 Nov 2020 06:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=s5wnttxEAY2qim32vPFY1w+U2+mlGeCQyDltmz2/twyxX29RSXhtT7GE15FAF3ciX4
         g42ek/E3nQnJmM4WSuqBzxRQlel1rAUF3Mw5x1JZbhPuGacYZ/9MlE1oSisGm8r2euVh
         6f9a9qqTwZu17Mh3lG9jOn/TYF20jY7hPQZy39Pz4lhOzu86lOw0f5dAvYmyIaOdIMRE
         cQV1B0MIuVa1eDF90tF0j3pj4Y+oiTSA61DLzp3dsw5Z+hAIqsh3VCUI1tzTUqLzd2J4
         8d8EeT+KnBGIztyNcm5PzOnb/xSVYol9Rt5Slv2GUjo/OJPM2SfdFrPrR4zCLKTAB3xb
         VO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7pkMWcXJFtNywsHJwHLLOPKrqZCvPFvqytyCVXU6To=;
        b=BOTg4McWGl4MdhBPm/Xk48K2zKss7WwLEynEReoLN4ITCA3IchDxftkihB8T2v/xnp
         9pglhrcwUSBp+Ut2SgK7Aj0r1SV+fhVSnr35NHfXN9Er5nY3NCDfDIc8XL8q6UUOj6r5
         ASifUQ8CejBNl48yg28KcONys60TzMXq7gJ8uAPoGgyWiCwcWSCWDFFqV8Ii3c0E9HPb
         vdC/BcPGv/nfEQ1aDYQEE2YGlTVSbEIDaAzOhL7LCYQkmnhi7I3RTDkaOc7zFZ+6+VGw
         8ethqbue8GG+BzQef+H5IGB6eYn/M/vkDx3G0ila3nZtpuINaKIyGuT+HRGMdtOGeybS
         5Daw==
X-Gm-Message-State: AOAM530DeaBf0mfq6BuyrJr/wTKmqcsiwrZ0rKVr/i2xMMx8a6H6oV2r
        EtOlnsYwzP0b2n+1cuPErJM=
X-Google-Smtp-Source: ABdhPJy3Ecj0uXyYOi99myfSMSYezqyfJMJvjzlAVcDR8NLNtm6BujVEpcqdd90ZrGPpwVPJa2shUQ==
X-Received: by 2002:a7b:cb09:: with SMTP id u9mr398503wmj.49.1605711043142;
        Wed, 18 Nov 2020 06:50:43 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id s202sm3926190wme.39.2020.11.18.06.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 06:50:42 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 17/20] kernel-shark: Add ksmodel_get_bin()
Date:   Wed, 18 Nov 2020 16:50:00 +0200
Message-Id: <20201118145003.156542-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201118145003.156542-1-y.karadz@gmail.com>
References: <20201118145003.156542-1-y.karadz@gmail.com>
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

