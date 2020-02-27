Return-Path: <SRS0=GfdA=4P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B40BC5ED41
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C3C20801
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Feb 2020 14:20:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKM0ijk7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389821AbgB0OUV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Feb 2020 09:20:21 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33630 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389728AbgB0OUU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so2233487lfl.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 27 Feb 2020 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AvccRY29WAE6SEpT6cihqrMVaq3y+rDhD0g13g/YdTY=;
        b=UKM0ijk76+AZNLXNqVyMXXsGhQByNSNUl1i95OJgBbEh8bC3A7djyZD1VV+CzcHjXW
         tXhaE6cf3RMnyR1x7iGHVKGRacz8sMmr65HieJMpKTLm/9/KsyW35+f8XQ5xxfWnAyF3
         MmaG8LBPOYryfjYayUQRcZXGjKdCnuxGCj/xl9395JgFVlxG2Znf0TNyg7TQ4SE6heq8
         xAso1DOrml6/Jz4tM37GmrqKj8cwXMIsorqkn/kceFm4w0AA9VPC12lETnXkj76gBU8A
         tfVq7o6+WUO4AP+l30L4GdoyC6tGVhn/uc4Q5R/su1IxUTnqJFZvEjI4bp48J+m6PDSw
         ALhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AvccRY29WAE6SEpT6cihqrMVaq3y+rDhD0g13g/YdTY=;
        b=iXy6Cur/tr7kNI1sBTXBjL8NwM+SNRt+i9Ji0XSwCcG13Kf0pDbcGI2+7ZmentmPDC
         ADRR5Ndd3+djeyRMjqtjV/Hp7k08JpUuROPPWErEyZvUeocrH6hxzqG6b2bBN4M+AQQk
         uJCzSn9Gxa9SeLMvcCsld9KklVUwFf9cTX9+CGjSheK27Y2HAi0n7uao2Kl0EFEaGr2p
         0nV7e3htHLzyWcZNPHRAzn4xORqrY0P4PX4arma4AzuVhbX2CCGqHowj8BR7z/qmxQPQ
         HBrj3yAvnPitLlzR2CPHox26e8XKoebceMLCxMVHTHMXTFy43u6rDYLIBE5hiDpMTrwz
         k9IA==
X-Gm-Message-State: ANhLgQ3q2a9r311mYwn0A16DG9fW5Z+JsVMbSyVwziGGmUSKvXfuJpWv
        8STyU6l79t4cCORUohvwsAU=
X-Google-Smtp-Source: ADFU+vvFh0SIcZXfq1Gcn3jCrwj+HncSlXSR/whWVqZIY452NMMLwoczsxfbT/09tZf4Rl1ckrexog==
X-Received: by 2002:a19:8585:: with SMTP id h127mr2290681lfd.196.1582813218830;
        Thu, 27 Feb 2020 06:20:18 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l3sm3306437lja.78.2020.02.27.06.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 06:20:18 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v20 11/15] trace-cmd: Add host trace clock as guest trace argument
Date:   Thu, 27 Feb 2020 16:19:57 +0200
Message-Id: <20200227142001.61577-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200227142001.61577-1-tz.stoyanov@gmail.com>
References: <20200227142001.61577-1-tz.stoyanov@gmail.com>
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
 tracecmd/include/trace-local.h |  1 +
 tracecmd/trace-record.c        | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 4f2b5541..dc934f28 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -167,6 +167,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_PROFILE	= 1 << 1,
 	BUFFER_FL_GUEST		= 1 << 2,
 	BUFFER_FL_AGENT		= 1 << 3,
+	BUFFER_FL_HAS_CLOCK	= 1 << 4,
 };
 
 struct func_list {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 5f799908..ee27cf0f 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5555,6 +5555,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_sync_set = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5598,6 +5600,8 @@ static void parse_record_options(int argc,
 		 */
 		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
+			if (c == 'C')
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			continue;
 		}
 
@@ -5712,6 +5716,9 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
+			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+			if (is_top_instance(ctx->instance))
+				guest_sync_set = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5936,6 +5943,20 @@ static void parse_record_options(int argc,
 				add_argv(instance, "--date", true);
 		}
 	}
+	if (guest_sync_set) {
+	/* If -C is specified, prepend clock to all guest VM flags */
+		for_all_instances(instance) {
+			if (top_instance.clock) {
+				if (is_guest(instance) &&
+				    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
+					add_argv(instance,
+						 (char *)top_instance.clock,
+						 true);
+					add_argv(instance, "-C", true);
+				}
+			}
+		}
+	}
 
 	if (!ctx->filtered && ctx->instance->filter_mod)
 		add_func(&ctx->instance->filter_funcs,
-- 
2.24.1

