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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2946C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDF8611EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbhIJNtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbhIJNtV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:49:21 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725C0C061757
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:10 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c22so1200888edn.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KZqHj4I/ZwlfJwtnuzg0Oif+xGCCWXvcMAI8x2GWU7M=;
        b=Ao/3yF/3OVTVrRpqZI3p9vTchGyMoc8rQ6/4yZX5gtofxKll9ZCuX+hPadwb19vyGu
         YyuUANuNYMabQvZY3AP3GQf92G/3yvZRXCOrSg30WghWVaQgNGmLj5eMBjCk0g4IowaQ
         WKVy2xVfddXxBWwqCMER3dB31vats1vMkMHe1mCFRIqh3bCohhNk2mN/FsPnBiEvYIYN
         WJG4OMkNmu9erHLrh9GqHUcOSOA/WCBNgz0orWhi9xllQGyKREjbtj81weIKvmdYxfqa
         uOxIoAwLdPO7hgy7lWMQXc/OlU0GzTBpCoFnvc2S/kPgZWeZ8T4u8qCyC84OelqXIQOm
         2MaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KZqHj4I/ZwlfJwtnuzg0Oif+xGCCWXvcMAI8x2GWU7M=;
        b=HTxzzj6eUH5o8SP1Cfqo7oWL79WJ/x0gVOiNlGzgpX2Uvw3rgyYdv/kBKz24pBrd4r
         3pXQRfeSw0kceprYCn0j9QmTJyxs0zYNaXiDpiWg4m6x89zzhP5G4PH3/FgfViMf+rFi
         l8c4xCiaeOJHn2GCBEab1+KlwJwdiXp8pYyYiMEou2H7EgIZLd4zBzLxRXvWwE0vRFwu
         YdR4E8JNu1YJdE+64fppuC8CnwvZJ9KyrxKOAjJk4wpywHHNqZjlbVB5YP4smF/vM3oB
         QozLQfc/OQsTNDzZOWDCa0aIUu/a2Mp6o/pPoxjdkTGTM9mZCBQ1nS2vC9uYH7Tgsw+E
         iuDQ==
X-Gm-Message-State: AOAM533z31Quku3BZcA0Zy06dWETuth/ooa9XfVzZCoRiucC8iX41/w+
        2o3xO2tjEbrClEnBcDWLbY9b8avuf6M=
X-Google-Smtp-Source: ABdhPJy9RpuWb8m/ucXNL1NsWReJHnnKDbNj/aP5Vr/GzQBRGqzwQlN407z8eTaRQMAFS+idRq5oZg==
X-Received: by 2002:aa7:df8b:: with SMTP id b11mr9017330edy.61.1631281689123;
        Fri, 10 Sep 2021 06:48:09 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r2sm605141edo.59.2021.09.10.06.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:48:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/21] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Fri, 10 Sep 2021 16:47:45 +0300
Message-Id: <20210910134757.2863982-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
References: <20210910134757.2863982-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 2f749d0b..f933acc6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -616,28 +616,30 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 		}
 	}
 
-	if (read4(handle, &count) < 0)
-		return -1;
+	ret = read4(handle, &count);
+	if (ret < 0)
+		goto out;
 
 	for (i = 0; i < count; i++) {
-		if (read8(handle, &size) < 0)
-			return -1;
+		ret = read8(handle, &size);
+		if (ret < 0)
+			goto out;
 		ret = read_ftrace_file(handle, size, print_all, ereg);
 		if (ret < 0)
-			return -1;
+			goto out;
 	}
 
 	handle->event_files_start =
 		lseek64(handle->fd, 0, SEEK_CUR);
-
+	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
+	ret = 0;
+out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
-	handle->file_state = TRACECMD_FILE_FTRACE_EVENTS;
-
-	return 0;
+	return ret;
 }
 
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
-- 
2.31.1

