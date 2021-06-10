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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF8BC48BE0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6760613F1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFJLgy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhFJLgx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:36:53 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987A2C061760
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:57 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso4597357wmc.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=OhJtmfhJMnsEkpERKdKNkvWJ313vInsTtwALigUcxpZ0Q0YIdM0MmB1xeNTgX/Gyl8
         NCmMViRuh8vKd2Y6pa5VHNlFNqJ8roFNxmcL9I/prBKgvWi10UPRbPT8zj6Mb591SOTD
         lC93iwEG1ChZySnUxzYwnvv7LKeQyGdJGmJHzBGmKFZAMiYBdzqyrpoCVXbhwyY29V3G
         M2t7dc0es4iyEAMroSvjfi2xlMtesa/mHYQ86qCGhzeU0fc4GH19kmpu/e4t5fhEQEH2
         smy5i2TAglv9uLSZ0yKA39KNaGeMj6Ibbl0F16RJPkTMeRMZLAC2Y68K0vWwseNJAJ10
         2CNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=OPb3/a1G1EgO3fsLSNgexxkRBUOEeE+KymGqHvuc15HJZKKvzk+7Wxd3MsyfW0nGbH
         yT8bpHKE+rBQ6rWnTF1teoZn/Fx+z05894a4UtlJ9rkC4zaR3izg9ZpEKHDaSRsgVwHC
         JLTk1uA00fWmktuRaBZjCwBlyd8fFDj91OSskH2b5CNkp6nA3DDq1YdVXqm/Sv/xmmkb
         FUTccTwfPN2K76PywCF+88s3T+UGJfBGhsow/gQpfy4v7ONwCorqaU/okiXxNMoniBtp
         MQeTIOO8JV9YWCW4TBZSif4NuQkf7eurj0f2dgtXrMdriyeOndU3/tce17uocBd1N+Tn
         WAsw==
X-Gm-Message-State: AOAM531pAB2+OS0EkiQPHBPH8rELmDYZ0o6WQzdoboDMrRNNxAcSWrOK
        58szybnDakZHaJmS9oJzk9iHmBwX6IIC3Q==
X-Google-Smtp-Source: ABdhPJwC+jZhf1moQg5TejxFqJUcstK8Dmy9Q8OdPtz/eMMewxOUxNEkGiHNTCUysE3FMu2fsHfwMg==
X-Received: by 2002:a05:600c:3789:: with SMTP id o9mr14869763wmr.78.1623324896244;
        Thu, 10 Jun 2021 04:34:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 30/40] trace-cmd: Do not use trace file compression with streams
Date:   Thu, 10 Jun 2021 14:34:16 +0300
Message-Id: <20210610113426.257931-31-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When creating a temporary output handler for use with a stream, force it
not not use trace file compression. As no data are saved in this file,
there is no need to have a compression overhead.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index 317de1b2..1ca3a79d 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -43,7 +43,7 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		tfd = fileno(fp);
 
 		ofd = dup(tfd);
-		trace_output = tracecmd_create_init_fd(ofd, NULL);
+		trace_output = tracecmd_create_init_fd(ofd, "none");
 		if (!trace_output) {
 			fclose(fp);
 			return NULL;
-- 
2.31.1

