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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB48C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB9061052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhG2FKg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhG2FKf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:35 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A89AC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id nd39so8463758ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+xzGS4lMzgEZCd2cBF9hSNcgr/kC71xtcPquJSbbf3w=;
        b=l7TK+B7B1fBBW4LBp4vkN8AuT8FzNM/87h25uGbBTWScwWc0F3cuzZr+uYrQ2GMElo
         fhwIhNmvhCOXKiaoKpFtm8BfhScafQl9QP4sAUACL9glpJrorE/s/yn61fXQDGYM5f4v
         Du72Icy3wVh/3OGPgtYEDEHcI9zC/Kn7UHUsGXA0spkJ5jmzhl5aaYuixK9UcoDBx3k5
         kAatrvoE0fPZ9YspPj9xlya3l77PBZkU4BFo7C3c93Fhmy1xHSUeczjCqZI4fxX/d4xw
         +ecBqGz2yKa8e1xWbGYdO4M+82HZQVPC9bSST5sE3X8KP/Q8fwk9/kOV2vib/77YmWBA
         6mQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+xzGS4lMzgEZCd2cBF9hSNcgr/kC71xtcPquJSbbf3w=;
        b=McioUiVK8VAN0FO77GXo5cbabL0yxuENO6XmM0xjP/KhNcTryMjcTVWAJBAH3pEPyb
         Rg/q8P4pn1oX9+0gXH4Mk1uSnim3yG+bcFI2VRfqEnbGe7O9lp3NOTIckRz3sBFQrszU
         +WFCFBdxdHr+lF75NGmkTIB8S3t/0MuJ1tmRa+sBajdOVumTr4oF2tLjI5BzH8FpLi6E
         ZLCnGwYXk6WtCpPnGmpj1S8DHl/EqRrAVtl2HBCUQumEJzlDvi+yOYKgd9/D4u4eluu0
         U361UGIFW+Fo1CkfKsh/AVAW87kIiEWqBtA49ao+0+PEeedD7qjUABZzv7Ec0BYF2ffn
         sHyQ==
X-Gm-Message-State: AOAM533bERTyEU1HZtX6zXL4DLIdeSB0Eb9fVIHzvWF9z5Mn8dnNwVXU
        q9OEKaFRs5pwR/aJtjSfsVU=
X-Google-Smtp-Source: ABdhPJzH2kbC4LPXxVzmxS1FBMFrqzcTR/2fl72nG2NHpTyRtunjlcJsxoUqtzyx4wfmPv4wYPafuw==
X-Received: by 2002:a17:906:b0c5:: with SMTP id bk5mr2804223ejb.428.1627535429947;
        Wed, 28 Jul 2021 22:10:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 29/87] trace-cmd record: Append trace options after the trace data are written
Date:   Thu, 29 Jul 2021 08:09:01 +0300
Message-Id: <20210729050959.12263-30-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the CPU trace metadata is saved in a trace
option. As this metadata has file offsets, which depend on the CPU trace
data, the option must be written in the file after the CPU trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 350d2811..f8c1c090 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4466,6 +4466,9 @@ static void write_guest_file(struct buffer_instance *instance)
 
 	if (tracecmd_write_cpu_data(handle, cpu_count, temp_files, "") < 0)
 		die("failed to write CPU data");
+	if (tracecmd_get_out_file_version(handle) >= 7)
+		tracecmd_write_options(handle);
+
 	tracecmd_output_close(handle);
 
 	for (i = 0; i < cpu_count; i++)
@@ -4623,7 +4626,8 @@ static void record_data(struct common_record_context *ctx)
 				append_buffer(handle, instance, temp_files);
 			}
 		}
-
+		if (tracecmd_get_out_file_version(handle) >= 7)
+			tracecmd_write_options(handle);
 		free(temp_files);
 	}
 	if (!handle)
-- 
2.31.1

