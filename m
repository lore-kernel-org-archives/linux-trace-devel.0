Return-Path: <SRS0=xbdb=2D=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB28AC3B195
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E10DB246B1
	for <linux-trace-devel@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AMdZUO1N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbfLMPav (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:30:51 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46573 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727897AbfLMPav (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 13 Dec 2019 10:30:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id z17so3051448ljk.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 13 Dec 2019 07:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g2BNv0voN9Xj1WqBYWMsLUmcXTYMAZOVnJI4ZiLpTo4=;
        b=AMdZUO1NEiqalV/d9T1Md5jcMeMhwcNFRbQ8v3lZKrwjv1eTVyl61NH5ao7eM/WwXK
         hS/6flavqB9xp98R+jZMqZ9zHy8xHeOVxHunHryfSB7ft6sLosFbKX9ElQGxdnls7I7P
         v7Y0rjk/w51OciRpzbBbUKLQp1/KEG5Z1S2+kVfO7aWkRb8XJHPn1p3jMngW3iP/6cx5
         FV06mbo6Hu5CnauDvgO7QkWmkwYl+kvP5jn4OX2QH6RLbazYQFq21U4nnWnq/DXJ6uAq
         QQ9s45Ol0Yio/Vfa8U0ox4gJp5ypAXI9BokyFnUpfMEeEsI7Db1h1PYzwUa9F86YsoB1
         xmaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2BNv0voN9Xj1WqBYWMsLUmcXTYMAZOVnJI4ZiLpTo4=;
        b=d+JMXPC2SQ4/Ep+ukoatYje4FM1Q7wMUKtlLYs6GDr9GuXgo7sHK3HpJPkJM/4LfrI
         rDaT1M6oqke0FwtNAlsgpR3xbKsIQoaEBT5vJPaozzHq1yqG7IqMr5vRoTI+f15I1zJr
         nK4gywHIeAzEyA2rSPH1tsgMKKy6gBvFp8uQ3mHMlseJC+M/y5IPjVYv8q/uaUiDgCvG
         iU5lhq4P0d3m+C4htkdUgPKO9hdj6xJqhyx3dBUMrglbIDAhI6UOYB53Ke88uaqLwsni
         Fjfe0z3QWtNg+VYvs9EpVtDw71m3Bxgjs3hmAL3DTmtK88/YQDmIEBYVdljvatAZDjno
         FDFQ==
X-Gm-Message-State: APjAAAV3Wblil4lQ4gB6UWhXLYn1dFPXOjXMVPaow45bDxPHxldVA51F
        xdYyFOuEw4YTWeB7LNCaMWU=
X-Google-Smtp-Source: APXvYqxLG8AtzDkpSeZ20ZL8Eq+wwPqe9kLKLsMvkbHZYZnSRsUpHaJQi4w9Czu2BkKsAxxCWs/8gg==
X-Received: by 2002:a05:651c:112d:: with SMTP id e13mr8793140ljo.99.1576251049391;
        Fri, 13 Dec 2019 07:30:49 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u19sm5012806ljk.75.2019.12.13.07.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:30:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v18 14/18] trace-cmd: Add host trace clock as guest trace argument
Date:   Fri, 13 Dec 2019 17:30:25 +0200
Message-Id: <20191213153029.133570-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191213153029.133570-1-tz.stoyanov@gmail.com>
References: <20191213153029.133570-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-record.c        | 24 ++++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
index 90933cc..4c8d6cb 100644
--- a/tracecmd/include/trace-local.h
+++ b/tracecmd/include/trace-local.h
@@ -165,6 +165,7 @@ enum buffer_instance_flags {
 	BUFFER_FL_PROFILE	= 1 << 1,
 	BUFFER_FL_GUEST		= 1 << 2,
 	BUFFER_FL_AGENT		= 1 << 3,
+	BUFFER_FL_HAS_CLOCK	= 1 << 4,
 };
 
 struct func_list {
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e4e2d63..51b40ff 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_sync_set = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5448,6 +5450,8 @@ static void parse_record_options(int argc,
 		 */
 		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
+			if (c == 'C')
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			continue;
 		}
 
@@ -5562,6 +5566,9 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			tracecmd_alloc_instance_clock(ctx->instance->ftrace, optarg);
+			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+			if (is_top_instance(ctx->instance))
+				guest_sync_set = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5779,14 +5786,27 @@ static void parse_record_options(int argc,
 
 	/* If --date is specified, prepend it to all guest VM flags */
 	if (ctx->date) {
-		struct buffer_instance *instance;
-
 		for_all_instances(instance) {
 			if (is_guest(instance))
 				add_argv(instance, "--date", true);
 		}
 	}
 
+	if (guest_sync_set) {
+		/* If -C is specified, prepend clock to all guest VM flags */
+		for_all_instances(instance) {
+			if (tracecmd_get_instance_clock(top_instance.ftrace)) {
+				if (is_guest(instance) &&
+				    !(instance->flags & BUFFER_FL_HAS_CLOCK)) {
+					add_argv(instance,
+						 tracecmd_get_instance_clock(top_instance.ftrace),
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

