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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D3AC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 05:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D23AA6141A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 05:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhD1F0r (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 01:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhD1F0q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 01:26:46 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03E9C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 22:26:00 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id j3-20020ac874c30000b02901bab5879d6aso5477421qtr.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 27 Apr 2021 22:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TZg0sKLlDsmWSdbBslTzhoDO24e+eJ5Ef7wsWtWo9l0=;
        b=T/hB1ZQ+1TsU8vyv3vkn6eQ46wC+f4I+EU24PUx3uIFWNg6vW+NmoqwJ9LvD7gTk16
         o1Ir5Mc6s+WwUihfVuAuHtUSOKBFLFROeooejxBRFPNWw+gjPtVgmsRMeHlJcEJ4hiJ/
         NQ1dUJ88KGr3zL1TTyauQW5lZoYnIfH1uHDESj16vg8hw07iv7O5GtS/mlp8ZEf6xTXU
         2dxBir5c8uteVSIZCVNcet/5r6EE4cCstjYGCA2zKZa5Z8YMIy4SAAJhC9I0661i/G89
         XG9s/2m42g9f/0SBCDISAVguXkn/3v3K+5wk1g2MVCAMxkvORg2fSRW+HIHHWXnaPnhf
         dz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TZg0sKLlDsmWSdbBslTzhoDO24e+eJ5Ef7wsWtWo9l0=;
        b=cRO4RQeZntXr42dVEqpZw570oiEzPd9wTY90+VGv9RMqbMgBbXsE3n2uzGZ9AXaR22
         xQa9UFG7tg3bfXshXiN9w43c6WZK33Mn8mTUnpabaVyW2rv55gFeGfnMMCkdg8OaMmmf
         kncH5FQTZ7IaJUSPutvFugAtuzxskVEIMn23iZSmcqV9m2NiRfqSVaop+2W3P4S3Y1p0
         /W6HQIkjuCJib/2+8TDg1TKSHWj4UpQQDvzX3C7pERSO4eZOVtl2Zhd6MtkOCI4f60ey
         biAhfX+dueGjCRSw/pMXAu2cKTObDkjyx4xAWQINYOtpW7yUP2n1CemkwG9eha0gVqrS
         64uA==
X-Gm-Message-State: AOAM5323+GHDhiiELwPAGcuXC66yiORrDUmCpcjfMUGoO/gmHBlVCvdt
        rLuHLCVAi8Wkghoe9+/QQMF/Pws5E49B5McUoVH41+LmW6sxPJnNG4LASpPW7ihfhw9Ds+IbOQT
        1/P0tbQjW0Zcm9eur45PXcGDWPnCQq9jeyG6sDBSjfdzsZm0Gk1BWWz5JNaGPvwMPeg8KwyzIO3
        iNvGk=
X-Google-Smtp-Source: ABdhPJzoFEpNh8ZjCZpEwXtRw1zrA6mXXjw4nt9DtK5VUHW9/mxddtCW2l1NniyK51NcQuB+iDUVGsmN++oi
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:e183:91ab:b9a2:4571])
 (user=irogers job=sendgmr) by 2002:a0c:b38b:: with SMTP id
 t11mr27595167qve.25.1619587559834; Tue, 27 Apr 2021 22:25:59 -0700 (PDT)
Date:   Tue, 27 Apr 2021 22:25:40 -0700
Message-Id: <20210428052540.3364743-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH] trace-cmd: Silence a logical-not-parentheses warning
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Clang 12 generates a warning of:
./tracecmd/trace-stat.c:719:15: error: logical not is only applied to the left hand side of this comparison [-Werror,-Wlogical-not-parentheses]
        if (clock && !strcmp(clock, "local") == 0)
                     ^                       ~~
./tracecmd/trace-stat.c:719:15: note: add parentheses after the '!' to evaluate the comparison first
        if (clock && !strcmp(clock, "local") == 0)
                     ^
                      (                          )
./tracecmd/trace-stat.c:719:15: note: add parentheses around left hand side expression to silence this warning
        if (clock && !strcmp(clock, "local") == 0)
                     ^
                     (                      )

Silence by using "!= 0" as done elsewhere in the code.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tracecmd/trace-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-stat.c b/tracecmd/trace-stat.c
index 3112787..cb92622 100644
--- a/tracecmd/trace-stat.c
+++ b/tracecmd/trace-stat.c
@@ -716,7 +716,7 @@ static void report_clock(struct buffer_instance *instance)
 	clock = tracefs_get_clock(tracefs);
 
 	/* Default clock is "local", only show others */
-	if (clock && !strcmp(clock, "local") == 0)
+	if (clock && strcmp(clock, "local") != 0)
 		printf("\nClock: %s\n", clock);
 
 	free(clock);
-- 
2.31.1.527.g47e6f16901-goog

