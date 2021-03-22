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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A36C433E3
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2AD061974
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Mar 2021 10:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCVKAa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 06:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCVJ77 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 05:59:59 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D2CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:58 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w18so18568298edc.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Mar 2021 02:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VQlKcKO67KfSyJNyl/8Q71K1fUi/rYirm77sz0vwbx4=;
        b=TRgXPqPJPfYOB+ReP3Xahi81DAeq28Lrf3uup2Gc+nx96f4Cb1VEhxpcQMgPPNjWfa
         CTm6Nb/pjFD8OI1ClfypHxcpZNWMw5ycBKZG8UIhYz2LBPpR3XI9RHDgWy89ljuhVtuH
         rEVIEOQ5T1gew68Qyrd8LGSKlJhUBVm1OroFDeHkOrL9+MPBWHpbWooXE6ht62q/Le5l
         zpehlPkBdwrF72q/1LE2hQAYZegyiSH1nKpZ1m7MFrBpjJpegj2y28A0cRxZMVVPqzmZ
         tLwJgdCyKc57nJyc8WiAEAbEGyTZiP7ELLTHdlUAQq1qnRHcWNCEjGVx4Vb9wl7OfGRj
         bbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VQlKcKO67KfSyJNyl/8Q71K1fUi/rYirm77sz0vwbx4=;
        b=jlQf28piXkg2czRMWIO2/paiehtC7Ukx0wV5kpjHU0jGAxgfHaMVZGnPaJYOq1NWRj
         CBGhljhTgtER74BOMEwtEZfJxX8w56dtGDPImf8VqrasC5ykLV685THBEUAcLNje/3hx
         /ZcGntuhoRfML9e6W2tgmWo1iT5fTCz2HiCjWUObiEOrv3vLQbrFpsjiUIBgJ8A3jryP
         /d/x4KaCtr2nAMS3xj8x8oU9IgJnGnrQACJa8Hrm56GNnMzUBXlWvZjvFA+eMUKdtcCa
         3P9j3WxzAOLf3utb/Y0YcOcXv7gQXwYB4vMAMwjv9fOsLhpvVxYq604sx4vgMl0ARX4N
         7vmQ==
X-Gm-Message-State: AOAM531DWEPTWlYcO7SZtZ2bPnyltlKmXnlVZklFRzdbPkTLNxC4J0Tt
        nWUlMtAEgbtLDP7iKuZ3zN3H9JBSuMmTag==
X-Google-Smtp-Source: ABdhPJwAQb1W22X+Inbrbr8ari0ZKS1LHo7Ak4DH+mnqclOXs8VzCgmkz3T5ysgQ/xqnG4qppxFJgA==
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr24536324eds.31.1616407197587;
        Mon, 22 Mar 2021 02:59:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g26sm9288424ejz.70.2021.03.22.02.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:59:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 11/18] trace-cmd: Perform all timestamp corrections in a single function
Date:   Mon, 22 Mar 2021 11:59:38 +0200
Message-Id: <20210322095945.259300-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322095945.259300-1-tz.stoyanov@gmail.com>
References: <20210322095945.259300-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading event timestamps from a trace file, there could be various
corrections depending on the metadata information from the file. Move
all logic that performs timestamp calculations in a single function.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index be8a7919..dfbe4af6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1276,6 +1276,19 @@ static unsigned long long timestamp_correct(unsigned long long ts,
 					 &host->ts_samples[mid+1]);
 }
 
+static unsigned long long timestamp_calc(unsigned long long ts,
+					 struct tracecmd_input *handle)
+{
+	unsigned long long tstamp;
+
+	tstamp = timestamp_correct(ts, handle);
+
+	if (handle->ts2secs)
+		tstamp *= handle->ts2secs;
+
+	return tstamp;
+}
+
 /*
  * Page is mapped, now read in the page header info.
  */
@@ -1297,10 +1310,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf), handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
+							 handle);
 
 	return 0;
 }
@@ -1930,10 +1941,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.30.2

