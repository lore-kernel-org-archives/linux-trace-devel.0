Return-Path: <SRS0=2Wju=QB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEDF4C282C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jan 2019 10:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88FCF2184B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jan 2019 10:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfAYKUS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:20:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38562 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfAYKUS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jan 2019 05:20:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id m22so6111382wml.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jan 2019 02:20:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bPqgRIR9zwxD8LE686+o1sb720TnmGsFgPa3W1a/+4M=;
        b=DVneJzSO4+tWFwg0URT7ps7CFT+ZJPo57if+wMiovZoZBMs+KIhOwh8tzQInGHtSIw
         fz+2DtG1Ul3NyslcER/gZ5AXkehrfmCwvvKT8NxP3vHdVK5SwC8h7LiX1VkN4+7xhjbR
         u4+cLLSZ3EQvCWpvyNnyBrw1u55ruCC6vRu25bczCXM+5m1j7K1ZYhgs3riYslDe+z+P
         8MHwSdU51f7qOZ3Mw1eeGup8W7714EJ6fGYLgITf67HRr8jnIy2XzPP+F1MV5Wd9kjzI
         e67DdECHfh/EVmpPCJM1tpUSogVF8aMkW+zOppWtwyDBEK9YoQOTr28pjcfNzn8pP8Rb
         tG9Q==
X-Gm-Message-State: AJcUukf1Zp80LTcst3jRmS4JyergZerh/1Tbm0Xr0lex6PEBxjDUJnf5
        S3C9IRxkTlFiBwKN8GnKzkGs8f2A
X-Google-Smtp-Source: ALg8bN58NvPr77DHQwK95UZHuRKxptY0si0CQUu6Rm2j/d/6LQd0YHGlOm+hOnysMpUD5hOdZ0vzag==
X-Received: by 2002:a1c:d7d3:: with SMTP id o202mr6725444wmg.135.1548411615924;
        Fri, 25 Jan 2019 02:20:15 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h131sm88205964wmd.17.2019.01.25.02.20.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 02:20:15 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mikesart@fastmail.com
Subject: [PATCH] tools/lib/traceevent: fix a buffer overrun
Date:   Fri, 25 Jan 2019 12:20:14 +0200
Message-Id: <20190125102014.19600-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Fix a buffer overrun in arg_eval() function in
traceevent library. The min value of long long
is -9223372036854775808, it needs at least
21 bytes to be printed as a string.

Reported-by: Michael Sartain <mikesart@fastmail.com>
Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f6c926467fa3..ff065796ace3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2472,7 +2472,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 static char *arg_eval (struct tep_print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[21];
 
 	switch (arg->type) {
 	case TEP_PRINT_ATOM:
@@ -2482,7 +2482,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 	case TEP_PRINT_OP:
 		if (!arg_num_eval(arg, &val))
 			break;
-		sprintf(buf, "%lld", val);
+		snprintf(buf, 21, "%lld", val);
 		return buf;
 
 	case TEP_PRINT_NULL:
-- 
2.20.1

