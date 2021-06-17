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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B82C49361
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BF32613D5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Jun 2021 19:43:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhFQTqD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Jun 2021 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhFQTqC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Jun 2021 15:46:02 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD9EC061574
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 12:43:54 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id y6-20020a92d0c60000b02901e82edc2af9so4531689ila.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Jun 2021 12:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fuaV1+ObE76hPBSxwnJ1+z4E0ooCaUAA9Jdria1q0FA=;
        b=srimWNqnwQeG0ZgnofYTFvSgXATBGLE8SrRwTcvV7adXQ3fyzbDY1aznQnx2HHmHn5
         T9vzpJbq30Pn8P0KbVFBf70HF6n/KggCXEvWdStYUQUinyQFfK0yF9iWrcR2/cmJaRpg
         wyrcKK0IR0oGNl008PttQHkQhSv0CXDzgLLzKv7P73VOYuoLRZUMImmxKgcQci3jAMuq
         cjzUNQGNH1lF8Y2eu2zicqz33nApy9TALfSuwpqrGExNmitDG4IqULg6zkAwQZTKIWJr
         +w7XZyOyvNA0+iu/Rnd2L+HFnRs0drLk38L97fLO1PM4hzE8Ojxdyu6SiZqJU/lRUsXR
         JosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fuaV1+ObE76hPBSxwnJ1+z4E0ooCaUAA9Jdria1q0FA=;
        b=VDhzWFjJ7nVlNx5JBxwF16Q/8gS93THtiM+BgYH0yaoHG1iYC97LTtQwmun65S1H1E
         9AebwfdRaWaCuFTyzVZHnLQ3yF4+H+NAvqB0HaSXVkYWT0JiMsges7QqziL8j4oxhBrC
         T8r2aG78/dItzRAYuZ3hVcI/e3svtg5/fjZDSX2LJ8AnFTzT/WHj/Zu1krpBqSlPu54O
         r8ak9hTPhPiEVEPClGJ5VHNx1TCzeXYFXapRDuEtJhKPiLUfPnXNAzmpgjfWoaueeZlQ
         8RSRMYy0xbGQJxQkA9eQ5SpjER3t88UtWmJTXxLvE+S5axaSNhEkSvc+fdLlEcccz5SN
         qWag==
X-Gm-Message-State: AOAM532DmUbO2KghqHpmuxBYufw9sScaKYvRHfU1FjJ9tZMvT+FNHxFO
        DeQtTZSkJ0KLCYAKyX1GnD0+EebCt9s=
X-Google-Smtp-Source: ABdhPJwqTbESR/5JnaRfcY83GN8n6965ET7IzRhy8Mr+jC142G/iDQP2zwoeDKkwqwcr2sRNOiBjF+nrh+4=
X-Received: from cjense.c.googlers.com ([fda3:e722:ac3:10:2b:ff92:c0a8:6d0])
 (user=cjense job=sendgmr) by 2002:a6b:4e0a:: with SMTP id c10mr5003916iob.183.1623959034074;
 Thu, 17 Jun 2021 12:43:54 -0700 (PDT)
Date:   Thu, 17 Jun 2021 19:43:26 +0000
In-Reply-To: <20210617194326.2107129-1-cjense@google.com>
Message-Id: <20210617194326.2107129-2-cjense@google.com>
Mime-Version: 1.0
References: <20210617194326.2107129-1-cjense@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 2/2] libtraceevent: Changed angled brackets to double quotes.
From:   Claire Jensen <cjense@google.com>
To:     eranian@google.com, irogers@google.com, tz.stoyanov@gmail.com,
        linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     Claire Jensen <cjense@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Certain build systems, such as bazel, are picky about angled brackets vs
double quotes.

the failure you see when building is:

In file included from src/event-parse.c:27:
src/event-utils.h:13:10: error: 'event-parse.h' file not found with
<angled> include; use "quotes" instead
 #include <event-parse.h>
         ^~~~~~~~~~~~~~~
         "event-parse.h"

Arguably -iquote is more correct within the library build, hence bazel
using it. The libtraceevent Makefile is using -I, hence this not being
a problem for others.

Signed-off-by: Claire Jensen <cjense@google.com>
---
 src/event-utils.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-utils.h b/src/event-utils.h
index d377201..44f7968 100644
--- a/src/event-utils.h
+++ b/src/event-utils.h
@@ -10,7 +10,7 @@
 #include <stdarg.h>
 #include <stdbool.h>
 
-#include <event-parse.h>
+#include "event-parse.h"
 
 void tep_warning(const char *fmt, ...);
 void tep_info(const char *fmt, ...);
-- 
2.32.0.288.g62a8d224e6-goog

