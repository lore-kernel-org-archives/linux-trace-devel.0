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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E538C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Sep 2021 16:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54BED60F42
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Sep 2021 16:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350083AbhICQpQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Sep 2021 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350010AbhICQpQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Sep 2021 12:45:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87689C061575
        for <linux-trace-devel@vger.kernel.org>; Fri,  3 Sep 2021 09:44:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso7092386ybq.10
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Sep 2021 09:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=P63D0UJUje7WHnxm+44pQ03xmu7CtDaPwUSqs4SBgn8=;
        b=Shi47me1viB1wZfn8gczWqbFltal6OSXUAokNe9qlPxDDDlwsCyIdbMgIbFYAxYfLp
         gawzrtB8EF8HRL3+rsS2pozgu/XvDKBnOjr+Jm2n9hs7YxGcJguRnTGnVyPz7JjFWKKK
         3asJi4ak2SFPinF9xGJSx4Q6iJPaobZm92cPa8I3Pa89Ljjj11YsQDs8Gl2saZP5DBuC
         PS0gYFHKx+xEo4Ay4gsTIs3pVzodYKhCkHOKYKu/ueEr/8WKgN+KsprgAgkxgsL49ULF
         +n/RaAib5+yTEPM84V7iz7aJ+753BwrnwAf2d5+RhZOmNEDd8G7W6IIjjbO2HhWZhXfr
         z+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=P63D0UJUje7WHnxm+44pQ03xmu7CtDaPwUSqs4SBgn8=;
        b=puKoZACk4nITH/Toraj2oR2QFToUzIyIivZl4Vykv+g49R/shXRJ4oynWOv9YTl2GK
         AbbdE6DGXdWLeSg4eUs4uOSFaSBibejPFJc76Qe4YhfFJPvos2DCbyubZeT3N4qnbUJd
         hnQR3dL0tm7HvQWW+jPEAd/olPiohAtJCbtSaOQBRyu6wpBBdE3cgdS67qiBXHcxau6B
         ekSNPu0J35jNG7b2k7fivPypC1IobhN3Y2Y1uoMGfr/oBL4uRi5gtQfF/RHaQ/0rbdco
         I4GqdZbuEtr7IMAavEsV2YPbLFk+IIkx4KnToveGKDbnW0k9yc/vwEQMwBGIZJmrez2D
         sP+w==
X-Gm-Message-State: AOAM532Iwq4sppuAJiCXQH5PDZEq6oJiPS4DilQU6EKLQQ8bVEvgWcXe
        d1DIH4gFQfTuH/q+/3y5KAbNrOqRF6NvnTMHNhW27eH25PB4oU51p7ERFEBfvNSI8cUWMLf/YKg
        Hou9BJ2wFGC8a4H0u3D4jtyuCPhP71mS3SvW9xfTGiL+LxBjtxJUWk/zA0fUZ712+2BIZeOZ2xk
        Mxrzs=
X-Google-Smtp-Source: ABdhPJxMuJXAsP3jKvN3z9zKRhwO8Q0eOLAgumdtIjkm1goAHVHZ3jmVXOgEIz0ecA36fJPIKPfH3FJWH9Ng
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:6cd2:c78c:69e9:f4bf])
 (user=irogers job=sendgmr) by 2002:a25:21c5:: with SMTP id
 h188mr5752168ybh.23.1630687455650; Fri, 03 Sep 2021 09:44:15 -0700 (PDT)
Date:   Fri,  3 Sep 2021 09:44:11 -0700
Message-Id: <20210903164411.3248659-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH] libtracefs: Remove unreachable code.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Silences related warning.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-sqlhist.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index f4dc004..2eb65bd 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -488,14 +488,6 @@ __hidden void *add_number(struct sqlhist_bison *sb, long val)
 	create_number(num, &expr);
 	*num = val;
 	return expr;
-
-	expr = calloc(1, sizeof(expr));
-	if (!expr)
-		return NULL;
-
-	expr->type = EXPR_NUMBER;
-	expr->number = val;
-	return expr;
 }
 
 __hidden int table_start(struct sqlhist_bison *sb)
-- 
2.33.0.153.gba50c8fa24-goog

