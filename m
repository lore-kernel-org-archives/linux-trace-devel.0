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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E57EC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C9561A0E
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbhCXNF2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhCXNEm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:42 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FACC0613DE
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:42 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id b9so24387053wrt.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qvFUgy6miIeRLIu13Cf1pJ72y5BXBpHZC3n7LJ9dlbg=;
        b=Tnk7OlgaplGvlZ+CyTB/cwoyKRk6hZNFoMa8rEVYThDJ+87SvFUu7UbbbFLZDa1UQr
         CppjLrXgxteYRJAsx5RjmoRJTWPYlLblT6bU5GcimTl78FIA+K8GyEAKrO+dGxvlJMFb
         ebuKN/7hmrtUFyxU/CAWUepR3JyF+NimYiuJqH2n2u2F0g1VUYcQ9v0Y4SyhkLC1VI/N
         7nmwICuEdIrrXbj6bJzUAvWvFv4ZHrkbzhX7gbExBpiSXn1NBuHzKJfwsfs1olnc666R
         dwziE5/WeAr4ccRdSuYibs7RD5Xt4QQbfVXR/i/t5u9A7NUuvDO1fXMGCGIXXep5evdn
         stqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qvFUgy6miIeRLIu13Cf1pJ72y5BXBpHZC3n7LJ9dlbg=;
        b=pcfBBilynjt+YhW8mJf/vocbsbE1RfX0HuAvxDc+hl7A+Y2XVRpIp886MhSpnTGPIr
         +0FkqvBddLIlv/kN0AlV2s1SiEVshDDtvoW4wmgy6fPh8ZXAaExM12D0uWnnlkm0T7Ls
         Eb58Zu+eIduVQ+T3U0mvtiiA8xPw02OVrwfzQX1hy34jCL13fHUcOm7aDgHyxRT0ntDp
         Vn9N+Tw8eogaRcSzIQFx5xoylPdF6Rfp80H+EzmqIN6RTa6xgpd6on1bILIzWq8/1fux
         Jy9N/PSYFzYLkFYtv2/U97Ky1oh7+KZg9NKagyPns19OKwrcXCuKlTs6sajaplnBahlo
         DPpg==
X-Gm-Message-State: AOAM531Ff1kk3wjMrCH7AQhVArGVKjSdDpstd7984RtipD6/UJCwGZbs
        UK+ksdIBbsVJYZGj80vS3Z5Yy3SZD43BTw==
X-Google-Smtp-Source: ABdhPJxZ6jA0OLqjKBO1F8XtTxsFihowAcHUXTmTjpQpUOWCoLenEyQVGLK6EM2Ec8sLU6E+u+qcDA==
X-Received: by 2002:adf:84e6:: with SMTP id 93mr3246461wrg.376.1616591081133;
        Wed, 24 Mar 2021 06:04:41 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 14/23] trace-cmd: Convert tsc timestamps to nanosecods when reading trace data from a file
Date:   Wed, 24 Mar 2021 15:04:09 +0200
Message-Id: <20210324130418.436206-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is information for TSC to nanoseconds conversion in the trace
file metadata, use it to recalculate the timestamps of all events.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e1842cce..266b0b0c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1196,6 +1196,23 @@ static void free_next(struct tracecmd_input *handle, int cpu)
 	tracecmd_free_record(record);
 }
 
+/* This functions was taken from the Linux kernel */
+static unsigned long long mul_u64_u32_shr(unsigned long long a,
+					  unsigned long long mul, unsigned int shift)
+{
+	unsigned int ah, al;
+	unsigned long long ret;
+
+	al = a;
+	ah = a >> 32;
+
+	ret = (al * mul) >> shift;
+	if (ah)
+		ret += (ah * mul) << (32 - shift);
+
+	return ret;
+}
+
 static inline unsigned long long
 timestamp_correction_calc(unsigned long long ts, unsigned int flags,
 			  struct ts_offset_sample *min,
@@ -1283,6 +1300,10 @@ static unsigned long long timestamp_calc(unsigned long long ts,
 
 	if (handle->ts2secs)
 		ts *= handle->ts2secs;
+	else if (handle->tsc_calc.mult) {
+		ts -= handle->tsc_calc.offset;
+		ts = mul_u64_u32_shr(ts, handle->tsc_calc.mult, handle->tsc_calc.shift);
+	}
 
 	return ts;
 }
-- 
2.30.2

