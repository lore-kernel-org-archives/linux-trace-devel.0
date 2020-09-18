Return-Path: <SRS0=8sQt=C3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059ADC43465
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Sep 2020 07:16:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEE7B20C56
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Sep 2020 07:16:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWoXf8T9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgIRHQJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Sep 2020 03:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgIRHQJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Sep 2020 03:16:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A4C06174A
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Sep 2020 00:16:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q9so4275163wmj.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 18 Sep 2020 00:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+49FEeJhAHCArMX3EsrjhWriI9kT19smkTQ3vQEkc5c=;
        b=PWoXf8T9b2tJsW0y/yZjT65k+foeSOkqY2dNT/e07jM09oVx7uBbtkamPItnxj1K7c
         KhNOjaAIa/8//83XiJX8GAOJFAWIKywBAwZoRlFlLSg98mn8Ee28vedUlc7NB1LkuSkD
         ZE8SoLzqxMJn2sNgMVQMWERKrWzU5I30IbvWgoF6zBZAnLQc2kypnBRprTreETJO9G06
         Rao4jSJqYKmHpwaF5kJBX4QIheIuEYpRYZNKW9vUJb7ocjGgwzlRqkCaTSAsNn63AcEj
         UpnEqTtI5+uQH3l5jmkZpm7VrLugxPyMN1BWTliLFsIR7VPRLoUFvtTWePIFGPGWuIhF
         tG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+49FEeJhAHCArMX3EsrjhWriI9kT19smkTQ3vQEkc5c=;
        b=E9IEJpnj1iWWZcVF5NKKdKuaoBKNzntvdQ3gCseCKwuIwBiWh0EK5iCWG2fXkMugaM
         Jr5Lo41yY4QU87QiArvc8CE3psshX2250I4tOUtDWMo3rn4NOSDARe/2c+eFEMZ6XCq9
         QicaJdvznn63k/ZMBQfw6eowu6ReIJH7Sc2/X2jlkRl+mLjR5kkF0rQeAI67dhdkfzYR
         a3Y2AWourFP6f06HgAcGk9/pijRw98qkvzFia285M/RogxB5/Kn5P5kqwDr7wIMAt8XV
         TdlnRiQu3e3twpCr+2kfMwxajhLtoefv9dM4OdHqO//aowQPWu5Lc4yBUY+yt8aBPkBv
         K/wA==
X-Gm-Message-State: AOAM530rzsJba+KfxKBgO5C3NmoqRGoHNCDcR3i5FTnL7wSSEjD2Y2Dy
        V+rLqNL/3/whNpkaIEkSS9+igjKDCBWRZw==
X-Google-Smtp-Source: ABdhPJyEoVATtmXiXhes+bWLlyeWFOzMlruTuQfZLjxWkYU+ub8BdSNT0aj8UZ5Qm07eKgcit8eyXg==
X-Received: by 2002:a1c:2543:: with SMTP id l64mr13156089wml.96.1600413367750;
        Fri, 18 Sep 2020 00:16:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j14sm3769488wrr.66.2020.09.18.00.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 00:16:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] trace-cmd: Write saved cmdlines in the trace file at the end of the trace.
Date:   Fri, 18 Sep 2020 10:16:03 +0300
Message-Id: <20200918071603.597501-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918071603.597501-1-tz.stoyanov@gmail.com>
References: <20200918071603.597501-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The "tracing/saved_cmdlines" files contains the PID to command name
mapping. This mapping is used when displaying the trace events. The file
is updatated during the trace, but is saved in the trace.dat file just
before the trace starts. This could lead to missed mapping entries,
appeared during the trace.
The saving of "tracing/saved_cmdlines" into trace.dat file is moved
after the trace completes.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 4a9a857d..cd7dcec8 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -917,12 +917,6 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (read_ftrace_printk(handle))
 		goto out_free;
 
-	/*
-	 * Save the command lines;
-	 */
-	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
-		goto out_free;
-
 	return handle;
 
  out_free:
@@ -1215,6 +1209,11 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!handle)
 		return NULL;
 
+	/*
+	 * Save the command lines;
+	 */
+	if (save_tracing_file_data(handle, "saved_cmdlines") < 0)
+		goto out_free;
 
 	if (tracecmd_write_cpus(handle, cpus) < 0)
 		goto out_free;
@@ -1351,6 +1350,13 @@ int tracecmd_append_cpu_data(struct tracecmd_output *handle,
 {
 	int ret;
 
+	/*
+	 * Save the command lines;
+	 */
+	ret = save_tracing_file_data(handle, "saved_cmdlines");
+	if (ret)
+		return ret;
+
 	ret = tracecmd_write_cpus(handle, cpus);
 	if (ret)
 		return ret;
-- 
2.26.2

