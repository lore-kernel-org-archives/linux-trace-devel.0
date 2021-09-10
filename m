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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC225C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96B5A611C9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233710AbhIJNtX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233784AbhIJNtS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:18 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7201FC061756
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:07 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id n10so2573523eda.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=YYYabyGYaNU44M32Jyj/uUZ+XA3KJnnqGfoQ0iSTqbxfYgRn0Tmoywhw53G7DqGlST
         /xcyNHph4WsWB9ZzdxiFn3VhbNTSYQhZ977yaG07S2uEYNHwd7fvGMbW8clV1DZsbZ08
         HDT2+j415zZHKB7A0F+oBLLfeelLY1BY+SsIZMaFRbsd/2t3baGg5HJysIAfs+rU+gWT
         0sikvOGNvYLTWH/3+R+Ba5oLoluLJK8JcUD7d4Zap3x7mgqI91qIVWXMlbLXTCaMRXml
         jfm5BhratBaI8hhjf0DNlk3EY/s+ihtfWRkGc4we4QtbqQXjo+HqbWPhpDhPTLk/j5rP
         6Smw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eNSf3fXIhuexSWrZzu9VRBujGIACDgGvnuES2rhjo4=;
        b=VwCyO6cEkDzGMQ45f3KfHNYy9BTFCvq71rbB7+ul6ew16xA7/Zq7Ia3pJoDk6jH/ef
         xQqIplicw74ioHOY17z9w2YHWkFFqHSnKKxnbUyXh/p+tpZEC2C/El4lc6/0yM6Ygz3b
         6KSthcczVMd91Uv1SnJS1J7yUXqks8tbLFfnjxPx0hi3l5iDxi2MncAMkoLU0Fa+caR4
         TOuCvbRILP0/SGaj3SY3HcQIdv9XOAjxRAObVHJ/xukaYQjkGRZW8gs/k7QTKu99eiQ9
         C7dJqhrgN6MHP2sPA6w7qnFH7aK7g95J3ymvj8u5jLWIwdpP8ExYbtCFUA76c90KDyCM
         ki1w==
X-Gm-Message-State: AOAM533UtjLm6/uCj4wRGjBfp4QPbfjKYVlcEfSW3woN9YRkj8JrAhIT
        Q4yvecVqzzxS4FMwj8/hCFsxdJZiU68=
X-Google-Smtp-Source: ABdhPJyevycU3T7Z+EyWZGjex+OQ2qXpDwXhrRzJGDlaJctRHuAsgpTeCCGLP++yYBiqL96mXgL+IQ==
X-Received: by 2002:aa7:d710:: with SMTP id t16mr8941099edq.42.1631281685997;
        Fri, 10 Sep 2021 06:48:05 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:05 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/21] trace-cmd library: Set long size to the input tep handler when it is read from the file
Date:   Fri, 10 Sep 2021 16:47:42 +0300
Message-Id: <20210910134757.2863982-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Setting the long size to the input tep handler in tracecmd_read_headers()
API may be too late, as this tep handler is used to read and parse data
from the file before that. The most suitable place for that is
tracecmd_alloc_fd() API, right after reading the long size from the
file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e5c8c332..3d7f1c48 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -860,8 +860,6 @@ int tracecmd_read_headers(struct tracecmd_input *handle,
 	if (ret < 0)
 		return -1;
 
-	tep_set_long_size(handle->pevent, handle->long_size);
-
 	if (state <= handle->file_state)
 		return 0;
 
@@ -3337,6 +3335,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 
 	do_read_check(handle, buf, 1);
 	handle->long_size = buf[0];
+	tep_set_long_size(handle->pevent, handle->long_size);
 
 	read4(handle, &page_size);
 	handle->page_size = page_size;
-- 
2.31.1

