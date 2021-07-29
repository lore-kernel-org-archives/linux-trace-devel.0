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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D72AEC4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF22F60C3F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhG2FLR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhG2FLR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:17 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CF9C061765
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:13 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id p21so6366820edi.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZeqSXhB1scM/gYsw5n4fAEvLMCdkuPXcrQGTPYDsIC0=;
        b=p5inOddp/IpPceldirKj99nnEmnSV5GHhUwtiMYwjHW0MFQhoTG+n9COIwqCMmjr4V
         4V2nA4jqbCgzxA1a+imX+iPze//KZHXYN1wza6paEEd4GV58u0/yn/TZ1kCnJHZqsVow
         uj1NZaZ1gE6fxvg27F8IlHvksJtrCNMyClxXasDGX2wxWXC7hCzC+9uP7utBP/ieKdRX
         veQsb2PjfLuOOnqh4wEi5xGDKb8lie5wp29a5EzIiHtVKPW97P8swCmCbwBAzrx3zlFd
         3IJ2ByrJEiGnJqxmIkuazN+7dgZb71wcyEyq6vKODg4EZ8y1tMx3PW2MS4mmTm2/zVEC
         X0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZeqSXhB1scM/gYsw5n4fAEvLMCdkuPXcrQGTPYDsIC0=;
        b=d5v5YINDKhmfDzmb4Mj6J6klUUxphEu7VpcEeslJzAYX2db4Xr6MXA3ptfZQBMNqqZ
         EN+PTowPfs57FdSUpntQaliOCMt5WDBrMEu3IivDnXpWTLJ1sXGG5f0cqvuyV2QFGg9u
         s3e7uBfeHWDunXQgFLM9Bu8+Smfp0cluk+k9Mfi+DTIc3uMQkxsl8pb3edvVmNxY9Fu1
         1XxcppsMMVmhSuIMn6k6Hnwo6Fm85H117zp+viDHttDIVZAmrjRjCF6jyI9BbqXAKlNp
         x3O9uTEfrA6WLiFFEF3Z6fSSF6r2HPtuOK+/ZVDWo3sK+di8AZIqpZEkS8Qcgl1zZQhG
         EoXQ==
X-Gm-Message-State: AOAM531b4uXua5HVKooy5U0oOCTtQVxoLxThRuQJ+cbMxxpAZHyJMH9g
        9oPEL2VTljfRYfm8HbKVoIA=
X-Google-Smtp-Source: ABdhPJwbiI4iUwJyRvikTDExvSZdzLgzuXdFTJ1hMd4VLGctbcS3ewkuc68LZErxCWHC9LuI0SdgaQ==
X-Received: by 2002:a50:f1c7:: with SMTP id y7mr3962441edl.386.1627535471899;
        Wed, 28 Jul 2021 22:11:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:11:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 73/87] trace-cmd library: Reuse local function that writes to output handler
Date:   Thu, 29 Jul 2021 08:09:45 +0300
Message-Id: <20210729050959.12263-74-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reuse do_write_check() internal helper function in the trace-cmd
library. It should be used when writing data to an output handler,
instead of writing to a fd, as it handles compression and network
contexts.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index f8a335d4..c73b37a6 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -59,6 +59,8 @@ out_write_section_header(struct tracecmd_output *handle, unsigned short header_i
 			 char *description, enum tracecmd_section_flags flags, bool option);
 int out_update_section_header(struct tracecmd_output *handle, unsigned long long offset);
 
+long long do_write_check(struct tracecmd_output *handle, const void *data, long long size);
+
 struct cpu_data_source {
 	int fd;
 	int size;
-- 
2.31.1

