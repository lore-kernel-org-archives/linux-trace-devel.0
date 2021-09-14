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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F3FC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0019B610D1
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhINNOE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbhINNOD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:14:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7275CC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:46 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id t18so20187547wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OTYZuCAo5R2kjph4kWPglVUSjijOi7+4l6GtPJgV2w=;
        b=F/oDdRmIjSQ0IkMQvvfeUFBG+xnUOmM7OzXSEZPpWHBzJRio/TDypfWn7y+58nZc4k
         VFheDFPXSDVngimGTXPr+ZA4Siy0P0p+HC/jbSgD0H2XfnhtPQXQ0Nl///GllBd2Tk8L
         BKfsQUW+I1bAAXPMMqlL1LqzMkT/+/y8xT3jK6bNZBVhxzT0R9miYK2CfCB3WMzaYzZj
         Y5woCyGP+cSoauHSg3wIYXxSIj8aNdvYtxN9nmAgm8LgvlhvYqLUi4HQRiqV/BgzRYjV
         3I48IPfEQsZGwqgoW/nN81hJi2+jGKzzYkZ06lLXi3YQu8lp5kaBYPOOCkQhfQnqmwRz
         uQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OTYZuCAo5R2kjph4kWPglVUSjijOi7+4l6GtPJgV2w=;
        b=jyvCDgE0JjC6j4itt0FmEn/hbAxATC7IcJ8O7aNKYs/yYcO5G1aujk0JhL/+JLrAfX
         E+KTf46YVLWP3kyAZoKq1FnE4ruJZpZo1Y54CT7tKZ6kiTwQ7lxzAfSHBOthHyDv2+IZ
         +nrR+f1x2od9zuxKaVOfkfBHjSAJQ1fgdraGq0V6Zko5U2VcMZxn56joT/rduxxFNmhM
         UsGCGyUp3Q9yt39BaunW5GkDf49sB+WMgGkbNFuxrT5iHyXgc2J3qYukMVwgzyw4cnnc
         4bV1zJpjK8OX0QfTUEp4aoz8V+7w42BcpdzFlhdKD5jr03G/mFoFXNMwQYY7Ixud5Pqv
         k0NQ==
X-Gm-Message-State: AOAM532QGFhSsnUVJ7uRYUYBQNQVkbsaJs/wyp0W36kfxneKoDanATg2
        josQAkp64b2T/dBNUicWvQ3CHx8i52k=
X-Google-Smtp-Source: ABdhPJx/wXhCzLrIJkspymiK87dfozkVOjtl4StU9lHbuftfBVC/9v4CD7Q9SOILceB4LOLv7inMJQ==
X-Received: by 2002:a5d:5258:: with SMTP id k24mr18842493wrc.390.1631625165061;
        Tue, 14 Sep 2021 06:12:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/21] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Tue, 14 Sep 2021 16:12:20 +0300
Message-Id: <20210914131232.3964615-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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
index bd0517e1..94fd8693 100644
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

