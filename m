Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E48AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5741B61156
	for <linux-trace-devel@archiver.kernel.org>; Tue, 21 Sep 2021 20:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhIUUuX (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 21 Sep 2021 16:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbhIUUuW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 21 Sep 2021 16:50:22 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE060C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:53 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id e6-20020a0cb446000000b0037eeb9851dfso4898354qvf.17
        for <linux-trace-devel@vger.kernel.org>; Tue, 21 Sep 2021 13:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1rELxei1Th/UNLZ4fkAjYBbAjk1Yskkc5Wgg+H/lMdA=;
        b=GnkocixvmprRCEOB9amal+qdaykKMMJQVDyDyGGWvWI+dLE+fzvpyTpgX7ASVzVryX
         1OuK3P8+KXJ6Hx4eyh0NMm8v9PsGuMX3KWkVhJInNzSrceUFEp6tLIrxb0qiiDHvFViX
         Y+sYLtXLIJ3Xsy9JU1k52hA6C25FOawWHb0JzphBgm4Xk3tgYEpCVsX/YvhpnM8CIDjQ
         bOdTFGvqV3x1IHYS85kqIQG6W6T/a7of9M2HDoa7NSaZDQvFRC/kphsYksY2uculVhB3
         gigbMIBwwUfzDcd1NapB7iHL0AYQa4wusx4NqKE7foCQnPWxz4Mwd0Ti03IvAqlKJvEu
         /bsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1rELxei1Th/UNLZ4fkAjYBbAjk1Yskkc5Wgg+H/lMdA=;
        b=B7Sssp4/mG120Fwwpw/aPu1zr7/x+FCGnZExrtUI0+RyapJKmhV0r9lBYmmVXoqm4G
         fHvYMif5rQEyLVWFWz+tNSzwoHMRq5TANJOnSxqW2crOAgwm3W77YtvEykpVfXJAoS9s
         tjvvasKOat953fV2xcTLsYkaK9Ebtps/R87sOVx97DCJQDmAxqfL1zbLUXL5RUs8ZhR5
         11AtaVQI4z/El2eZLvPfX1+MMf52m/qrYJMQ2fko0JP5SI+FHCP3uakkLqppQ4Te+Tef
         Qgfwa5K1kTilRXmGMyAbcRB7f4y/l7sByDAraytmSb0pByDoP1KScbxgvTp7QKeFiISB
         z6OA==
X-Gm-Message-State: AOAM533jQ5q/f9oe04fcNFAOBjHidaKHaC1AgfKYtVT2bW0r4n6E6MEE
        TJEsZ5hU+f7bgsAWEbFIrXl48ccA365F
X-Google-Smtp-Source: ABdhPJxuEgFTXuFUCiRjLUb+WWg7xJJwRQJxL602S3UXwkh9eZag0QeZpZoAVYIEoyjtP6ua+lXtHohXYh6x
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:dffa:819a:f0e2:47e])
 (user=irogers job=sendgmr) by 2002:a05:6214:1505:: with SMTP id
 e5mr10470735qvy.13.1632257332982; Tue, 21 Sep 2021 13:48:52 -0700 (PDT)
Date:   Tue, 21 Sep 2021 13:48:37 -0700
In-Reply-To: <20210921204839.236840-1-irogers@google.com>
Message-Id: <20210921204839.236840-2-irogers@google.com>
Mime-Version: 1.0
References: <20210921204839.236840-1-irogers@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v2 2/4] perf: Add define for libtraceevent version
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

