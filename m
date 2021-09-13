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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14693C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F041460F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbhIMM32 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239998AbhIMM31 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:27 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA30FC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:11 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id t18so14459372wrb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3OTYZuCAo5R2kjph4kWPglVUSjijOi7+4l6GtPJgV2w=;
        b=PAL8AM5oR9xU5++PkxNRjn2cI+tIO+E3oYz+OnlLKvjTksJvmel+R1TbYucLLBsgjy
         xvMDbbNrzvXW2bxJ0VutFLFO03vyiyk0ZgxRPCmavQNJL1Wwc3UOsevLzI0KanD9Cmyx
         Lw/UFBTFufUOt0MgPTRNr7YLcJAZpoa0HXv2mDMKPTKR8CDWhPa0QVTdYLTW3vkf9YWK
         lMPT8EB13k9Z4Y7lkyDIS4IYBFUmKrUIP/PZFRqa4GfXPYg2mG23zQQtgTvjKUx6nOv7
         iz+jIVq/phcgAnEIDz47snXMBNskIEreRPKTO8n9B0O4VRJ69llS+3X65LcM2ShOOtBv
         xckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3OTYZuCAo5R2kjph4kWPglVUSjijOi7+4l6GtPJgV2w=;
        b=71+wxbS1fm0aoodw3arY0r8Mm+hm4Hw1vTvPNZqey/jeUfCYaThoOvDwzpa5802Awp
         rk88VhMoflSiZ2objI2YXdzfYNrJVDvjXmoPh4fmqI2TEmGUhiwJsiCA3jIznkhzKyze
         RU1c1DVXaOA9XkHgrGsfyUO27x/tDjwYwdwUhjyaCUH+YHuSoRZBhxBANI+5xoOQ+i4V
         4WMMYxO9JA5uibw/v8NcqBuAsXKSkNBuCpDcM97osXBxc+676Bz2UZTHY164XwTs2StI
         vPHYR3wrQspPEkb37F+JkGSKHphD+m60PR9mM6qFymeM/4JEOiUuCKcwLHUbRjkxECez
         ukjg==
X-Gm-Message-State: AOAM5339LI4fFBHrmlZ/x5+Wq/WrjpNOa5TCAXzRgGmWMmnoDcc4fVFL
        PbVKmW55tCy/L52imI710kkYSzLNkmI=
X-Google-Smtp-Source: ABdhPJw6FYPzOy0m1vbg618ShVxKvvwFZo6AYif+wGZr+N2jT7mY//uyPpTPeL56N/P11LkUj5HQNg==
X-Received: by 2002:adf:e406:: with SMTP id g6mr12323940wrm.172.1631536090545;
        Mon, 13 Sep 2021 05:28:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/21] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Mon, 13 Sep 2021 15:27:47 +0300
Message-Id: <20210913122759.3672494-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
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

