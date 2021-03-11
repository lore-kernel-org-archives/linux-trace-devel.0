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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32792C43333
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED80564FBB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Mar 2021 08:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhCKItt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbhCKItX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 03:49:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48EEC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:22 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j3so1524722edp.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Mar 2021 00:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FRK7YrP3vAmeLQ4bYf0AKVl73RxYXJHpz9lk9pfzyNo=;
        b=kQ1Dl+HHQYJNLBduwEhOrshad4IJNImIwi+FEjzfayV0QjbSjb9LxIinueEVYG4Ujv
         4wCyqk010nrW6chH8Km9KNRPkyqQ6Hcs81aYZMIuPdJcndeAbky7s3g0MoKVovz6p+YW
         W0L3uFGLC5S4nxxN/Qcp3wYVD99qM4eVl068d+0pXaOyWRxGw+7K+KTedEpCBw2+qQBr
         /r2QigLr3954sizunL5NIyx4jz1xQeTAfSgOkCyKAIMd9FBTr8h7JuNtnlbfoDja8yrs
         0ysdc4BtuC1Hedo3pS1FV2fHYOM9/1lLMFxaesV/9jfNwY6He6+9bFzmjXvMXPJUIEga
         dhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRK7YrP3vAmeLQ4bYf0AKVl73RxYXJHpz9lk9pfzyNo=;
        b=rCggzrUKzN2dTgDsWvMOqD2dC8xbQCLoAzY7vrXaXP0aP/I/MEfk0bgEcXJdk0F/RZ
         Qc8pBxAWjJg1Gas8lYJyxAun+zzPMKwzVvumQ+drt97agoQDz2+aTaJudn3EHWsAJOO3
         OWGrfas5KxwNcegKOXTUA+PC5N5ojxNXCPhjnXHhI7W2PvCFh1Ypb7x14uBGOgQOB1Y7
         QImxe//abkVwfZm0fFOyceUzEa377neM5VUpgyeT3kDkx5ytB8wHqdxe04PLDUvkrzPf
         zwJfoWHt84xXATBAmODRoFFGYBDOUIrCe0MZqsNkK2szlVzcyw0nT3auweIEOQPGhAFH
         k14A==
X-Gm-Message-State: AOAM5312JGlZEt3iXbZr9Yxqyl4K5GFSebOYcgAIQOUuv5LoYwMt//L5
        HW9p4VEk5tYiEIBqXMrTmJujBnBeCyogCw==
X-Google-Smtp-Source: ABdhPJylmmkYBdH7O5WV5uZyL0dXZVK1g0hKtlyT+j5yGnU53G+MACuFLxHrgPbHZGNEAW/N5U0rNA==
X-Received: by 2002:aa7:c1d0:: with SMTP id d16mr7297227edp.153.1615452561362;
        Thu, 11 Mar 2021 00:49:21 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id fi11sm901647ejb.73.2021.03.11.00.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 00:49:20 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v31 15/16] trace-cmd: Perform all timestamp corrections in a single function
Date:   Thu, 11 Mar 2021 10:48:56 +0200
Message-Id: <20210311084857.1919805-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
References: <20210311084857.1919805-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9bdf9da7..60a59873 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1287,6 +1287,19 @@ static unsigned long long timestamp_correct(unsigned long long ts, int cpu,
 					 &tsync->ts_samples[mid+1]);
 }
 
+static unsigned long long timestamp_calc(unsigned long long ts, int cpu,
+					 struct tracecmd_input *handle)
+{
+	unsigned long long tstamp;
+
+	tstamp = timestamp_correct(ts, cpu, handle);
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
@@ -1308,11 +1321,8 @@ static int update_page_info(struct tracecmd_input *handle, int cpu)
 		    kbuffer_subbuffer_size(kbuf));
 		return -1;
 	}
-	handle->cpu_data[cpu].timestamp = timestamp_correct(kbuffer_timestamp(kbuf),
-							    cpu, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(kbuffer_timestamp(kbuf),
+							 cpu, handle);
 
 	return 0;
 }
@@ -1942,10 +1952,7 @@ read_again:
 		goto read_again;
 	}
 
-	handle->cpu_data[cpu].timestamp = timestamp_correct(ts, cpu, handle);
-
-	if (handle->ts2secs)
-		handle->cpu_data[cpu].timestamp *= handle->ts2secs;
+	handle->cpu_data[cpu].timestamp = timestamp_calc(ts, cpu, handle);
 
 	index = kbuffer_curr_offset(kbuf);
 
-- 
2.29.2

