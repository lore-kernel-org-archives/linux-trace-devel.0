Return-Path: <SRS0=2Wju=QB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E578C282C0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jan 2019 10:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3014C2184B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Jan 2019 10:20:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfAYKUr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:20:47 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34943 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbfAYKUq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Jan 2019 05:20:46 -0500
Received: by mail-wm1-f65.google.com with SMTP id t200so6145212wmt.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 25 Jan 2019 02:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P3TYZe/rP0Bzr02dXKWdKVe4tHXwjbHHxrTsyAZg/YY=;
        b=o6uNkhxyrGlLzaA0IGQHZIrbny8doUQ2Kta2T3NQqFyNt8f72PCpon3dzv5cdZ1y59
         mtOqX3McZAVWiRg/8AT8bYXTB4JPOtImW46Y2XwuXF87vJ+E2ORjzo1Bxh+uptrIWuW5
         uGPRcdGiB5hcpQu+YuJ4PrbsTyuU10TgSp9/tomVX9ECqyoXdWeJGgFz2+TMKBq46UEm
         4Xj1gt6s4/qbNeJLVnM33ThMChHLRZrI23ADaTPVGHGM5AlKlYc8Tw484LRKYdKAK+z/
         U6wNKjzuNZ2JvYOMUnPhke5dq23t8lM7KeRmhOZWG6xamNk8s1869Eav4+IgeiCGD9aq
         j8bw==
X-Gm-Message-State: AJcUukc48VaXS7uqyjYI+gyfWD4+Yh04TK2N3n4xsG8FvsRi13Hlo1a/
        yMihodhJR2P4KGqpuicSepM=
X-Google-Smtp-Source: ALg8bN7NgX+ZWTsO+3UBgA8/N7jWCeoAlJxligo1bsgpV5vSwLCQUEl93maZQ/pJy+Wi93Hd4CTN/g==
X-Received: by 2002:a7b:c852:: with SMTP id c18mr6000061wml.49.1548411645052;
        Fri, 25 Jan 2019 02:20:45 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n6sm60462076wmk.9.2019.01.25.02.20.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jan 2019 02:20:44 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mikesart@fastmail.com
Subject: [PATCH] trace-cmd: Fix a buffer overrun
Date:   Fri, 25 Jan 2019 12:20:43 +0200
Message-Id: <20190125102043.19715-1-tstoyanov@vmware.com>
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
 lib/traceevent/event-parse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 6f7f4be..3f85b94 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -2457,7 +2457,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 static char *arg_eval (struct tep_print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[21];
 
 	switch (arg->type) {
 	case TEP_PRINT_ATOM:
@@ -2467,7 +2467,7 @@ static char *arg_eval (struct tep_print_arg *arg)
 	case TEP_PRINT_OP:
 		if (!arg_num_eval(arg, &val))
 			break;
-		sprintf(buf, "%lld", val);
+		snprintf(buf, 21, "%lld", val);
 		return buf;
 
 	case TEP_PRINT_NULL:
-- 
2.20.1

