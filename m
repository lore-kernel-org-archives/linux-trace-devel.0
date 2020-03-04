Return-Path: <SRS0=Pf13=4V=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED0BC3F2D9
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A84F02072D
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:12:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HK5GzC6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgCDJMg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:12:36 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42174 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728642AbgCDJMg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:12:36 -0500
Received: by mail-lj1-f193.google.com with SMTP id q19so1136076ljp.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 04 Mar 2020 01:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJBWXrSOqRQ/RhKbgsUp/TZOWdF6225Vq87cd1rdEE0=;
        b=HK5GzC6KOfyVfSdk1jGpWXNV/GfXNZpDvZNCYVhIf8L4cdRqhp82oC+8kHKr4tdTMG
         8vddqG1ySxIHm5X1SMArRFWt6ZrZhaB9MCAFgEyIl6L2FZ6oCKGPoX2CT8tE5OL/8xPv
         OxEWSHu45EUU6s1a/dr479K3XlGv0OKAJp5QaN+lgXyPMm7lA6h0aQ4oUpsB7hMe+JNK
         7uF3mE9XE+Hu5yDwKg/TG/15hZxQdLxGGK2SYgVKlyNWjttulpqVkLWvAx1fIWN1pIFV
         dSFbCs1Blh5gdY2eq0kKti9BKXucNT5q7mNYqwV9kh3qC2NpMfgC4xCScNSdpw8uWpFQ
         D+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJBWXrSOqRQ/RhKbgsUp/TZOWdF6225Vq87cd1rdEE0=;
        b=Yg1t6CnW8+xBdkjmOjRMVHesn9RS7CuvBS4v0fzBnSVrXK9LxqZNLeiRejU5oTHYVA
         2XcrLaVn6lfcChfR9YMAKoUmNR7HNx2hwesvshXroCef0I7nHDLqcVCxDQlGcKRCS0sb
         AJOjFNG75MWg5HgH/Xj+4twfpWJh26yXJKaEe1aG8rpK8eoUafmYi/GdPENBhosMztwq
         CeQ4ROf7mhNwMF1oKtNSjmIWZU0NcrOX5BBgurvd8K48vrklpwAA92SC0qQOpDRcn1f4
         8si8GfiQ4m2fAsbdnrYDLYGn4ZMG73UnJY6m/ooDdl21O7DEbJqWhuIBZI7aKQN7Favf
         a2Hg==
X-Gm-Message-State: ANhLgQ3dRj/Qb0P8vEuSgHxMW6uNsQEIb53RrWfS/02eM0K/B+O39y7G
        au+xPCYUKqKqq+YfKMm4x+OYpBAS
X-Google-Smtp-Source: ADFU+vulV8JFY6wGA4tk3XuY2L9PenRauW6HAXmnOjh+Z/oFV8cRwlckLW8BVLvqfaiH+TqYicNI1w==
X-Received: by 2002:a2e:844e:: with SMTP id u14mr1369089ljh.183.1583313154442;
        Wed, 04 Mar 2020 01:12:34 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v15sm13327462lfg.51.2020.03.04.01.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 01:12:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v22 09/13] trace-cmd: Add host trace clock as guest trace argument
Date:   Wed,  4 Mar 2020 11:12:16 +0200
Message-Id: <20200304091220.30936-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304091220.30936-1-tz.stoyanov@gmail.com>
References: <20200304091220.30936-1-tz.stoyanov@gmail.com>
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
index f1e2a391..2e82464d 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5599,6 +5599,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_sync_set = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5642,6 +5644,8 @@ static void parse_record_options(int argc,
 		 */
 		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
+			if (c == 'C')
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			continue;
 		}
 
@@ -5756,6 +5760,9 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
+			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+			if (is_top_instance(ctx->instance))
+				guest_sync_set = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5980,6 +5987,20 @@ static void parse_record_options(int argc,
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

