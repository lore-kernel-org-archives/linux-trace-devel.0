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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8913CC43460
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC5D61208
	for <linux-trace-devel@archiver.kernel.org>; Fri, 23 Apr 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235684AbhDWDzX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 23:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbhDWDzX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 23:55:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7851AC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z8-20020a2566480000b02904e0f6f67f42so22974652ybm.15
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 20:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MLwUC0ZUWKn51dYIAQ1E36aOLYJJ/6aEivrPEf4bZ0Q=;
        b=Jnjiq4KXa0XZqikCO+mI47zjGMG02CsEFsbHOWZkmanx7TkRieikAth9g/CO+ooEe9
         RRg1+jmhyJEIbMM11f7ZZDpit8ZUFKOIpsH3CThUNKxvqeN879WVKH3Je9GSylNRsbvG
         jAi/cySEyIvyhExL4P8Y5Bovz/owDLFfKKBwNh0GW7BP33J2CkrtqfhjIvh5fCj5BrOn
         L9yQJyAccYZ5bQBbOwJ+ty8HrlSmyWoos69mtVOsKDROiRxJ3/EPQZK+eVzFK/d1Jl3Y
         YlqZO2Zp4sLwe8CMuBuzkAwFR9++yeO1ERFY3uxCShhKhF9XHk5GWb3GlJBlvRW4maZi
         iGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MLwUC0ZUWKn51dYIAQ1E36aOLYJJ/6aEivrPEf4bZ0Q=;
        b=bVn0tSnit4welr/++iXzqxdkw08lvlcwL4Q8FNHXqZUHyy2SFVxanVR4xDBBh1Nkdk
         gef398T+AliRAHpYEHAuSaRVGWNzQM83Zz/TnK8ZAw+TpPRZvrcHMupSLnbhjX9rwRsQ
         PJntzwGILeSvcYq/fwVnDNhc/VpwrYt1XCY8XHh6ziFUONiXpl+PhqCvIPHPU1A9rIhV
         T//t7uzWIh+bhkveVxTjEHm1ex1P7ZqZG94VSiMqTPP4JieNMPmiL0W8Rz8b3TsMJUYa
         DNSSLryadOJg53lyGRJ9sU6XHP0yKgHT093XR4ueRMnG0J5GhtoEjYY1/8sJ50RUZBvq
         Nuug==
X-Gm-Message-State: AOAM530ICSeCPf0qBXxWiPr1XPJJWMqs5zwCTXSvcUQQAj/39CnIqB8a
        OAm6f2mHqafRH+t9n5ishkKWOsFFT9PBuewfGLcXTyJYFsnIltiu2SCjhu2Dln2MAy1bH+5wLql
        Ag5aFxYKyf3tzD150k/oNwlCNVh20H+575ZyEtUVk6MA2kzQLoqc/loI7Fp7qgY/FwcKrnAqKh4
        Knh7Y=
X-Google-Smtp-Source: ABdhPJzC0FXPH++f69MXTcIOnBCEPvDDVHkp+JYvvblK9EDFi6pK+yZ0lOt/1+i0D06LHTdv3sg6LTfEd3wm
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:3c22:2043:cc12:f66f])
 (user=irogers job=sendgmr) by 2002:a25:c0d5:: with SMTP id
 c204mr2738074ybf.57.1619150086651; Thu, 22 Apr 2021 20:54:46 -0700 (PDT)
Date:   Thu, 22 Apr 2021 20:54:38 -0700
In-Reply-To: <20210423035438.2221760-1-irogers@google.com>
Message-Id: <20210423035438.2221760-3-irogers@google.com>
Mime-Version: 1.0
References: <20210423035438.2221760-1-irogers@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 3/3] libtracefs utest: Make a null string fatal if it is
 passed to strstr
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

strstr will segv for a null string. If a string is passed to strstr and
is null there is no point segving, it is better to fail the earlier test
with a fatal and continue the rest of the suite. This allows the suite
to complete with an error rather than die.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index a0d911b..e846dc4 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -452,21 +452,21 @@ static void test_instance_file(void)
 	ret = tracefs_instance_file_write(NULL, KPROB_EVTS, KPROBE_1);
 	CU_TEST(ret == strlen(KPROBE_1));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST(kprobes != NULL);
+	CU_TEST_FATAL(kprobes != NULL);
 	CU_TEST(strstr(kprobes, &KPROBE_1[2]) != NULL);
 	free(kprobes);
 
 	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_2);
 	CU_TEST(ret == strlen(KPROBE_2));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST(kprobes != NULL);
+	CU_TEST_FATAL(kprobes != NULL);
 	CU_TEST(strstr(kprobes, &KPROBE_2[2]) != NULL);
 	free(kprobes);
 
 	ret = tracefs_instance_file_append(NULL, KPROB_EVTS, KPROBE_1_RM);
 	CU_TEST(ret == strlen(KPROBE_1_RM));
 	kprobes = tracefs_instance_file_read(NULL, KPROB_EVTS, &size);
-	CU_TEST(kprobes != NULL);
+	CU_TEST_FATAL(kprobes != NULL);
 	CU_TEST(strstr(kprobes, &KPROBE_1[2]) == NULL);
 	free(kprobes);
 
@@ -1026,7 +1026,7 @@ static void current_clock_check(struct tracefs_instance *instance, const char *c
 	char *str;
 
 	clocks = tracefs_instance_file_read(instance, TRACE_CLOCK, &size);
-	CU_TEST(clocks != NULL);
+	CU_TEST_FATAL(clocks != NULL);
 	CU_TEST(size > strlen(clock));
 	str = strstr(clocks, clock);
 	CU_TEST(str != NULL);
@@ -1041,7 +1041,7 @@ static void test_instance_get_clock(struct tracefs_instance *instance)
 	const char *clock;
 
 	clock = tracefs_get_clock(instance);
-	CU_TEST(clock != NULL);
+	CU_TEST_FATAL(clock != NULL);
 	current_clock_check(instance, clock);
 	free((char *)clock);
 }
-- 
2.31.1.498.g6c1eba8ee3d-goog

