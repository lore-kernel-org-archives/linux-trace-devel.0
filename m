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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3824C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:48:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C202B60F42
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 22:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347756AbhIBWtp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbhIBWto (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 18:49:44 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB52C061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Sep 2021 15:48:45 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so3786043qtm.19
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Sep 2021 15:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l9W3GJ7FMRLQMuNOcnCSPe0mEFcvOTFnD1pO8PHVY+0=;
        b=OjE5g2ZfLYx4kdMSLppXnaTg40d0+ZLc6ZNEeKlgFZ5WiUwFx/XIoUJswElSGMGlw1
         8c8JDEPB3qCeVLMnsaEKlRp6AYggvLLmIZVEi0leWpzTeCSNGq2CfgmSF8bPmiWw39l4
         NyIZsG9zAwVhNTzoI2F1YUSeb1IPw/T3dEEEeHjKcdDuIUDjCmMIQniLmkZ1GTAQRjqE
         G5UDnaCvCO7/DITprXAMtMISndyR9d0sOoaCDMkVNOgI8V40trE+Dxei+FkS28hlXznL
         Be7X1RR95erPdBREs/ntpIV7+adLxVun9Ne7P0574S4vOom2VHLf72oDJWwQ+sc8QvRX
         xlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l9W3GJ7FMRLQMuNOcnCSPe0mEFcvOTFnD1pO8PHVY+0=;
        b=Y0DHK1akytLK3Ugy5jjVNuYkp9HoNuBtGAMJ3NYxiuBMWQkHyJfTgyFCIfmRH8gBqI
         NXT8bd40gkKc8R/zDgQ6Mx006LpF3YSyNPa6Luc0kEYZJMwYbpZCL2PWjezTS+xClhEq
         Xiu1xilG+FvEwI4li3QkqkIuDJYwfMaa28yAxGmhvAX4D0FeBJ8GrrNgrO3bwPBv68LJ
         W5QOC4TOwjr026rPKDe40exQGzUN3o8EvEu5nEG+y8ohBADYN/TrcM2FrYqNdPzdN79R
         SIW3j9N7o4F8CvnMmJrxBYcrLNa4ZQAJomSRiTZBtSlELgvvM8ufAOM70dLUi8fLDyt3
         VjLg==
X-Gm-Message-State: AOAM531nXx6UwDPtub0G4Bcvh2VXp234vcjwk7VPJGmupCQkHHSB3/tM
        Ucatm2DWfbxtq46SxUZ22BI9JWBvE8QNhrc+AdOvBBP2wOUtS/vhmUm+WKl9xRDmZ4Z7w6WfZhG
        yApfN4Yo0RDJJ0DVRjY50hO0aTfamy3ksFPthuXfbeDVhNtYE9wiSo5JOAp1BJqia9vQCfzpSzT
        +DLsM=
X-Google-Smtp-Source: ABdhPJwY2YNnz/gGKWLFw7M99seXXeiYdULcCfiX9VKl4QGvymf+ikjdzhqRwUEelIjxiV7cR46G+otT3s98
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:6cd2:c78c:69e9:f4bf])
 (user=irogers job=sendgmr) by 2002:a0c:f3ce:: with SMTP id
 f14mr724251qvm.33.1630622924616; Thu, 02 Sep 2021 15:48:44 -0700 (PDT)
Date:   Thu,  2 Sep 2021 15:48:40 -0700
Message-Id: <20210902224840.2518539-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH] libtracefs: Fix sometimes uninitialized warning.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning with clang looks like:

src/tracefs-sqlhist.c:1107:2: error: variable 'cmp' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
        default:
        ^~~~~~~
third_party/libtracefs/src/tracefs-sqlhist.c:1112:35: note: uninitialized use occurs here
                            filter->lval->field.field, cmp, val);
                                                       ^~~
third_party/libtracefs/src/tracefs-sqlhist.c:1033:2: note: variable 'cmp' is declared here
        enum tracefs_compare cmp;

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 6224677..f4dc004 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1105,7 +1105,7 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
 	case FILTER_BIN_AND:	cmp = TRACEFS_COMPARE_AND; break;
 	case FILTER_STR_CMP:	cmp = TRACEFS_COMPARE_RE; break;
 	default:
-		break;
+		abort();
 	}
 
 	ret = append_filter(synth, TRACEFS_FILTER_COMPARE,
-- 
2.33.0.153.gba50c8fa24-goog

