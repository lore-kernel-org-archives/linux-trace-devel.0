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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55919C4360C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2595864E27
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Mar 2021 06:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCOGTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbhCOGSt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 02:18:49 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78ED3C061574
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e7so15888191edu.10
        for <linux-trace-devel@vger.kernel.org>; Sun, 14 Mar 2021 23:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iJwVXhushZOIYhjD0e/V5i9CQUcf9y1pG40t0rxZTQY=;
        b=cgHvWqMbqb7WPmXB6CT37+8bY08TKjJ7qk0pRlQ/IPPvQfIDITV/Ha02H1YQH4xTPC
         9EyWknhTiwW9bFW2vjNJ/byYAf/BrgdczSq+Pvxcs2gNKPz8SYLH5gBY7lDkPW39QroL
         HZI7QBCxWF6Vl5AxqfWeBMf4GeoCDotAhliQKzL4CG5XdXJHPZr6d5eSckz10HeM0vNb
         ZzPxXtL+mEtsRfLAiUnvEl7j+nwvovLhxieDxHnOQYONF9KhC8TL0RZzDs8ajziVLZZM
         TIN7JhB5Qpq6HiFHbSa32/gAebf81LLPgtKH8Z11zQZfsCrj7JBa9DjHVnAtsaUlhK1O
         GEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iJwVXhushZOIYhjD0e/V5i9CQUcf9y1pG40t0rxZTQY=;
        b=sJ8+d1waSHfHOYi4ou+3s/7HQPbUJX93ygO+F++HJtD7LxtHOobStAMUNO5mwuQY0X
         bmb4bse9GwHvhIXnFZ+UjBrv8h3L/1ak/0zHjczhQgZzsLKTyQYghTVDaiuzMH0bOzVs
         B/M9Xtam5ChP467SCi8asQIviiA9Uw1QfB3+8+AUoGKI+InghO6IYQVmnxcxCIF54jp+
         EVT4NDw+2KFQu5w86BFQAQ3R+CBjrmHiuMRCMZZUn5HUDaGDKjO0kwc6FJuorvBR7L4l
         vDy6wWxEfsMN8FkAqyTS6HFYHsLzARRJ17V1XMl+3tAGu2tO3XCXX7b51PAFckjcNXEF
         RIaQ==
X-Gm-Message-State: AOAM533N3HX0gmikv4vcSrbFm+8H3Bap3qiH0IaViBK9nvklsO2L2Hwi
        9DnihlkQCvsxBoRbEVO97Y4WBWVFm3yNVw==
X-Google-Smtp-Source: ABdhPJw7srT0EOjhdk/RdtuB24/Q70R03wiGibwrzzaprWGiC8gCTRz2GDbdjMWcIR+ImnC6IMoflw==
X-Received: by 2002:aa7:c456:: with SMTP id n22mr27728167edr.277.1615789128294;
        Sun, 14 Mar 2021 23:18:48 -0700 (PDT)
Received: from localhost.localdomain ([130.185.229.134])
        by smtp.gmail.com with ESMTPSA id t6sm7468478edq.48.2021.03.14.23.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 23:18:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 12/12] trace-cmd: Add new parameter "--raw-ts" to "trace-cmd report" command
Date:   Mon, 15 Mar 2021 08:18:32 +0200
Message-Id: <20210315061832.168495-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210315061832.168495-1-tz.stoyanov@gmail.com>
References: <20210315061832.168495-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"trace-cmd report --raw-ts" disables all corrections of event timestamps
from the trace file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 22e8635c..1b99db1d 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1484,6 +1484,7 @@ static void add_hook(const char *arg)
 }
 
 enum {
+	OPT_raw_ts	= 236,
 	OPT_version	= 237,
 	OPT_tscheck	= 238,
 	OPT_tsdiff	= 239,
@@ -1533,6 +1534,7 @@ void trace_report (int argc, char **argv)
 	int print_events = 0;
 	int nanosec = 0;
 	int no_date = 0;
+	int raw_ts = 0;
 	int global = 0;
 	int neg = 0;
 	int ret = 0;
@@ -1574,6 +1576,7 @@ void trace_report (int argc, char **argv)
 			{"ts2secs", required_argument, NULL, OPT_ts2secs},
 			{"ts-diff", no_argument, NULL, OPT_tsdiff},
 			{"ts-check", no_argument, NULL, OPT_tscheck},
+			{"raw-ts", no_argument, NULL, OPT_raw_ts},
 			{"help", no_argument, NULL, '?'},
 			{NULL, 0, NULL, 0}
 		};
@@ -1746,6 +1749,9 @@ void trace_report (int argc, char **argv)
 		case OPT_tscheck:
 			tscheck = 1;
 			break;
+		case OPT_raw_ts:
+			raw_ts = 1;
+			break;
 		default:
 			usage(argv);
 		}
@@ -1777,7 +1783,8 @@ void trace_report (int argc, char **argv)
 
 		if (no_date)
 			tracecmd_set_flag(handle, TRACECMD_FL_IGNORE_DATE);
-
+		if (raw_ts)
+			tracecmd_set_flag(handle, TRACECMD_FL_RAW_TS);
 		page_size = tracecmd_page_size(handle);
 
 		if (show_page_size) {
-- 
2.29.2

