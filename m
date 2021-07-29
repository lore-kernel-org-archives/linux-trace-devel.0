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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 304A1C43214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C08B60C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234054AbhG2FLC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhG2FLC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:02 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED59C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:58 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id f13so6342718edq.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fH+eB0oQaWGz+OBjpumBHL5m9Ri483L+c2sXZChUFKk=;
        b=p2YWvPHUgNt1MKON2li1EnGUoTh/a5u4Y59j8l5gxdYuu9F7Of7Olbv1JmvAZl6Aks
         x25ZN75V6TsV7RPKNz1raQ+dWD7i0LiAi75672F0+m7dkUwjmFUrTwinFZQyNVUVHl1Q
         EwR+I+OBCE9IGOBxuVUFCZd4BZANUuxzWlnMEN2o7YXzCM9C9b74STz+tmx8q90Y2CRy
         GAP17XR+WIU0r2YMBCfZNImP6vJPDdkZXzVrQtMOUryW2l5LBCRFbR7nX9uHQOu1dE/V
         LfXCbwDGcacO3pxLVnYy9zK5OZpArPdCEF3ERRMyNq70TORg9/pRG5S+n4h2MmEjdzAB
         SI6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fH+eB0oQaWGz+OBjpumBHL5m9Ri483L+c2sXZChUFKk=;
        b=gdbGHkvfEBIt4jt1Xpbd7V+DUyy+PPVXRP3RFTSp0W8OpdHlYIY65P7FdLvlbyU8sz
         SxSHIxggXTQeRthJTtSXcioPXd2Lx5qgbi3XVOC+8WJIrhatJNBygAJSnoAe7Iszjqbw
         UN+vttsp6ILnG6uc337IMPcRkS6rcro99XYN9uOyeXX6o9CQaVmitmgJSgZ02HReaQTc
         SxahJDHrHxtZx4I/Fm2jF0r0fU6uJpOuLoAgXgVmtSHMGPanpsup7tOhQ30tYmyBQ/BC
         U5gs8HitkoY6hYjLLbTQUGRyV+Rpi5+xMOcgtpNghcWAfQUz2T0d2ltc2oH13B849Fgb
         5Vww==
X-Gm-Message-State: AOAM5318xfQz4n2rRb47j8XMMis8AKSgTI1LLhrSEG7dLqljdZuQ3xkT
        kX9uSMzhWu6jIRN0m+QEB9k=
X-Google-Smtp-Source: ABdhPJyVp8BGieMba2+TQjCYOEb3XsDToevfZlFjxBb2GTlZWd/saThM0ptUf4KMJz/8kYqjegbbLg==
X-Received: by 2002:a05:6402:781:: with SMTP id d1mr3995251edy.32.1627535457509;
        Wed, 28 Jul 2021 22:10:57 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 58/87] trace-cmd report: Close input file handlers on exit
Date:   Thu, 29 Jul 2021 08:09:30 +0300
Message-Id: <20210729050959.12263-59-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report" is interrupted with "ctrl-c", close the input
hanlders to opened trace files, to delete any temporary files used when
reading the trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 0ec2b2d1..a36d72e4 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1365,7 +1365,14 @@ struct tracecmd_input *read_trace_header(const char *file, int flags)
 
 static void sig_end(int sig)
 {
+	struct handle_list *handles;
+
 	fprintf(stderr, "trace-cmd: Received SIGINT\n");
+
+	list_for_each_entry(handles, &handle_list, list) {
+		tracecmd_close(handles->handle);
+	}
+
 	exit(0);
 }
 
-- 
2.31.1

