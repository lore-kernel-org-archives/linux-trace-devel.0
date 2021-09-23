Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C4BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD05860F4C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238656AbhIWAMI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbhIWAMF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 20:12:05 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D24C061756
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:35 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id ay30-20020a05620a179e00b00433294fbf97so14885805qkb.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1rELxei1Th/UNLZ4fkAjYBbAjk1Yskkc5Wgg+H/lMdA=;
        b=aj4ITEB5JceytWBHfNcVZcASLLTMUoHYYe1f328a7S6X2W14GhzWC+8Mra/X1zSFRa
         MG1KY3dnyQaUOROahD5evtsUwd93Q9oyYa7LxIgVCI0v3BcL2Ha1n9w9ITYAkgxRLBb6
         uR5I5IBH1aWELGFZJuqZDwHXEzm4ELAmcdTca5mj2vTOFa/U1KEVAL7YgHckmJECMW1t
         7joH10yxt5VFm9/If55eNRR9OLShFbUYZsHeWFrO6VD/8MRYNrmS/Ris1LvTRZplZMpj
         mJHdLZWBGrx9PysOlu0H3JJzEW1VXEZbtQW+7ZydG/QwFX6TBRL2GLW4T0hInJYjb6h3
         tgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1rELxei1Th/UNLZ4fkAjYBbAjk1Yskkc5Wgg+H/lMdA=;
        b=yHK59p8BsT8iY1HgiCVnk6c3pcAYwglCKCrZvb5d1xZ6FYk/9wOCAefcG1+riTXGNI
         HgOV3NTqhbqjz9Xntwv8KID2FKwb1Kq7erkiIo22MSx83FDnM34GMkpjhNPMR1Po8ICl
         3QwAl8hKm2TbsJCNbtpJVs363cTRTdqpKdycw9a9xwwlN8hYc6WtPuzZnm6PVsn5Rx1T
         +nJkZ8hGA42UVqo76lrYJDbqQ+4aVAI1/54tn0nhdSvlNlUqbwBsxZh8yPQij3UPhqI0
         fEnhptoeoXrw3m2SsG1d14Y+6PITUJ0G5O6PYTxFJ95YTX2c4mI6McKcfiPUOtEJYPX0
         Ambw==
X-Gm-Message-State: AOAM530qdYJlbelzWn0eecVwrq1ViQIoafnUlmNPQBvTsljUCgUcCpjW
        ZlnhWcJyDH/1m57zqcZIUjZaIgvgYz5W
X-Google-Smtp-Source: ABdhPJzjm/4Mi5fc7Pf8x7huJqqqC5yilO3pfA3yu3xyN3RxlPlH2FRCHiesTjDAl2F3JrJhR3PfOJ7Jw7/l
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:d3ff:e8f7:11f4:c738])
 (user=irogers job=sendgmr) by 2002:a25:ae97:: with SMTP id
 b23mr2412310ybj.50.1632355834372; Wed, 22 Sep 2021 17:10:34 -0700 (PDT)
Date:   Wed, 22 Sep 2021 17:10:22 -0700
In-Reply-To: <20210923001024.550263-1-irogers@google.com>
Message-Id: <20210923001024.550263-2-irogers@google.com>
Mime-Version: 1.0
References: <20210923001024.550263-1-irogers@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 2/4] perf: Add define for libtraceevent version
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     eranian@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definition is derived from pkg-config as discussed in:
https://lore.kernel.org/lkml/20210610155915.20a252d3@oasis.local.home/
The definition is computed using expr rather than passed to be computed
in C code, this avoids complications with quote  in the variable
expansions. For example see the target python/perf.so in Makefile.perf.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Makefile.config | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 00ec900ddbca..2001c315f0db 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1093,6 +1093,12 @@ ifdef LIBTRACEEVENT_DYNAMIC
   $(call feature_check,libtraceevent)
   ifeq ($(feature-libtraceevent), 1)
     EXTLIBS += -ltraceevent
+    LIBTRACEEVENT_VERSION := $(shell $(PKG_CONFIG) --modversion libtraceevent)
+    LIBTRACEEVENT_VERSION_1 := $(word 1, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
+    LIBTRACEEVENT_VERSION_2 := $(word 2, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
+    LIBTRACEEVENT_VERSION_3 := $(word 3, $(subst ., ,$(LIBTRACEEVENT_VERSION)))
+    LIBTRACEEVENT_VERSION_CPP := $(shell expr $(LIBTRACEEVENT_VERSION_1) \* 255 \* 255 + $(LIBTRACEEVENT_VERSION_2) \* 255 + $(LIBTRACEEVENT_VERSION_3))
+    CFLAGS += -DLIBTRACEEVENT_VERSION=$(LIBTRACEEVENT_VERSION_CPP)
   else
     dummy := $(error Error: No libtraceevent devel library found, please install libtraceevent-devel);
   endif
-- 
2.33.0.464.g1972c5931b-goog

