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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0C7C433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F04161156
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbhIUUu0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235121AbhIUUuZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 16:50:25 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF8DC061757
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:56 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id w2-20020a3794020000b02903b54f40b442so4341770qkd.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0fQ8TCUq2nIKYsU5pQLtTTkuNxp/JAtlPHlUXR9S+Vg=;
        b=M8rUSoyqhCE2pVWw+XCFo9eKV4+oKAaS77hyjuGwvD6X6Hm2OwL6HvrL6ERj+CKLSs
         LSNAUJUgR27wTDCNyU5/vDnSeMfa0nqXs5RItXkwcGn+V8RRcFl30F1aGJXXQWE7PCR5
         4tIHLWzubEHJ5D1cmOTmebr+F9bvxls+Sim2gCdFGsOYqfKIi3zbLKvQ6hxEAkMU1K4r
         3Z22Nkdp2XloJZKFsPIjYZr7xCdFo/m1UVe6DcMZDrwJIsiqbsMGBXPi5IhfHn1BxGBO
         nbBzpjdz18jsU+HSSvYYHRFuEL+O6y/tqsL4dCHi9hhu6+YR6m6vu0l5vG5Y1ScQY/US
         6eRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0fQ8TCUq2nIKYsU5pQLtTTkuNxp/JAtlPHlUXR9S+Vg=;
        b=f0DI1ccVeWf3VPH1+Y2FtsXOccxpd6p4e8SuDahQaj5ElWv6iyyDYQ85HL9Zstn+le
         +ZSc4OGSxVCDx+nkF9QOVBH4OOhb4EG3uH86rrJRd/54/NrQUGIMZZY1CY98whUW+zMb
         BYEh8kjXCY+VWcA0qZLxwSjPXgHcBopLjL5roTVY1pI8vYtqWrhn9f0kcy4OwTf3OlCX
         P6mgioOit+8BbK6VteHQR76hSD4voifv7o8A4qOM8R2LjGQzy3amD60wOEx6+L1grJxT
         K4kP15wZnNJePkYVddq9QVQ9EHEwvSYgQTN4KU90sd4koTHordwDxcH5jefMgykz1lmO
         FXQw==
X-Gm-Message-State: AOAM532XQFZ0gFbNhJgHzNXG8fimjYeRTK8Jrwzgk9QSvDi/84L8fagM
        KompQEFbRqTKEkcUg1PQH9SlmWm+30Fy
X-Google-Smtp-Source: ABdhPJz+hk6+WNO8Dibbg6BJwFS1NpCW9OBNqbDVONr+XMUqVUf0sWNtnDo8Z6fJaiV9wdVLa0MEDShjVnSh
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:dffa:819a:f0e2:47e])
 (user=irogers job=sendgmr) by 2002:a05:6902:1107:: with SMTP id
 o7mr40185706ybu.454.1632257335328; Tue, 21 Sep 2021 13:48:55 -0700 (PDT)
Date:   Tue, 21 Sep 2021 13:48:38 -0700
In-Reply-To: <20210921204839.236840-1-irogers@google.com>
Message-Id: <20210921204839.236840-3-irogers@google.com>
Mime-Version: 1.0
References: <20210921204839.236840-1-irogers@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 3/4] perf: Add define for libtracefs version
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

This will allow version specific support of libtracefs.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/Makefile.config | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 2001c315f0db..0ae2e3d8b832 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1108,6 +1108,12 @@ ifdef LIBTRACEFS_DYNAMIC
   $(call feature_check,libtracefs)
   ifeq ($(feature-libtracefs), 1)
     EXTLIBS += -ltracefs
+    LIBTRACEFS_VERSION := $(shell $(PKG_CONFIG) --modversion libtracefs)
+    LIBTRACEFS_VERSION_1 := $(word 1, $(subst ., ,$(LIBTRACEFS_VERSION)))
+    LIBTRACEFS_VERSION_2 := $(word 2, $(subst ., ,$(LIBTRACEFS_VERSION)))
+    LIBTRACEFS_VERSION_3 := $(word 3, $(subst ., ,$(LIBTRACEFS_VERSION)))
+    LIBTRACEFS_VERSION_CPP := $(shell expr $(LIBTRACEFS_VERSION_1) \* 255 \* 255 + $(LIBTRACEFS_VERSION_2) \* 255 + $(LIBTRACEFS_VERSION_3))
+    CFLAGS += -DLIBTRACEFS_VERSION=$(LIBTRACEFS_VERSION_CPP)
   else
     dummy := $(error Error: No libtracefs devel library found, please install libtracefs-dev);
   endif
-- 
2.33.0.464.g1972c5931b-goog

