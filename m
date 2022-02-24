Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 791BBC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 24 Feb 2022 23:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiBXXtE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:49:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiBXXtD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 18:49:03 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680E01AF8CC
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:32 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2d11b6259adso14282687b3.19
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 15:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2w52hVJV4iGDxwb4wGEkKyLZ4bmHfGZ1+hcp6TuQfTw=;
        b=cJChxpIn2nmTxBkEYfyG1xUqbsjKf0lk7oTwd7BADy3HFA3TWon1Ux5v7HnrRfABmW
         sU9gg1345gnjhqsmKdnMUp+vpkA0WPt6t/Y31lgoHv5Q4+MwnLMQVVmMUeg/L6XK8ey4
         nWTqlpTZ2q2b8tvVe61aBNpkhKJA9NllhUocuiRfhmT+CuDM9ElMLVrT5qT4n4L8mC2r
         EepPFurjI6eKbZokZmjC4D5PE1T85QokMaRrtf8WerkECm2SKI7XGES7PZBa8wETsbIE
         uty3C1PnzCm769DbHjE8srqMRMM3V1DKG+JK/VsiTWIRyJLiDxmYDt4VmAdW+ZsJ6XN2
         uMpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2w52hVJV4iGDxwb4wGEkKyLZ4bmHfGZ1+hcp6TuQfTw=;
        b=0aZ2mU5IkgFFXftfLo41vMMSdS/4kFL1ZhFxif6XcpWaC967RXiu5c3uzZfwfZsQDo
         wawgORVY7fUw4zPGJg+UOVXFdi3NFc7XJgvY9j7suJlEunkbTfpcJ9hncW6lIEMfvzW4
         QQ9iC9PZxSp0l8eLsJTmQ+XskV7Um9DRQEXdDlSv5FQo4MbujAx+N+CpMV5njk3issPT
         ZNS7eex7vq7K+C06jgQLjPc4/aA8Rax5cVApx+91YV5RZgPLar8xgh2onxdfSx2aXbIW
         ZdBv50y30Zk3r1YJPXTJbOYwUkNA4ZWBRm8T5cmQ2GsdrUmcJwj5McHQpks6Pdk/P9CV
         jFsQ==
X-Gm-Message-State: AOAM533/Du3yUs8bs/Nl1Auk+6Ctif5bIV+3s/hbEbL+qUizN+V7trTU
        YELeh0A6/ZRguhqFrhWbGv+2yd7DeyzOr0t1RXm2YXrIv3b9HltLNNDy1IYIofCxxxKHz0Ns5Fd
        68MiJrJtgPYnUfV2P9ziw17VcP3U1XeliKS5UrqwxjIpVjad5XO/oOojzzVY94jepmDDVq30Bkl
        Fb+kI=
X-Google-Smtp-Source: ABdhPJxMeqgOtX2GZTEOvTobinLe4k49hgWUGxUe453UQMfTgQ03bkVheUZAIIwfgFOgERA1PKLKQUOPnpqT
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:213e:9e73:c323:5ae])
 (user=irogers job=sendgmr) by 2002:a81:d08:0:b0:2d7:81f2:67a with SMTP id
 8-20020a810d08000000b002d781f2067amr5020724ywn.328.1645746511625; Thu, 24 Feb
 2022 15:48:31 -0800 (PST)
Date:   Thu, 24 Feb 2022 15:48:22 -0800
In-Reply-To: <20220224234823.1190425-1-irogers@google.com>
Message-Id: <20220224234823.1190425-2-irogers@google.com>
Mime-Version: 1.0
References: <20220224234823.1190425-1-irogers@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH 2/3] libtracefs: Avoid null access
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The for loop handles devents == NULL, but the test afterwards needs to
also.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 utest/tracefs-utest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 5163004..7042fa9 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -433,7 +433,7 @@ static void test_synth_compare(struct test_synth *synth, struct tracefs_dynevent
 		free(event);
 		free(format);
 	}
-	CU_TEST(devents[i] == NULL);
+	CU_TEST(devents == NULL || devents[i] == NULL);
 }
 
 static void test_instance_synthetic(struct tracefs_instance *instance)
-- 
2.35.1.574.g5d30c73bfb-goog

