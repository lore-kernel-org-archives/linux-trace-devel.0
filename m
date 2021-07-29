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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD07C43216
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3814160FED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbhG2FKi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbhG2FKh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DF1C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id u12so6434766eds.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OcmTwSdFAUVMUYjmZI+PSyTyeZ94oARlcL1CjThkgGo=;
        b=IpFzmhnSxXsYPP7pII8G4gSbRSV6Ndv/TLZYZ4vxLQxiS39pfDMOdaLmVV4uzWM16I
         8tmx06FX1XC7IZrw8GpvN5pA3jm/AkwC6kVW/3aG4Pe+X8rxIyTWOZZ25sSaG00rksdG
         QgZsA78gBKjiB/bCK98+SxPrQELq3+l9BBcEnKzpRjC+1nalgce3P8MLP5vajVd4HWUG
         zp8rOpozLN2CmUY710GRAO6NW5VO+FG4Ii9qj5cwW0Sf/bdCIHe2l43hoyYUFfTpsXMU
         JAVmilQ3gH0iJXUlT3lpyekxgFSCK6UucKVJoSQ7vLyeg+cAEMETRwHBEZiiO8fwMg8j
         zu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OcmTwSdFAUVMUYjmZI+PSyTyeZ94oARlcL1CjThkgGo=;
        b=TbgvZqtWtffLjyj4kWVKMPyshPjQInmlFA7GmbksSjpJ9BOkOnZ4mtMSgxEJwNBN2o
         hKYjd7Is0JZRVdO0orXLZKYh4cSI9SVmNURuMQ/xCRmtUQRudO1suJ1et+YUt6+secwD
         qTUquAsXfWM2Sh6LGJBnqhL7Lq24kI8R7h07WcCgsReRLIEhxaZy51WptXOp3p+3eXOe
         f5VNrcAXO3ruwtw/M0+IID1iqZvlHKqW//umc5TC5WH/363ZFnlJkQd6fnf2IRhrLxwq
         BoxsuOI6UslapqlIzuWIAhJ86ibf3Q7+88lYu580XyR8AyXtHWhgTOYgqBw63iSrydXb
         beVg==
X-Gm-Message-State: AOAM532LsS7S8Fmy4SVF7E6IsUe6w1G9CRR96xSJrYDfpcOPpr9/qf+F
        xkW/S35sKebaPT8vAyXhbRo=
X-Google-Smtp-Source: ABdhPJyWm38B8uZQrNjX3PN+/i6/fQN5rTcyj1Couw2bwKrQApWwplzMdmq4WxtL4/fLBOjDrETG1A==
X-Received: by 2002:a50:f615:: with SMTP id c21mr4058155edn.146.1627535432927;
        Wed, 28 Jul 2021 22:10:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 32/87] trace-cmd library: Do not write CPUs with empty trace data
Date:   Thu, 29 Jul 2021 08:09:04 +0300
Message-Id: <20210729050959.12263-33-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 has more flexible design, which allows to write only
CPUs with trace data in the file. If a CPU has no recorded trace data,
do not put it in the trace file version 7.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 83c3b9e7..87bbcf39 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2335,8 +2335,10 @@ int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 
 	if (i < cpus)
 		ret = -1;
-	else
+	else if (size || handle->file_version < 7) /* do not write empty trace buffer in v7 files*/
 		ret = out_write_cpu_data(handle, cpus, data, buff_name);
+	else
+		ret = 0;
 
 	for (i = 0; i < cpus; i++) {
 		if (data[i].fd >= 0)
-- 
2.31.1

