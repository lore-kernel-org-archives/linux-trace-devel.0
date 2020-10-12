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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC249C433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EFD72222A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Oct 2020 13:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfmjEOsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgJLNh0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Oct 2020 09:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730992AbgJLNhO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:14 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B9CC0613DB
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e23so10179411wme.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Oct 2020 06:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=bfmjEOsY0HtsjlcKsTjmSaqNHQ8oIHPY53PEN3hWBBcVCvcboqhpLjI1t/vmTtRNVi
         MHSb7K8kbA+tV/x/MQLbWXOniwJHOMtCDXJlDULxEV9oIpzaKoBycbr0s0oJ+TgNE083
         AW0kThI1aawcJqysXFV15j0ToBWnli/SkxPHXo1YqUuclmK2iQHVadJP+c7kWDmgJqnq
         mJL3omuCDDq55Muv494pjW0lFQxG9Li9cuWY84FI3YCjbrsyqstFSkKm19Wes7vyqFiD
         TS20S1+XStEkCzF6XtEpOCEHanuCsz16bESY1rkXbdV1JlS2cQERcZoW3PWiBa0rO07P
         UBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rX9XfHhXf9sK0NoFo9P7mnliYZ0IH4YeOB5MqGmFCZI=;
        b=KAoKWpGM9DlNG0rdFa2cx5WXRZbkPflMshCrnczgBbSa1OidpS/ft7UyG8GekEDMwZ
         OqVRcn1Otw2XmVdFzjvSH2oQ45GA9cKPrgd7BApGdqKPeguR9hDcZ3ZihdU+Wr+9ek3T
         oixMNkALR8B3j/7PQa7PDoK+ydnQMKlFnlKs9EpNBOb1JZq0GFTb5vxgtToAS75nW5k1
         VyN8MzEfXwEkiYQGsx3iDlNwcg4PQ8cD4vZRriY0dLnJ+mICQ+3c1e7PKUfYvn5MNzg+
         7Fdcq8/ajr75scyyiwpNfly312J/XrdE5xWnSCUaszRRSTQJ8L8wJmgBdg5B/zlejjoz
         iXJA==
X-Gm-Message-State: AOAM53045nMnlTXLHLKgBoHtLcd12mXPfJWwmu5J29aW2ijQBhJ5yV1g
        3WDfnl0caeYt1Ua9cV9o+Ds=
X-Google-Smtp-Source: ABdhPJx9Fs0XCnkxl/uzxQiekCGu7WDvjrkAYCD4sDLZkxmtf+3KDUemItyQoUoZnDKETj0i41n3CA==
X-Received: by 2002:a1c:1dc3:: with SMTP id d186mr10412074wmd.182.1602509800085;
        Mon, 12 Oct 2020 06:36:40 -0700 (PDT)
Received: from localhost.localdomain ([84.40.93.41])
        by smtp.gmail.com with ESMTPSA id k5sm23145388wmb.19.2020.10.12.06.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 06:36:39 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 18/20] kernel-shark: Protect ksmodel_set_in_range_bining()
Date:   Mon, 12 Oct 2020 16:35:21 +0300
Message-Id: <20201012133523.469040-19-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012133523.469040-1-y.karadz@gmail.com>
References: <20201012133523.469040-1-y.karadz@gmail.com>
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

