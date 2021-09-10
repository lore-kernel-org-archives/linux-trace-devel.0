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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D887C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CC15611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhIJNwW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhIJNwW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:22 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CD1C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:11 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id n10so2585918eda.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fl3C/EZbP7PBX5QkXZYsCjxdv2DKShH1DuPrzRiaI/Y=;
        b=PT0ClffWDCgOogDdN2IiL3dmtQybYaZAbLYhx01eHalt+T1NbkUZBaDln09BMbvuJI
         9xzkmubV/vhxbLdT/6bB7MgNcajquCBDYnv+fZI61jSTlaTGIBJdL+fgT1cMOzD0kLXN
         Fbh7y6Pvass8i2jPCmA4qYDHP/29aoF3mW/HVl2lfD5bHej6AUgRzIbm6k3E/c/HUz0k
         u9Qyw+/HZxjwCQ0+AXD5/abrGZyTn6lL5+YH2aJCFNvFnQQrC7rbDg+z8O3tefS/RXJg
         PcOX0YQhtEv8G0n6E0+mdXu+Z+xByKfsPi5SBnU4JQAojM+unLgWWCjnuSkTkuTVfP02
         mlwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fl3C/EZbP7PBX5QkXZYsCjxdv2DKShH1DuPrzRiaI/Y=;
        b=jpZa/rzIUG2n/3Ugui5WmICn4ThvOFybrOIQiG8bRwQOY3M9wh82T5OK/1vhbqKbGA
         cQT/g/2WaRg9fF1JvgEwWUYFanQuBLLV6BN6CdzuC4RE3IUZZqa5ubCNGxtLJMjPx6WG
         Tu7PmfxQ26w+V5OUpiQxJw1etwZEkIeuOa4l+IIS3BbrRUwKQgYZwzLtpeqa1SXEff4i
         f1IGNz4xh9nup6eIXas3r7Wv7saTy18caVIi+cKX3rWNqnNHRSl61mcFxt7bYbnMVflf
         DUKsP1FcMZ7A9xZYnNPtrMiuua2tBvG3d2o87yVuDGDnsJF9KOW2LMO6sIYukDdMJKrc
         RGwQ==
X-Gm-Message-State: AOAM530o8zwXSSccXIZREV0P5pekVELP5ZF3yJvRgQJNCTF3uCpNt4A+
        L+YUVGpQI8mg+14FbghaeM3/XJI44RE=
X-Google-Smtp-Source: ABdhPJy4EAiHBVB9nid1RaZ1x+ZApIKSUoSH/fGsOQNBVatOXSIt0sjqys6ls/oKCyjVljM9nQ3zvA==
X-Received: by 2002:a05:6402:299:: with SMTP id l25mr9028942edv.343.1631281869643;
        Fri, 10 Sep 2021 06:51:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 07/25] trace-cmd library: Do not write CPU count section in trace files version 7
Date:   Fri, 10 Sep 2021 16:50:43 +0300
Message-Id: <20210910135101.2865226-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
index 13411804..58f6effd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1398,10 +1398,16 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
 				 handle->file_state);
 		return -1;
 	}
-	cpus = convert_endian_4(handle, cpus);
-	ret = do_write_check(handle, &cpus, 4);
-	if (ret < 0)
-		return ret;
+
+	if (!HAS_SECTIONS(handle)) {
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

