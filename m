Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FB97C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8619C60F44
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhJHENb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhJHEN3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:29 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D89C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p13so31714509edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DmmLAI7veNsI3n+A2BZLJ5hpsAwaRxqrx1oXAKYVg88=;
        b=Q04sASSOP8/1BdlwcvVs+jICNnowddsSfWD0dst49RhbN3u8+Ku7I/UVrpNcOlJRiK
         AzDaiO1VTAFQ2hgxbiVc/J+M8Q25KpH0FDzwDEUub4sEa2TqCrocNm8lYSngILjep4mc
         KFPiT/5FH53G1CtoeXOZT5nGzDQh+z/bywApCpnc1TfE0Sqg84exYxZhBU04oTM+Zi2D
         ph116vJ/cg6Sgn56IT9jZubTnSHHNPWFvuOUVinhHWYm1GqMJK/DWEnCT+8pOwCdR0F/
         /s1Hu8ypMvBmoYED/JcvOdfUjHMrspIKJJn7vMuZygVJBjvL1TLj9FpFTghIykMIrFYb
         JUFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DmmLAI7veNsI3n+A2BZLJ5hpsAwaRxqrx1oXAKYVg88=;
        b=gPzsw0A1dTnRcavJEJFTcuq90dYdLF+AoYRDDZnLY63AxpfDIMysdUIQ9tnLnJk4ut
         enBcktBp0yAIwIDkdum2qgutP425TScOD23g0G457VzXXR/wTcS6uXns4UeHwLa9GmMg
         N4Lqs5iYNJpVMdPmQAJUeCIdw7RR1YzTu4wK+1Vy0w3/GMinNy1JARWb14ebY5PEWFBq
         RjQhb9lSOXRnYAyCNI0sFyRq6X31TKltaE1D1+xghjZKIyAs839Hmi+7YvMrRpp/+6vL
         binSKz/DiLIWvZp+aJRW0bHq+8KQwwgbY92S19ukEQjQVYl7uq8igCtBi/DLiMdTVW52
         gTJQ==
X-Gm-Message-State: AOAM531oE1LcQLg4Dpiyo+wR72hVH3pSXargnPJ3qOM1bQ4hwXRLGOoU
        Mil7pcAd1PToVH9BXNz4RLoiJDvfbgT4Xg==
X-Google-Smtp-Source: ABdhPJwUCVcdy/fNfu24V32gjjY0nhJIDyKKotbPyHgisA5OIseoY0r8PpQSyL7ljt6gxNY6oXSWyg==
X-Received: by 2002:a17:906:3745:: with SMTP id e5mr1255753ejc.400.1633666293792;
        Thu, 07 Oct 2021 21:11:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 5/6] trace-cmd library: Set the correct file state when reading file with no kallsyms
Date:   Fri,  8 Oct 2021 07:11:23 +0300
Message-Id: <20211008041124.972956-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The kallsyms section of the trace file can contain no data, this is
valid use case. When such file is read and parsed by read_proc_kallsyms(),
the file state should be set to TRACECMD_FILE_KALLSYMS in that case.

Renamed a local variable from pevent to tep, to be consistent with the
libtraceevent prefix.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 43491c5b..f3677ad3 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -740,7 +740,7 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
 {
-	struct tep_handle *pevent = handle->pevent;
+	struct tep_handle *tep = handle->pevent;
 	unsigned int size;
 	char *buf;
 
@@ -749,8 +749,10 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 
 	if (read4(handle, &size) < 0)
 		return -1;
-	if (!size)
+	if (!size) {
+		handle->file_state = TRACECMD_FILE_KALLSYMS;
 		return 0; /* OK? */
+	}
 
 	buf = malloc(size+1);
 	if (!buf)
@@ -761,7 +763,7 @@ static int read_proc_kallsyms(struct tracecmd_input *handle)
 	}
 	buf[size] = 0;
 
-	tep_parse_kallsyms(pevent, buf);
+	tep_parse_kallsyms(tep, buf);
 
 	free(buf);
 
-- 
2.31.1

