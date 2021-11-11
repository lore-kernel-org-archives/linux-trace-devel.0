Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F21EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B72261284
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbhKKPGD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232823AbhKKPGD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:06:03 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69B8C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:13 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id b15so25116871edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zoc7u92FnWKNwICURilcwlABFxlO+S2Ta7dqrANVtGo=;
        b=JXdByqakhYfi/toxdv5PptOIQicU7x3+7ymw83zVJrteNYpxd1v2KZ/4hoEeXqrFJU
         DHtIK6VndZLhzNH5G3+ib32c6ESbwBBUV3RS7nY3I9gl6mAWQsIBI/Cz+AM0pKaE14YR
         24jQqDLbqrXv9hZG4uqpGPGfF9xs3kXCGJN3czldCO+FjY89qz6AnxEixuhTB5zVEUos
         2RI3kJFrfxgcGp7O2LjAOkFxwWMgQjGGBqrE0pO7cJQfTHD4I2Lr2Sxey0m+FV1sMIKY
         5d09nP+GOSNGSLNAJiHhc1tV6bLGquKjzDejN8a1JIwK9G2g1O2hlcDWI6IkO4lrY6dX
         SVxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zoc7u92FnWKNwICURilcwlABFxlO+S2Ta7dqrANVtGo=;
        b=mbboTAli07UvUxcY49xF2aMnUH80sJ7XDdzp5HqZH5jOvauOCflcWoE/WtOQpF3RMY
         ZL5gBwWfmz42b0DbqAi2N/8UgnJAVxKkJWOeEOE27j1yhdhbobE7gua6E0CvUiiOJa2i
         /MBB+uAEd1H53riPgMM2CPA/bIA1/d8peSqz9KvnHeqVRLQ+BagvyD33bwCm2aNPHFIf
         VRQPJWS6FfFLlt0tx9mhCT8OJN1OTQZ8Kq+XpH+9OyZK3Xpji2yobDIGv+SFtUYYvLai
         N4pCm9COdWD+hdY3UYTz97BA6BAIZGYgd4Uk1NUzCCdkV/jMjEQPOfdVImI8qic83yUl
         PGqA==
X-Gm-Message-State: AOAM533qw73CXtdmbJMQqtVQ0aft1Z95s4gUQqXQsHrPsKvLRV0zSlFS
        Br91FCAiuEtw3la+e+lfQYE=
X-Google-Smtp-Source: ABdhPJzU0DmOn4qCBxrYsMmEF6MHt8Ifd02dDpXlbwD6sgTznOku1xxgxveGBhU45u4xYZcOobnmnw==
X-Received: by 2002:aa7:c956:: with SMTP id h22mr10707120edt.24.1636642992187;
        Thu, 11 Nov 2021 07:03:12 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w3sm1737826edj.63.2021.11.11.07.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:03:11 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 4/6] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Thu, 11 Nov 2021 17:03:03 +0200
Message-Id: <20211111150305.85943-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111150305.85943-1-tz.stoyanov@gmail.com>
References: <20211111150305.85943-1-tz.stoyanov@gmail.com>
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
index f9dd0784..edf84993 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -618,28 +618,30 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
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
2.33.1

