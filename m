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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 004E3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CC161214
	for <linux-trace-devel@archiver.kernel.org>; Thu, 23 Sep 2021 00:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbhIWAML (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 20:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbhIWAMK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 20:12:10 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13EEC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:39 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id r18-20020a056214069200b0037a291a6081so15228342qvz.18
        for <linux-trace-devel@vger.kernel.org>; Wed, 22 Sep 2021 17:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YRlcwai5LvG85hd6NJ2+esADNJKAvO1QJ6LOzStIvoc=;
        b=p252v6Wfpx8DGvA+HzHHCPRF+lJWWWCmAe1/SZMy6BXvM1IyvVvqGdtufi1WHFibmo
         WqaxM9Og4Do+U5Vw8hiDpFc9CapNZJgkJrJvrAM6vsXxiDRM/7Hn6XtdvLEPuxY9cnaA
         xbSjJ0fKtcFH76RCl1iU7SoisYq24wfzicjqEg7Dx1ormNIXgGy7bjX1in8wNSmIlyNv
         Mz/ypvRleSOiOaPo2pMA3/DojrbK7YUoD1oV/j92cHxR4Si+Jhhg+cRXftOiv7YuV1Zh
         AREFbGTzRoG6cBLCQmv6zr5jQnk6fY5nqnf2thY0vAP7ICv+Cbw1v70719X4L5CrWPt4
         0dHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YRlcwai5LvG85hd6NJ2+esADNJKAvO1QJ6LOzStIvoc=;
        b=MMIw6KHeK5XrWWlNperjcHj/PoTWiGmJOc8GSTDX32O930OSIztVb9epeXctJdLNRK
         cknN8dG+et2SJNlrcDnFsv2f9bzeWrJfJtXcHRt7PkImRSgfYEqHpRxFGPwj/pu6WZXf
         y96PZPF5d/qVfSUfDVwWN2dhaLPbhBpUAWDdnbcnVN8D5sxX2wzNJjppWg5PVIjH/R1T
         YXT7i19ZUMEra9gp2drO75mjZOYvh2cvTIfKkJqa6CARurLA0FbmPkEog80R1NaLsqyn
         P3ukGqmpPjxd4y3v4WhDQY0ZuTInmsN1dT7wwv0F8gel51GknXfgOAmqxdlIXRfwbXSS
         przA==
X-Gm-Message-State: AOAM530Si2JX2k27kSGkrlxwwoRpNEoAkqFR1aaLVvDVCCwFzcZbHJb1
        YXHXa6xmARufLm0TRbfolwNNquD9d/Ng
X-Google-Smtp-Source: ABdhPJzb1ZGvPQkb6oTpQF8xtPVzUnFzvsxJMqG6jaDXT7A0xrZH7l9cDotjiUgPDMC4euU8V1MJJf2g8Wn5
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:d3ff:e8f7:11f4:c738])
 (user=irogers job=sendgmr) by 2002:a25:adc6:: with SMTP id
 d6mr2226777ybe.463.1632355839083; Wed, 22 Sep 2021 17:10:39 -0700 (PDT)
Date:   Wed, 22 Sep 2021 17:10:24 -0700
In-Reply-To: <20210923001024.550263-1-irogers@google.com>
Message-Id: <20210923001024.550263-4-irogers@google.com>
Mime-Version: 1.0
References: <20210923001024.550263-1-irogers@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 4/4] libtraceevent: Increase libtraceevent logging when verbose
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

libtraceevent has added more levels of debug printout and with changes
like:
https://lore.kernel.org/linux-trace-devel/20210507095022.1079364-3-tz.stoyanov@gmail.com
previously generated output like "registering plugin" is no longer
displayed. This change makes it so that if perf's verbose debug output
is enabled then the debug and info libtraceevent messages can be
displayed.
The code is conditionally enabled based on the libtraceevent version as
discussed in the RFC:
https://lore.kernel.org/lkml/20210610060643.595673-1-irogers@google.com/

v2. Is a rebase and handles the case of building without
    LIBTRACEEVENT_DYNAMIC.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/debug.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 2c06abf6dcd2..c7a9fa0ffae9 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -24,6 +24,16 @@
 #include "util/parse-sublevel-options.h"
 
 #include <linux/ctype.h>
+#include <traceevent/event-parse.h>
+
+#define MAKE_LIBTRACEEVENT_VERSION(a, b, c) ((a)*255*255+(b)*255+(c))
+#ifndef LIBTRACEEVENT_VERSION
+/*
+ * If LIBTRACEEVENT_VERSION wasn't computed then set to version 1.1.0 that ships
+ * with the Linux kernel tools.
+ */
+#define LIBTRACEEVENT_VERSION MAKE_LIBTRACEEVENT_VERSION(1, 1, 0)
+#endif
 
 int verbose;
 int debug_peo_args;
@@ -228,6 +238,15 @@ int perf_debug_option(const char *str)
 	/* Allow only verbose value in range (0, 10), otherwise set 0. */
 	verbose = (verbose < 0) || (verbose > 10) ? 0 : verbose;
 
+#if MAKE_LIBTRACEEVENT_VERSION(1, 3, 0) <= LIBTRACEEVENT_VERSION
+	if (verbose == 1)
+		tep_set_loglevel(TEP_LOG_INFO);
+	else if (verbose == 2)
+		tep_set_loglevel(TEP_LOG_DEBUG);
+	else if (verbose >= 3)
+		tep_set_loglevel(TEP_LOG_ALL);
+#endif
+
 	return 0;
 }
 
-- 
2.33.0.464.g1972c5931b-goog

