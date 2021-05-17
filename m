Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B256C43460
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C36561185
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 13:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhEQNla (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237414AbhEQNl3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 09:41:29 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6355EC061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:13 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id l4so9252870ejc.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 06:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z0LcYKshq465WgeE8dPD2Nn0zo3Dp6s7Ui2Y7fj6Jpk=;
        b=pJ9Mm0ilHuYkVp2HG4hI+D4+m2E4vfzKd9YjC/rJMhGJzqLlIe8hy4eG3lD8cgTqJz
         w8zHmhmc1mKrZXK+Xy43SQl3s23ozgcPti6i0BO6SdIvZDCI9X31ZObFvP+HrwKkBTt7
         +GOyjS2iI8njOU2FsP1i8wFnz8nPDIeOQMe+cqN5XaY7szJdOC/ep9qU5VG00jUG+iQw
         jBUb8I9RxEvxLcMnLFB+Z7oRQqlJoHYqsB0YvpQ6bCvC5yXlSB03ymhLmqZhvj/knc+p
         lD4jqjKqSH7PCS1M7B5m0LD75sR56uw4IDjK2WlcHKHYLBO5V2YY/sDR8HRzIsJE8S2E
         YYmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z0LcYKshq465WgeE8dPD2Nn0zo3Dp6s7Ui2Y7fj6Jpk=;
        b=Pe8SiBhQlOCBD/TGG/xlUcdYNO1OantPNnYXUln2BHSA+nJ4jdjjUZY+ejyBWc10Sc
         I3aiQ9vpdRWIKQd+kG4yffXylSOenEt48X8KJDEmh+RErIu3tY+eJJ1px3ImCCvjdmoR
         1MuCSfSH2NyRhSp5vJGZfgCZQyAc5U+yuwTCjwzf+Sx8DM55oVp4wlPgB3/BlXYXhRJi
         +SPOLqSGg3DB9aVVDjGi7xj+3kSp6X1ESmQmfdmrHR/hhFt5OoZDXQSTCpdFeDRegiSr
         P5zIE8AohTEIGACVPSL8gODqpHD3k80tJSrYszb0FLclKpFcChgjpGFevV6XiLIv5+AQ
         Ie7g==
X-Gm-Message-State: AOAM5329LaCy9m4WV+SO5ucekak58q/wxdKbsCva1TULvqJbKbsNcqzn
        l3tUapdbXmwa9wMtJTseW8Uf8ZBuJU5b1g==
X-Google-Smtp-Source: ABdhPJwcZgjHntXS50zrcB4KOWuM0UHf4XzeOCbuFFeapr4guDXHQu+QX1gqw25ZHngcbyuXzLWGCg==
X-Received: by 2002:a17:906:3e52:: with SMTP id t18mr4119923eji.521.1621258812149;
        Mon, 17 May 2021 06:40:12 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id r25sm10961799edv.78.2021.05.17.06.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 06:40:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 5/6] trace-cmd report: Set the log level with -V and -q options
Date:   Mon, 17 May 2021 16:40:04 +0300
Message-Id: <20210517134005.611251-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517134005.611251-1-tz.stoyanov@gmail.com>
References: <20210517134005.611251-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When "trace-cmd report -V" is specified, set the log level to INFO.
When "trace-cmd report -q" is specified, set the log level to NONE.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index b315283e..0cf6e773 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1703,9 +1703,11 @@ void trace_report (int argc, char **argv)
 			break;
 		case 'V':
 			show_status = 1;
+			tracecmd_set_loglevel(TEP_LOG_INFO);
 			break;
 		case 'q':
 			silence_warnings = 1;
+			tracecmd_set_loglevel(TEP_LOG_NONE);
 			break;
 		case OPT_cpu:
 			parse_cpulist(optarg);
-- 
2.31.1

