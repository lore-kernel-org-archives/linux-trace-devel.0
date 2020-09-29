Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE68C47423
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E93208FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 13:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvhehLYH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgI2NmQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 09:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgI2NmP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 09:42:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F939C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:15 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k15so5439176wrn.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 29 Sep 2020 06:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=hvhehLYHIdihsU0LS0tQgX9ziHLVqAaVdGePI93XqG/Rs7JoNuPoOEkAXaP3+bhzw7
         41c0pJhxw5HTjfeH7wSdDjrMc8MY8XJ0TLrkDLlHyOa14gjP9AnfYLm9kTjqyn1XROmi
         jcWIhM3q5Bkjvxo9/R0QCXv17P04kVrT7DI00y8KWmhw6khRk4I7OEa6nh2mlxRzeIyH
         UNuvf3VUIMR//5WOty87/eMm7Sc4AnGvxjsy5DNrwi1X5ZjRnMeihA9E6FFJyV5HQC9D
         YD/kPx/ZtiBJwPX5V+5mK+d2w98+klkSqaW3kZHX/asvOuHCzSD5IDHZldAd4iF9jd5l
         dNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=hWiauKvHgTHtlAQuHweJlJTWnYf3EiSQPrADnYurgSH3UVs5HXNK7OxZRQNlPJvUx4
         6W5fDkWQis8rJKZhYLQrWbCjby7W748BE1+ochqbbu70lm0fGmPWz0zgJE893yDilskF
         5Cnjaxq+3T5PnOVLEA52n093DzFiCcFjf7gXItT3OhCaCKeDfAnmoPVliDxwQa5+AgZa
         A6ZeENzKAupVPXYL7JqWRFKlcQ5NkQ4EhsOFHWI+4iotlpuc+yDXQZITkD7A2r2FKGdu
         yuO8XSZvTtDMAqwyyZ2w6kjtDavePgyR0Z//sV+fohWsynY3L/4GDNZxmVv5RbceStSr
         Ig5g==
X-Gm-Message-State: AOAM533ZqS8Yw9qJmdUAuNMgXKbPCOuJM01ITXiePd5NTBrJsHKEUALu
        ES8uBnSs0LWUblwNYAg6lT0=
X-Google-Smtp-Source: ABdhPJz5Fk1YVmaUJFN0roxYS2WziJyIr3elJBqFUV3TDxFF/YIrUzU0Vu0ytw1yqVseD209q4iOkA==
X-Received: by 2002:adf:f88d:: with SMTP id u13mr4710799wrp.213.1601386934235;
        Tue, 29 Sep 2020 06:42:14 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.108])
        by smtp.gmail.com with ESMTPSA id b84sm6162792wmd.0.2020.09.29.06.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 06:42:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 12/15] kernel-shark: Add ksmodel_get_bin()
Date:   Tue, 29 Sep 2020 16:41:20 +0300
Message-Id: <20200929134123.178688-13-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929134123.178688-1-y.karadz@gmail.com>
References: <20200929134123.178688-1-y.karadz@gmail.com>
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

