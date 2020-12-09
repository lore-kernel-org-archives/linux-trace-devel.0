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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3CAC4361B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 502FA23A02
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbgLINoT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732556AbgLINoS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:44:18 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C9BC0611CE
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:42:34 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id l9so1774603wrt.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=YXA3tfHFUuHctxqtYQ0CFM1yyM+Xs8kIIIAZbckfXvKH0Z0UryK4AFy9wDLvA7LU2x
         xtxtKeiA35NqpGXh0gAqL7Zjqhgb+TWEdmweeruGBuRn95uquscaO/rWevXp0cmbcl7k
         xE0rccPndhhPDtsbRZPJWnivHUE5NoZGlFjT2gKjr7qXvn2RL1U5nNVqXL2/weIsSMiY
         /fST9UsRup54lvWgwAOwqxkkuCPJjtLfwt5/hKL39ZIGvzvfRp3wSfsftL8fjppx9S4A
         MEH9DEwJUBgWqMA+eh78/Tit0dP1Y4FVYHGhgDtPt+egtXRZosSkzO13r4XkGWOmOKlt
         w/gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m9lQFJuvJrwOAGItYL0Yq0F1uOB4F66QAhKkaIHI7D8=;
        b=cBbi6Xe6dLxxtoMIvsRdtbxviz5A81YxYIIJgVp63//OGEA+Mjq9m87jRreVKU3TTp
         daLh/+yeOhU0Sfti0y7GSjHD2JL0MYXAyZPcp2/agCSVoDHVY72cimyex9TeDnEpFzqj
         I9BTtHo6Uvxfw1ZtWX9wOSWmoiYLG4LJoAxln1g8y30Q3JsoCzQUWG3BLNPtxvQ6tlyk
         TNEcu2Gm+F0l1KH6wrujHnkOMMdhO3s344Y1ycpdlo6l+HDnML07qCXlKi3gqaffDYzh
         4is1eYFj92iExRsrEJAkOBu52yze7vm0sgM0ujGoC2LFRCDReqDnA3RN4WW11Gpaq3bv
         iwoA==
X-Gm-Message-State: AOAM531YpOUaje6dVlZMVUbaCoDeriFNrxo9EPs4IAy+HEpdI44lwIxv
        jgGtVDm2BNhl6QLIa+v/WDtPrg9joBE=
X-Google-Smtp-Source: ABdhPJzz2DcDrOY9i8myqL4mTSuhIRTAZjeYGfUzd3sZJLuj/eAJ5R0fitHQJY1uyQ89FjR0o+/nVQ==
X-Received: by 2002:adf:b64b:: with SMTP id i11mr2811220wre.78.1607521353703;
        Wed, 09 Dec 2020 05:42:33 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id q143sm3871071wme.28.2020.12.09.05.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:42:33 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v6 17/27] kernel-shark: Add ksmodel_get_bin()
Date:   Wed,  9 Dec 2020 15:41:53 +0200
Message-Id: <20201209134203.428068-18-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134203.428068-1-y.karadz@gmail.com>
References: <20201209134203.428068-1-y.karadz@gmail.com>
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

