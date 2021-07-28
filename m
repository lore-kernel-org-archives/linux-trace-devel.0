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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E8C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC07F6101C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236666AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236691AbhG1Ndf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAD8DC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:31 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x90so3223358ede.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xehA2JXjnsXIOIR7h+AqKXwN+ZAZwtPKYqYNMjR+DK0=;
        b=rDuVj9NCB9T0+QqijjxjeP2S8QZnxwwWYzA9+zc7dyDuea2KxccNYiwMAwwhmsExcQ
         3OTa3BOeTSScr0zngiQg9SKU/QBPumHEv9W1HGO3Hn96cLjKuzUi/l7gySAYy2wAt8KP
         L1dNQP2hScVWPmhh2emWncwtTFe5mN4Gq7l24/5tA0E1AjYsPse2JoFYmhW4s/QHhnLQ
         gIOACVOFdK/uuD1VfuJBGRjYKVr0dENv+k1TNNxQQ8woOlkHtSsa5eeH3A7OZb2zqa6p
         iuAKtUeoYGB7kAqFT3FL+tcjIRkEffFHKexekKfgEaNBy43ORVxQix8sFylwyfIkS9s8
         CwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xehA2JXjnsXIOIR7h+AqKXwN+ZAZwtPKYqYNMjR+DK0=;
        b=Wjxgir7OYjG2ULwzq2vGb8c3unKH6Ef4wp+3DBtgqne9491J/tABYzE42w25OGxG0D
         +/wwt1QL5fvWKSvGSLgBAyXxqQXAdQO/B4T+DY53LZ2WtheucRTHmYAWXLyi3vspYkOn
         gVxQcZTgPRPbxI8MwXXr1ZyTv/KLiP/CXgzX34k1poglXTtqLzXM0ZjWywRgVTM2W+hF
         w6xF7XfeC2K+mLtR5VgWl7Del8Kig9OqK/cAW5bRBhzRMVgCGeUKtSsyUpSmzxyQC9G2
         in4DlMJyCsLsD8sz7ybsdG8Bq5RfHNLm86i4frVm8cKNDqLvGMSvgkwT/NEnUhBOM5TL
         kKyw==
X-Gm-Message-State: AOAM5322ELS6UGf1NPpXyHE9KWV6ucAKHeFuh2bzN2fvrKVb+TNs2who
        1JHl9N/Bs1n2y1I0Ig3Hyeg=
X-Google-Smtp-Source: ABdhPJz8FMaL+758DhnVN41qmKwvPufcgG4/G55Ao7EuCV02vm9zf+2vZ7oSLVRRTl1e3TXUKnumrg==
X-Received: by 2002:a05:6402:26d1:: with SMTP id x17mr9298161edd.126.1627479210607;
        Wed, 28 Jul 2021 06:33:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 38/87] trace-cmd library: Fix possible memory leak in read_ftrace_files()
Date:   Wed, 28 Jul 2021 16:32:01 +0300
Message-Id: <20210728133250.234140-39-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 1445a540..de1f0399 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -721,25 +721,28 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
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

