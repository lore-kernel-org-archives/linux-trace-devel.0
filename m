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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA34C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34F4C60FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhG2FKe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhG2FKc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:32 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EFBC061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ec13so5881187edb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EIoDKwsrSyrvOhUkkTIHs070KY99lBO+xAo3kDzM5CM=;
        b=P+mD9sXrIJZqllB7Q0BgWPIYSPsF0N4dcuvrCMzTJvRAmBoE4sA2uV3DtrKj2o7HlL
         oK2N/+ijlfP/De8k2WOfzOPaEq2QYCf9kl1+QPDVINtLwRvbuBDiC0HlRcNnVXYloIM3
         UAeVg/8aX7um37R9GSBh9MpsHvAWWQZHHEqWiVsii+Hmjp9j6y8SxU43JXCMihWZHItl
         bXbv0fDLXdmtMuPOR3fkvxz++HS79v43dyo8QmHOti+RuJCpktrsJVnEo5xOLJhMQiPf
         fTvIQhV7tZITCronuOGTbbn/56IalDOQpBMZcLT9vG25k6Vqht+/qa2NcmAAh98PfdQx
         xyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EIoDKwsrSyrvOhUkkTIHs070KY99lBO+xAo3kDzM5CM=;
        b=kd/5FwC+zppGHsSftOp4yXwoHExeucXWrLhd0eZV+7/lNT/7+AVydJvZLLYhv8brhJ
         wmlbhRf7Uqw39aBcGRH5lVjg6CaO9ftwjFeeggPClYpb9vu1FHczMEQn8NcxRXE2ZHct
         eG0kw4BDmdEtt54zON6pzmLOsUaSaF4qH1NqXU32kp/dN1WAk6ODxN0aXZMGABKe2ZwM
         j5sDqxgoVl8J0sdc1bTCx1CoUIpgwx05THAUSMX/4gmit+Mg4FcXFdxV5GrLziAr7gZw
         lTLjh4G0t4iTYdg0MYD9aPZbeaVFkaEUpswZoYzqSgI+2QW7Qmmb0yDvpZ7LyLzxa6Ci
         A52g==
X-Gm-Message-State: AOAM5318YdbCjS9WJ2cObv/mgvo/velP4ZJBKOEdGRB2t5mwxX9Oq0rM
        x7qVSuD4jByOUrABrceYQ/k=
X-Google-Smtp-Source: ABdhPJwZ5OGy7i1DTmKlneSbpbrjf6f99sV8XAPJg05A1C7Xas4aukL+xJpIj20Z3N8yte5uYlqQ4Q==
X-Received: by 2002:a05:6402:10d9:: with SMTP id p25mr3894635edu.51.1627535428072;
        Wed, 28 Jul 2021 22:10:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 27/87] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Thu, 29 Jul 2021 08:08:59 +0300
Message-Id: <20210729050959.12263-28-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Writing CPU count as a separate section in the trace file is redundant,
as there is already an option for that. Use that option in trace files
version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 6bb7f4de..d60bd456 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1637,10 +1637,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 				 handle->file_state);
 		return -1;
 	}
-	cpus = convert_endian_4(handle, cpus);
-	ret = do_write_check(handle, &cpus, 4);
-	if (ret < 0)
-		return ret;
+
+	if (handle->file_version < 7) {
+		cpus = convert_endian_4(handle, cpus);
+		ret = do_write_check(handle, &cpus, 4);
+		if (ret < 0)
+			return ret;
+	} else {
+		tracecmd_add_option(handle, TRACECMD_OPTION_CPUCOUNT, sizeof(int), &cpus);
+	}
+
 	handle->file_state = TRACECMD_FILE_CPU_COUNT;
 	return 0;
 }
-- 
2.31.1

