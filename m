Return-Path: <SRS0=DRQG=3U=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5311DC35240
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F9D20705
	for <linux-trace-devel@archiver.kernel.org>; Fri, 31 Jan 2020 12:11:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AK0rbHkg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgAaMLe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 07:11:34 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46858 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728515AbgAaMLd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 07:11:33 -0500
Received: by mail-lj1-f196.google.com with SMTP id x14so6794851ljd.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 31 Jan 2020 04:11:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QMldXmnhWkw8npVV+VtNO/7UD7mPX9ZLJqfOBQ89TQI=;
        b=AK0rbHkgl7Q7jIb3rrtNzVVkcbEupzQRPjzNDKVH3LTPqTNql1Lxs8rc2/3ca/JNSp
         po+xU22K3sreqhnomVFaekpm98QsXpjjpjRTtNw36/mXN1bbKKrZyqZdu62xekuyA5TW
         +hrKhQN+HBFzFn/OvkuzBzhpcH8eB+IjMNYP5iLNWI6GtBnwo6/KZ/Kr+NMmm3qojiN8
         tDoLhCqowXOhdAGBQiUDC4OUwcgAuHXtE9GpCjtUq2WQGzPKRJ/du6t5oyvNuWcnaTKu
         xIBRFGsEKC3hlqExULLsIi7Q3fXsXcEakI2XUtCi7N1ZdtzZODKtvr4OO7seS1/2rq8W
         cXIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMldXmnhWkw8npVV+VtNO/7UD7mPX9ZLJqfOBQ89TQI=;
        b=fOtK+lFS283a9fy4Dal//fwJqq8Eliy4+d9dc3AEUU3808Z7swqmmv3d2FB3eSyVM0
         FSDvaGAiFS2MExIiO4xyCjz41TfiTNwmHfYWCZk29hIvMKyLnExSZVV1JMPv0R7dvELr
         NCJ1YRbM9QHyOlkKPxvkeIzP/B1OsbzXa2KLB2MpZrJiF2m2NrBB+YBB6juoCRxYckCA
         Cd79kzZkEk4EkHsj0SIJjmZCI8RPDd4Kh6tWWz/UoQVQV5IS/eQ2WKIQCj872bXOdBb0
         VsrzMp6I6hn7Iz0gUHGz5wQgy1NmZel3r7WG5GzcACJW0OvnTsgw3r2cdtfKW4Mwcw2J
         xXSQ==
X-Gm-Message-State: APjAAAWx5uT9gBDYSS2aFg1n2lxofNGJyzwldMJU85X9XuFfYPz1DWES
        xm8VPPvF9kQF3MRDJNwsZyT6ARgKdzs=
X-Google-Smtp-Source: APXvYqxqw43BM3c0GEM59dFTGf4x9j2aVEketxi8Mk/ZfH6OVIoFrx7Aswi4HeRW4vwD1tEnJl3bbA==
X-Received: by 2002:a2e:9dc3:: with SMTP id x3mr5896377ljj.257.1580472690686;
        Fri, 31 Jan 2020 04:11:30 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i19sm4559965lfj.17.2020.01.31.04.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 04:11:29 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v19 11/15] trace-cmd: Add host trace clock as guest trace argument
Date:   Fri, 31 Jan 2020 14:11:07 +0200
Message-Id: <20200131121111.130355-12-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200131121111.130355-1-tz.stoyanov@gmail.com>
References: <20200131121111.130355-1-tz.stoyanov@gmail.com>
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
index 4f2b554..dc934f2 100644
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
index 0c1e721..8884c0c 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5532,6 +5532,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_sync_set = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5575,6 +5577,8 @@ static void parse_record_options(int argc,
 		 */
 		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
+			if (c == 'C')
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			continue;
 		}
 
@@ -5689,6 +5693,9 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
+			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+			if (is_top_instance(ctx->instance))
+				guest_sync_set = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5913,6 +5920,20 @@ static void parse_record_options(int argc,
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

