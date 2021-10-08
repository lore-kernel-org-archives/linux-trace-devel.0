Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB54FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D697E60E73
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbhJHENb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232118AbhJHENb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DABC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:36 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id g8so31186733edt.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YWwT8QESWnfJO9AaUGKJSeFXn1dqURaIgDryKFiWNto=;
        b=TewJG4l9olDSt69y/CWhU/RjMWLGUVU+F6LK6DtJpWOozrYm1NA6qJ0rVg9ZhptSv1
         sxl4EvMZKsfQTQSszNY+4zHKY6af9AWOL9uDTYCWzGtDD44KhDoEcCDq4A2SUZeniTT5
         3NAnqPlU0TyLYA2i94rnu/wqYR95Q7f1WGB+DIHfyOfpuGP/c49pcNUjgFkxyi2o4Buy
         Q6aDDoC+WEVnXjW+z0DMbWumTmMY9jWBHjlHz+9OX6reLDtjt+kAfLPbVAt6KBskGdcE
         Y/yAO7PQx3RqgAMmBupaImRYGKDHdCs4hjnXq31lcnZ/GAInE/o81TpAHg0D0H4f5Uyi
         Kbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YWwT8QESWnfJO9AaUGKJSeFXn1dqURaIgDryKFiWNto=;
        b=NeH6x5qtjV4I59yjgbie6xQRBZk5fx69BX0xkwrfv2L5GTK4t4lmbMWcjCSKLIT1Q0
         cumV1ELMXUkTqnzIdZgV74LPTOlgV9NG7JDupY/Mg+SVL0lr2VTZK4eiFQwYzrUEFZNb
         DN61pDx1KVBBb+CsfajFxugo5Tb//J+nyuvChfle1Uwe8lfIsx++jzfwVWG3lbq+UBcE
         z4sXRkoweSB8m3piFLzcBnmkQ8jeq7gYoWFMrI2q4PLjVXhgMwVPSrdfeYfGJDs3f48t
         ZGaX40Coovqm0Jpv6+2v5JT9bJff69dc8L2niOepkFOyJ0ebhnTh0b06iwYJY8LoN3Wf
         7i4g==
X-Gm-Message-State: AOAM533khLcAHP63qBkJb4KaF9+2XW6PjK9RsPYdSCLuFa8TtZIxsT48
        CTvkcDmG48J6lrexiSlzh/vVKm57W99AiQ==
X-Google-Smtp-Source: ABdhPJz5eiXaOTQGXa5UEZVNBkDcFsE0bK570wbPKgfHkMYTv/m6BlIfOyN1uOflSkc0Zz8QMgtPkw==
X-Received: by 2002:a50:d88a:: with SMTP id p10mr11587201edj.274.1633666295322;
        Thu, 07 Oct 2021 21:11:35 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:34 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 6/6] trace-cmd library: Set the correct file state when reading file with no ftrace printk data
Date:   Fri,  8 Oct 2021 07:11:24 +0300
Message-Id: <20211008041124.972956-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The ftrace printk section of the trace file can contain no data, this is
valid use case. When such file is read and parsed by read_ftrace_printk,
the file state should be set to TRACECMD_FILE_PRINTK in that case.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index f3677ad3..38c7a3b8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -782,8 +782,10 @@ static int read_ftrace_printk(struct tracecmd_input *handle)
 
 	if (read4(handle, &size) < 0)
 		return -1;
-	if (!size)
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_PRINTK;
 		return 0; /* OK? */
+	}
 
 	buf = malloc(size + 1);
 	if (!buf)
-- 
2.31.1

