Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E4EAC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12C9061073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJHENZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhJHENY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:24 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D0C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:30 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a25so15403379edx.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aC1j+j4opBpSUMYr+31roXG7XhNjCn/YOu9g9949ADk=;
        b=D/mduiMF+YoEmnhfjYnAZ9/S4OoQSyvMrE2EHd0piEjslEjnjYr0u2fV1UicsQasn/
         kcIkN2PGRNuyIuvMXgyH672GxQvaCYnSW/twHaSKfYYtwfPRiUapieWK7MuNMaUCOruy
         eIF4vG6wr51SaI0IUjFk8B4nTw4ScQPhDuKqiqympqxgROaJNH8lwCjcTLi3xuv3el7D
         qSF3odDYX8sv64e8EmhZDcmMfeEoKrZsHi4D2lyZso8RRySWyYQv5N893Cdb24vNIt69
         AakRTrNMYT7V49tPIyX1RluTnIDWUFrD8SJB/JooXhzEg1B15e5CAlQUZAO0+BaM1NkL
         EkRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aC1j+j4opBpSUMYr+31roXG7XhNjCn/YOu9g9949ADk=;
        b=ibNPNcKrelAKEvPpOuvsfeRS6lYRr+uhIaQwJEgfpdrUxwwCLhNh+JlJRlzcFiKd3H
         nlGh6OKIcz9M2cfKPzr6XFwwn0vZJaoS603huTRsnuZMe9NvQIHi36CMYWjALfpkIBuR
         qJiEWX8tnGvyuv73Gvj0AxT2xKZOCb21mHtDfAmTIsdcnIwee3CyqoCC6pjXwZZIz5vw
         eB8u+rhbDvDl1W5G61gab3PWB5aEhQVSUgv7PoTuvmVWpWu/ojsJmp1OWQ0lvBXn6kEm
         lx2DctTtTI9cj1UBuXid6mFYRkjfvz6hox8onPJmsIsDgWHa4G8bcUVTvsv8eNw3gU38
         FFSg==
X-Gm-Message-State: AOAM531SdvH/a/e9JcnsLuUlYXcowDW/VfwrpFHpmeIibTNmLi5yMXrb
        k7Acngb6adEMhsUqtnRXrYd/XrlJ+LR3kA==
X-Google-Smtp-Source: ABdhPJz5sGZLokGnUtaAudkFs8DhyDOTXAdjRctxnhIBkn3nH4oaws0bDD1pYDi+lJafcGmx96meiQ==
X-Received: by 2002:a17:906:9241:: with SMTP id c1mr1296687ejx.125.1633666288715;
        Thu, 07 Oct 2021 21:11:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/6] trace-cmd library: Do not use local variables when reading CPU stat option
Date:   Fri,  8 Oct 2021 07:11:19 +0300
Message-Id: <20211008041124.972956-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using a local variable to read all CPUSTAT options assumes that all of
them are in a single option section. While this is true for the current
trace file version format, this assumption limits the design of a more
flexible format with multiple options sections. Use input handler context
instead of the local variable.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ec4c6e55..b4af783b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -132,6 +132,7 @@ struct tracecmd_input {
 	bool			read_page;
 	bool			use_pipe;
 	int			file_version;
+	unsigned int		cpustats_size;
 	struct cpu_data 	*cpu_data;
 	long long		ts_offset;
 	struct tsc2nsec		tsc_calc;
@@ -2658,7 +2659,6 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short option;
 	unsigned int size;
 	char *cpustats = NULL;
-	unsigned int cpustats_size = 0;
 	struct input_buffer_instance *buffer;
 	struct hook_list *hook;
 	char *buf;
@@ -2736,12 +2736,14 @@ static int handle_options(struct tracecmd_input *handle)
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
-			cpustats = realloc(cpustats, cpustats_size + size + 1);
+			cpustats = realloc(handle->cpustats,
+					   handle->cpustats_size + size + 1);
 			if (!cpustats)
 				return -ENOMEM;
-			memcpy(cpustats + cpustats_size, buf, size);
-			cpustats_size += size;
-			cpustats[cpustats_size] = 0;
+			memcpy(cpustats + handle->cpustats_size, buf, size);
+			handle->cpustats_size += size;
+			cpustats[handle->cpustats_size] = 0;
+			handle->cpustats = cpustats;
 			break;
 		case TRACECMD_OPTION_BUFFER:
 			/* A buffer instance is saved at the end of the file */
@@ -2811,8 +2813,6 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	handle->cpustats = cpustats;
-
 	return 0;
 }
 
-- 
2.31.1

