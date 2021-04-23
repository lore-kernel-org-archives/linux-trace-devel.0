Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A822AC433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83DF161208
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235302AbhDWDzV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 23:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhDWDzV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 23:55:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B51C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id u3-20020a2509430000b02904e7f1a30cffso22678127ybm.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=56mHbNi+R6K7bh8gB7ZH0RQCkzW3yUyT7UcMyCtPH40=;
        b=UknrSXEcNRAz83IHKwbnnlltEvO52xid+PKyztVhwuiz+2iWFTOTJrMQAy8XlzI3XK
         TXHMXppqcrvUWZFmCrsLqlosm/mxtCbWQMIv81rvog0kxZ+Yu7/atIUmLiR9rto6zV1P
         hkQV/pe/ClvUeyCHuQ4Ujby8TUIp5cjefWVRQDtthfhOl+aiwnYgx7dQ+CTRkLUl4T20
         SHb6KDXKi1U0Dyh32yZ2eKS/2+WiuHbjL83kwBMQ1gFlde5mX8CcWHkqCCxpVkdx8YsF
         JOi9QhL78is2pyEX1ZzxwgASRRznDwDnC18jPxs6bfeOAF32FKhjkm3I5HSlUa8DMee1
         7rOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=56mHbNi+R6K7bh8gB7ZH0RQCkzW3yUyT7UcMyCtPH40=;
        b=O6Gg4lOQmqwctS+8+cngU6IzBl+zwWN10AmewWL+TraphiuG8egZzYn+Sru74reeuZ
         lfKEdD/ooiG6WV8jnZkTZdRpbSHJIa+3u+WseihRb+w3nQS63Cx4LoMLxYHZRXbJLc/l
         XxdOzigaBYBeqOIrezG2j6AT7JuVuBV2xeX7fY4r5nVyaS8/MoMkLqtahqLY3Ikhlk5T
         1esILm/A5JxrISiLqkVupCanr5tXYoAnN0f6YQlvbw4m/JVhapnicBzSuaGom/zm1qG/
         KJfJf3TyZImP3ORryvC/Mryd+ucLSuEWjWtbR0pkYZf6q0HwL+dklmQ8UXhqV97s9t3j
         Nzbw==
X-Gm-Message-State: AOAM530KQ9zfbMHRR+6GN2581F0guo8ZFp8y0I6l0d4bVJtBW9SPBB3H
        Gnt6y6/P1CY+ohdWANZWFXROmqtPc/o1ml9GjsOFtlMMrqD8z2pamdvESJkbKlaHUwp0Zm30WkX
        LvKOpkGyKmrg4UXhZI8WR2QY9kOGSaRi9Ge3Mez/0O8bzb6YOWyACibqY7LJ47u6rI+qlmyeVsZ
        tAITc=
X-Google-Smtp-Source: ABdhPJy49jUh0hzUz7QJ52zNR+AQ70kb8C1PEi2uF08CiOq+ri2Q0BfTyHqiNjB3lF9OBSx9tDz3iY2fqwsm
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:3c22:2043:cc12:f66f])
 (user=irogers job=sendgmr) by 2002:a25:71d7:: with SMTP id
 m206mr2791696ybc.282.1619150084568; Thu, 22 Apr 2021 20:54:44 -0700 (PDT)
Date:   Thu, 22 Apr 2021 20:54:37 -0700
In-Reply-To: <20210423035438.2221760-1-irogers@google.com>
Message-Id: <20210423035438.2221760-2-irogers@google.com>
Mime-Version: 1.0
References: <20210423035438.2221760-1-irogers@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 2/3] libtracefs utest: Fix a sometimes uninitialized variable.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning looks like:

utest/tracefs-utest.c:706:7: error: variable 'fd' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
                if (rstat != -1)
                    ^~~~~~~~~~~

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index c5efd5f..a0d911b 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -659,7 +659,7 @@ static bool check_option(struct tracefs_instance *instance,
 	bool supported;
 	struct stat st;
 	char buf[10];
-	int fd;
+	int fd = 0;
 	int r;
 	int rstat;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

