Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3147C43462
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8CB361184
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhETDV5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhETDV4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD1DC06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:34 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id u21so22885379ejo.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=W440AGhxE9s4eP2ja0m0sAEk1PUnS2ZqH7cDk9g+PNHcXKPZzJzsfV3ZxxfKPMxR4Z
         UO21Ph22yLLjLy9IdMAKNXzk4FMl+Og//g4fFvHeg7VAZ9gKA6yFi1gG9i7KYGu+Z5eT
         n4ZsBcqCwxD1yaCj1w7ee6102WJ5bTxezgGWyhOA2gAQXVQk2h/Yf///2PXivw8Xeyiu
         y6ojX1s6klwXXnUHEoxSHIrSB6n3Apl+kvY7CbskVHVAqGQvKdoTnXaUfwUw/IAGhkxE
         NtydpHw5rFPpSrpylWuiK6TVtuSJ0IhRsgd7jsPnfOx3U517WyHLoZ+zN/OznayaiHd+
         ZrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BTU1iFO2V4ZzMjExOiVLwCGbuFnGNHp5D2Mj4ZKntEk=;
        b=HIqUfbP49PIU3r5NzA+WVKMuZrkJc2PHn1PoM4dr4rwiezd93y6c4LN7RdD1s/OZPt
         /AOPP9O2TOazIVA9XHmsTNf28/5CTB0QBsxHt9CwG9uGmT316o7IkfHtKYvLjtCOTp/S
         RZL6mT++Uqglu5x1MJeY/t8ozpIRhZ3qauqAHOQlg9usfFCc6B9Q8V7g4ACANrJP4ECK
         MZvAoQWbKYBHXVq+TC4Idsa9KvKsaT+d36WTOj5BT7zBFbMT5lQij6bn2ec9Z96KEjkX
         omXULtZlYqZDATsoV4j+8vh0v5U8aN64j8JgOM2aM0P+ioo20RniySzFe69mChM8oVzG
         w52w==
X-Gm-Message-State: AOAM531tyFeBDHoA7RCm0z61wAUn3ll0Ne2lM1iw30BXKx+LdMdBF5rN
        2Yx9CwTWyBo8SzbU34FDP2k=
X-Google-Smtp-Source: ABdhPJwXHqYJQhkCBuLPS7viA9X6IhbPZjBGnQn8x5b+1eYekUWubFO2NtvUihHdHfHwv6CJr8vM9Q==
X-Received: by 2002:a17:906:5052:: with SMTP id e18mr2512218ejk.112.1621480833318;
        Wed, 19 May 2021 20:20:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 29/29] trace-cmd: Do not use trace file compression with streams
Date:   Thu, 20 May 2021 06:19:59 +0300
Message-Id: <20210520031959.346165-30-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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

