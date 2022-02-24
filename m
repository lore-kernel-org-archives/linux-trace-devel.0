Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8ACDC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 23:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiBXXtC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiBXXtB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 18:49:01 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDBA1AF8CC
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:29 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d726bd83a2so14213597b3.20
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=82ho6qAwNgphSNXK3V+OnTbzg+B63TEn0Z/eR3ztDLg=;
        b=kysSIfSj2MJVvzamJY0I2F6v8HCgDwvYedOrt4WfgffJ9+MRwBLdzQnAOUn4zKrxNJ
         cwbJqNJyLxouGqn0FDIgUlLJ+04hvGLNShj4bDEsbLhR7/MgOOOjRNlEYLsSpC6si8Sg
         jqlNF6EH4iTGBvkOt7u5keYvLqsKGAhTMf02uOHHgwHv2aEgotysVXWPscLKPaNgVSsS
         Lr2PnRMrhVgRLgyAOD2wpYpaWo/lB6Il/xp2S9iqQWCIB6fOtsg8DCJKUOSRru5kDORh
         2HbdUSUd3DLnvJT1eVQ8xdYL9rSiHOsxF2Wym6eWRd9uJXVuYNeq6f9WTD7Dj34yIhOw
         JlTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=82ho6qAwNgphSNXK3V+OnTbzg+B63TEn0Z/eR3ztDLg=;
        b=idbvCgXmnHyS8CjnKE1C7xpwRsl6UnwJxxP/FXUMwL9sZDPyyPw3g3Y2lBUMrIoelm
         OmYTMCA1b037OflMZBkTzrUD0i/7oCFxz8ALmKQirgyY/ZxgoqINGleVQM8Bsrt0wBx3
         HuvNyyEZsyUsUBuAiR4m9NXMkE8DZ9oj2yppYM95waOIbbvcfivdr2AztbGvRacqkXy+
         luif/ur4RmhM/Ldf8OwMYyeZ2FOAZWdwSnyIysznT49d9c/lXepA49/vzkNPlGexvaBE
         DQvIHBxvJqovJqBhmzELVl6hu7EBXzkl/KNeo6zxN3BDZ/dSqotwFs/b51SihcRS8IDp
         y7MQ==
X-Gm-Message-State: AOAM530bimDAGwr7cq78lYAi7bkvaOODm/tUgaRycuRPtUlAd/M1uMBb
        Lf1xKcZHIhqwqui88mzgNbzanE4lfb8CfbxBArUFw0tXFyhhXMSCO+LusZPQR6LNoyorHcIgUKQ
        RYp0iVbcxLj6b4EoSm37yP/r7eaf3FLcRvVjd+JBo7e6JDJZeefv+Q89R+YxiZTNFW50at/TrXL
        ch138=
X-Google-Smtp-Source: ABdhPJzJDFtAiLMcOvmxOO7JqOKCXk9mvP0/rfRO8mpy1/SOfoo79MudNSZVVCvXjI8JidVkHIJQrnObeTqo
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:213e:9e73:c323:5ae])
 (user=irogers job=sendgmr) by 2002:a81:5bc5:0:b0:2d6:5659:73c2 with SMTP id
 p188-20020a815bc5000000b002d6565973c2mr5094187ywb.121.1645746508964; Thu, 24
 Feb 2022 15:48:28 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:48:21 -0800
Message-Id: <20220224234823.1190425-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 1/3] libtracefs: Fix spelling in test name
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Synthetic rather than syntetic.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 0903243..5163004 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -436,7 +436,7 @@ static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent
 	CU_TEST(devents[i] == NULL);
 }
 
-static void test_instance_syntetic(struct tracefs_instance *instance)
+static void test_instance_synthetic(struct tracefs_instance *instance)
 {
 	struct test_synth sevents[] = {
 		{"synth_1", "sched", "sched_waking", "sched", "sched_switch", "pid", "next_pid", "pid_match"},
@@ -496,7 +496,7 @@ static void test_instance_syntetic(struct tracefs_instance *instance)
 
 static void test_synthetic(void)
 {
-	test_instance_syntetic(test_instance);
+	test_instance_synthetic(test_instance);
 }
 
 static void test_trace_file(void)
@@ -1706,6 +1706,6 @@ void test_tracefs_lib(void)
 	CU_add_test(suite, "ftrace marker",
 		    test_ftrace_marker);
 	CU_add_test(suite, "kprobes", test_kprobes);
-	CU_add_test(suite, "syntetic events", test_synthetic);
+	CU_add_test(suite, "synthetic events", test_synthetic);
 	CU_add_test(suite, "eprobes", test_eprobes);
 }
-- 
2.35.1.574.g5d30c73bfb-goog

