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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ED2C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EA9E6023F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhDWDzU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 23:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhDWDzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 23:55:20 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442E4C061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:43 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id oc5-20020a17090b1c05b029014c095a5149so22474890pjb.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=9y36gi9OG7U6SdUqvogPYMqazMqDYQ87jPlmZy0kjns=;
        b=D+Ndknek6dc3djnFCrOEZR0FI15q7lH9+uNveWvIOnrdmu23vg3ZrCw05AC/QKpaVp
         MVN49Kt+MwNwsett3Jmb3r8CKo+c8UQTvfFAnE17EI1x5lXhbRpSdwBi/bbbOe/7SVml
         2PwnGBkQnQPJYgT2hbsBw10FQQE5NXyBD8vMLCihtZzNz5HyAk4qCcvwtatXwPlslufQ
         D2b2rlmizK31mMMLN1y78fgX+o/ITVKMW2DXDkBdwvxoAe2iTJSE16dDGTY1k47BKIS/
         HF1sSgD2sktsr3gJkKkYAzHwzf2eerJejeQyM+K7iwR1VJGGCU974I6VOVlxzZRlVVFQ
         9gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=9y36gi9OG7U6SdUqvogPYMqazMqDYQ87jPlmZy0kjns=;
        b=MC2frFNHu4RkRC7LQIxG1R3qEqMcU3CJ28q3aa0flO4S1hjZNxLBbQzAdwTC0foj9q
         3fVtBvm60MB+p9j3nO4DI3fCXADAVePJYbkTq96TqkOFUCV46zQth9qwXkC9pBqB34UK
         17bORJZdQKKN7xvePri0UNqAkdMjc3Hg9aqkOi3n9rN8PvyedixLtMGsDYG/smTGc7g8
         +kcPld9XJZc2pGaOcOupXRUSJCy5nUpA2gD8YYFoDq14gO+yQG/Pbu0QQhll6mwz0yEB
         NwWuuJ2ixlFMGmztSgMBEG4qfsECANjHsaf0HAnIXxK2BIfbIVNEJBh2G2VsmKhTziu+
         GbWg==
X-Gm-Message-State: AOAM531WdjEvd2350ahqlx8fI3IPNpQK8GzL9tdWUqCcTsGk7muIcYaU
        0IrMepgsnZREyMQAcn9iZj6nC0512GKtFaUCtistfhkdQYqq6sOmAfLVCwvG6MfDph75TOe17MX
        aOKdd7AzDACJ42cZzbBm6r89fOYwP04em11TtWdRhOb7A+YCAjFNM3jeMEalnONmSI+GpMisMHY
        TMj+A=
X-Google-Smtp-Source: ABdhPJxF+57OjO0zVuWPnXln5O6puUrmVfmlqMv3TR67j1yTHYh0B8gIF/fKgILFVX4F4ELUOjMXhs9Y04N3
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:3c22:2043:cc12:f66f])
 (user=irogers job=sendgmr) by 2002:a17:90a:b105:: with SMTP id
 z5mr3401148pjq.187.1619150082567; Thu, 22 Apr 2021 20:54:42 -0700 (PDT)
Date:   Thu, 22 Apr 2021 20:54:36 -0700
Message-Id: <20210423035438.2221760-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 1/3] libtracefs utest: Silence string-plus-int warnings
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix warnings of the form:

utest/tracefs-utest.c:476:35: error: adding 'int' to a string does not append to the string [-Werror,-Wstring-plus-int]
        CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index edb3a3d..c5efd5f 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -453,21 +453,21 @@ static void test_instance_file(void)
 	CU_TEST(ret == strlen(KPROBE_1));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
 	CU_TEST(kprobes != NULL);
-	CU_TEST(strstr(kprobes, KPROBE_1 + 2) != NULL);
+	CU_TEST(strstr(kprobes, &KPROBE_1[2]) != NULL);
 	free(kprobes);
 
 	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
 	CU_TEST(ret == strlen(KPROBE_2));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
 	CU_TEST(kprobes != NULL);
-	CU_TEST(strstr(kprobes, KPROBE_2 + 2) != NULL);
+	CU_TEST(strstr(kprobes, &KPROBE_2[2]) != NULL);
 	free(kprobes);
 
 	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
 	CU_TEST(ret == strlen(KPROBE_1_RM));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
 	CU_TEST(kprobes != NULL);
-	CU_TEST(strstr(kprobes, KPROBE_1 + 2) == NULL);
+	CU_TEST(strstr(kprobes, &KPROBE_1[2]) == NULL);
 	free(kprobes);
 
 	ret = tracefs_instance_file_clear(NULL, KPROB_EVTS);
-- 
2.31.1.498.g6c1eba8ee3d-goog

