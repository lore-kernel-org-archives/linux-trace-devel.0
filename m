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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39040C4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B8661052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhG2FKo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbhG2FKn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:43 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9FEC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:40 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r16so6379142edt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xWxLdmFaQRTxvlmcJRKFanHtyMsC2W8pFfsQm7TZ+J0=;
        b=Qm6oB+1UAe2xTpApsVC9TxN5aPslaKlf1Un9rEhCknKM2obrvqmoKJb95/zpqA1DQO
         XLtbGxP8UuT67WCggw1a6CxIHZ/oW08+h0vSddat+JfjJHODC52e+Q2pbBxqaQLj3eU4
         D34wooLB5DUbwv20yEDqToqgpr6Q8hvI2WjkrKS2xqVwoWYze0Pr41ian6baRdvRmtLi
         e4E5bp5+Oo3NoeJ5IKpqm5FVebaQmoLMRw1MiwPusVUwKtCvD+FJ3lEvFRqlINpNc1L1
         nuZ7HUfkXbNRztmkvbjQcQC+i1xJe/MBm7YqwPeBKBsjGlXE/aoqj/fJG02FOZpN1r6B
         dcZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xWxLdmFaQRTxvlmcJRKFanHtyMsC2W8pFfsQm7TZ+J0=;
        b=mvRoOsV6elD6vuGoPt4rreYX6JKCIuF4fIBuZKqnrh+o/wa3/WHEB8jApk9qChdQqb
         pm3g250liY/vrSY7p1wnbT6EGQQFPwaIPYnhyXz0ILGORj5zEGue6HHbPm6YAoVob8CB
         IoNWMcXY26onRSb7CvwQKj/W2Xq5b4sda4cJqcV+m0AFuCovmxb5e641/2ig1YdCRIvR
         zFGRYUUb7puvSz0YTScZfa/uAqcWsX2OJx7lcIXkWQu31EwKsUH935J1qp73++DGiN/j
         bqgdM9MUTTPSM/RiPIn5hwZBga7ZCzH3pRFRbZMHKxAvtkLSFgwHymPqH/6TLBltV24I
         8sWg==
X-Gm-Message-State: AOAM532Q0HgPJZxya1MjsUDSa90JivAUr6ATt/u4YLrYxxHsAQtqWOxu
        aXr0SBFAV4KZEGKS029HabA=
X-Google-Smtp-Source: ABdhPJzGi1goT2HGvdMG+C/BhB/yY24YW7z6psr4r4xolrjq3HXdoyXoGw6FeW7ZqlVZkQBoCm4Rsw==
X-Received: by 2002:a05:6402:896:: with SMTP id e22mr3999428edy.246.1627535438737;
        Wed, 28 Jul 2021 22:10:38 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:38 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 38/87] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Thu, 29 Jul 2021 08:09:10 +0300
Message-Id: <20210729050959.12263-39-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_ftrace_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 0ced15a8..b36df98b 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -720,25 +720,28 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
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

