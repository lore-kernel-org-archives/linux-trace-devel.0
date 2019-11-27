Return-Path: <SRS0=q7JI=ZT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C44DDC432C3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFA92075C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 27 Nov 2019 14:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bxgndUow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfK0ODJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:03:09 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40261 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfK0ODJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 09:03:09 -0500
Received: by mail-lj1-f194.google.com with SMTP id s22so5596628ljs.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 27 Nov 2019 06:03:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHtuBCIR6rovpENMXqQ38oTXPRpvn9y0woRZuvJrdOg=;
        b=bxgndUowyF5FC0l6RbQjNNnH0yutlEOs37PsokB51QpZViKzYipSZ1JrdrBQxy7YYJ
         3nIgT929r5DveUH7C24GGaR3VFQafRWCzXvNy+G2L+U2K5HK2qHgh7zLW10xXxvZvQqu
         yAZTg08kaWJMmcashNkXYUNhpuZEGVhIjJZsi8zG9U+40M2L8jZaB66hlQ5Qy/Q7tkYI
         AwH8VubKjBnCLNyTfw2d4uAhlpAMdjlHVMF5X7t/w14jdmdqB3S5txiCkxo6s2T9AAzC
         JzYyV49DK5jjJzLA7lx2pCpIA/BayHXkF4ccBPFS44+HzywrGHZ9DF5+d2cEeqYY+0xf
         gqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHtuBCIR6rovpENMXqQ38oTXPRpvn9y0woRZuvJrdOg=;
        b=U46ZmChxiVHQhZqCGpT6ZNqQHoRHuBLk2SHVwiPoHxg3uIQdrOUIiscqjRDA99Y6ec
         jOozJ9TWXR7THmjI36dtjgwkc3syonO+zQ5bZkUM1re2dSKiXvUKyxRVU1D5T3FH8Lly
         vzxP8o0UUFryrru2S+7ZIg2woOS1pg18wYGHwJB/WiFzzkwzmJnS5/L+e733Iz/p3gfX
         YQK0b2Rx90aUY5rtn2iL4j08NkHjag3AUTqdnbQEtxK2YjzcA8ETBdK8WtHowm0G5BSo
         rJ6DHozt+CLkOdTgV+HURZqlMkKWQl9b100nYZbrRf6bAnd6tuEdR9S64ilGB8CR3Gqn
         doog==
X-Gm-Message-State: APjAAAXz3F99qlyAy3NJOURlJaplJDgZOTN+rW5Ed+aFoUEFMWQ2Laui
        ld/LCfy/XPOIO4Mv+Y7zuY4YOzFHD5Y=
X-Google-Smtp-Source: APXvYqwz+fEQIw8HAZqD14q/koQpbAPPcPHouU0w0lexhUwnlhT2XQ8n7N4jAe+KaWYcNotEVPMOTg==
X-Received: by 2002:a2e:2a43:: with SMTP id q64mr31693903ljq.242.1574863387182;
        Wed, 27 Nov 2019 06:03:07 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id y18sm7268660lja.12.2019.11.27.06.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 06:03:06 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v14 15/19] trace-cmd: Add host trace clock as guest trace argument
Date:   Wed, 27 Nov 2019 16:02:43 +0200
Message-Id: <20191127140247.258766-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191127140247.258766-1-tz.stoyanov@gmail.com>
References: <20191127140247.258766-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When tracing host and guest machines, both should use the same
tracing clock for event timestamps. If a clock is specified
as host tracing argument, with option "-C clock_name", the same
is injected as guest tracing argument. If the user wants to use
different tracing clocks, it can specify it using "-C clock_name"
as guest tracing argument. In that case, the one specified by
the user has higher priority.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1d9ba3c..4f18283 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5406,6 +5406,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_config = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5563,6 +5565,7 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->ftrace->clock = optarg;
+			guest_config = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5780,14 +5783,26 @@ static void parse_record_options(int argc,
 
 	/* If --date is specified, prepend it to all guest VM flags */
 	if (ctx->date) {
-		struct buffer_instance *instance;
-
 		for_all_instances(instance) {
 			if (is_guest(instance))
 				add_argv(instance, "--date", true);
 		}
 	}
 
+	if (guest_config) {
+		/* If -C is specified, prepend clock to all guest VM flags */
+		for_all_instances(instance) {
+			if (top_instance.ftrace->clock) {
+				if (is_guest(instance)) {
+					add_argv(instance,
+						 (char *)top_instance.ftrace->clock,
+						 true);
+					add_argv(instance, "-C", true);
+				}
+			}
+		}
+	}
+
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
 			 ctx->instance->filter_mod, "*");
-- 
2.23.0

