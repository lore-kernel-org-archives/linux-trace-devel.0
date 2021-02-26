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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207D0C433E6
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C7F64EF0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Feb 2021 04:06:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhBZEG7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Feb 2021 23:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBZEG5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Feb 2021 23:06:57 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C6C061756
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:16 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id f12so3478203wrx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Feb 2021 20:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lgG76T8rOQhO2DXa9ZzN7jC+XGOWZIsk4hDRKz3Jkrg=;
        b=UT7NP/NEI7m0/TcMGSAgy2QpwB6xngJGxLzeYryl5h7gq+UUR7zI70ZiABCkdvlHRb
         /EDZhWhbWn/UHAVcl6btzG9/Wt54LH8kk78IDpdA9PgJlVSMb3tyCkjlVBda9cUeK1J3
         L6Vt7nUV+icBTBgIuif77JAO/pNeThctQ4NyMABO1cMgx+3I1dVuasFryYEJvvbILbCK
         NVCE2tqIanl3gEQDyCIshWhnsjSFbqDlSAnEoAV54GvYnQP8/LcsxS9E2yDizg6umlKN
         xmmUuaRa6o3JtKL8e55fLzPnHHDq78ToZIyb0bCPWxgyT02d2kabJ1flSzbpWVrAjc5g
         N2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lgG76T8rOQhO2DXa9ZzN7jC+XGOWZIsk4hDRKz3Jkrg=;
        b=KnK8Y8X+bAAs1LkSn1NymGMEDrQpDC7URJuiBhMccdWCI83P8HoYIr8sVbenrExs1Z
         fJ9A4k6eFKfxmTUmupuVO6bxJ19Td2cCe+5WDyno1B03q57LkNjbKnSORBwjKk4jgwkR
         ZLPRmMqJNVrsmxdvtDj2QMeMEbp6HW0PmQ5Gt4s5hbiTnR4Bl0pLbaYQN+5Go4uKOCx2
         GRGDPL//bwGNvGpv5LNNkiNg6YmKMBFWsYwbQy2yEsjWqSaFJT7pI7MC2OlAIUw6MUdk
         UMl2abL4ibWsVB5nPPpk8M9OZT6rxG3xxo/NVX3A22e05bFB9gqr65qiJZBlQcvht8nW
         Af6g==
X-Gm-Message-State: AOAM5302fkPcfhXMqUKlwGCYS9QxZz/wexJRaUl3mPA5WksakC8UmEul
        r9D0CYxy/81noraseKCHYyE=
X-Google-Smtp-Source: ABdhPJwK3iTfpLM6KgJu9MkVG5uJNV283sEvPfan3NQpWbV5/raNak9KQuQ1w+2T2fy1Q8PBjAa4YA==
X-Received: by 2002:a5d:6686:: with SMTP id l6mr978151wru.417.1614312375682;
        Thu, 25 Feb 2021 20:06:15 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n1sm12357070wrx.45.2021.02.25.20.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 20:06:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 2/3] trace-cmd: Do not use trace plugins when reading partial trace files
Date:   Fri, 26 Feb 2021 06:06:10 +0200
Message-Id: <20210226040611.186037-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210226040611.186037-1-tz.stoyanov@gmail.com>
References: <20210226040611.186037-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_get_output_handle_fd() is used to open an output handler
to partially written trace files, in most cases with no tracing data
yet. Loading trace plugins when opening such files is useless, as
we are interested only on the file headers, not on the trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c6ae8c64..c8f8a106 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1509,7 +1509,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 		return NULL;
 
 	/* get a input handle from this */
-	ihandle = tracecmd_alloc_fd(fd2, 0);
+	ihandle = tracecmd_alloc_fd(fd2, TRACECMD_FL_LOAD_NO_PLUGINS);
 	if (!ihandle)
 		return NULL;
 	tracecmd_read_headers(ihandle);
-- 
2.29.2

