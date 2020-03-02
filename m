Return-Path: <SRS0=nG5h=4T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5109C3F2D2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC6720870
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Mar 2020 10:14:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlecpJsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCBKOU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:14:20 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:33618 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgCBKOU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 05:14:20 -0500
Received: by mail-lf1-f66.google.com with SMTP id c20so2887785lfb.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 02 Mar 2020 02:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k1H6SKZmy23mE04cheSQlM6psr5j7HrgIb8irbx1qXE=;
        b=ZlecpJslDJklaxfKhkxgY62KkVn5/GENoz7FamutP+MXmtf+IH7rPb/Q/rcnnmTJJa
         gFoW9OQo8HHDGn0NYhL1eEdWcv7dY1mik+VPqexPpCi0/p0T6uMISIAHH6Zduk0JURzw
         BSMgIXn1mD1VkS6jUh/8Ovb+dkcmxvuA1xR1MaKTwXzz3+/8Qsz1oy5x1rUOaMXL6nRz
         Qe0gCFvnW+RFnN8f6DcDnXVXRWs6WKakeap0zZBrV11cRk+YMpULWrSySryuftAaJwIS
         Ez+Q+udvu5oAPr+fnRqjgYVYwwvrcxBlCZh3smSMlw+FLSwK1mVdDlBXK7re83CZd5pS
         goCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1H6SKZmy23mE04cheSQlM6psr5j7HrgIb8irbx1qXE=;
        b=JAHO6kciTjZZltEPzYcNyVv+ASp/Mry6R9gfhc4m5uC8EvM+/kxNu2GcDSUYHM/8jY
         IfA8RmwGl5U4JHYqT37S6JvBWIqeYzGxISJRJCLp4xFxGTbE53NJcjQrmKCG6Xcjgiwj
         mrgYXK6+vJuBUe0hDcjb1A/8XGZ4+RTuPjv++oEl0XiNCrgNhbHNubbyqxNU5gP0WIgf
         vBjhNLQ1tt5vpgZyncBYlo5VOmdt+sdwYzoSzDoqXSQr4oW5z5xPmfVmAPGr+rdADmiX
         11MzIkto374FdKNVtx7apcSL8wWLE468gm/VdfpXJ37ncf7P3nvp7rBVns1zpyjV7ZLH
         duSw==
X-Gm-Message-State: ANhLgQ0IXYrFffe5A8ma0HH1A8d4ZkEzafZNO3PHEV4ADRnsvO87esNN
        4v/AVs1l57s3f7eTpFoHhVg=
X-Google-Smtp-Source: ADFU+vu2PT/ATexIiAjrOHi+Ezx5tGsCHdmSMWK7tB+Hb7oLsmT1kw86m2TdBlAb6XDN4h5Zjj42lw==
X-Received: by 2002:a05:6512:3b0:: with SMTP id v16mr10221051lfp.88.1583144058470;
        Mon, 02 Mar 2020 02:14:18 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x10sm11048236ljd.68.2020.03.02.02.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 02:14:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v21 09/13] trace-cmd: Add host trace clock as guest trace argument
Date:   Mon,  2 Mar 2020 12:14:00 +0200
Message-Id: <20200302101404.150035-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302101404.150035-1-tz.stoyanov@gmail.com>
References: <20200302101404.150035-1-tz.stoyanov@gmail.com>
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
index 15cae9be..e0b18044 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5598,6 +5598,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_sync_set = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5641,6 +5643,8 @@ static void parse_record_options(int argc,
 		 */
 		if (c != 'B' && c != 'A' && is_guest(ctx->instance)) {
 			add_arg(ctx->instance, c, opts, long_options, optarg);
+			if (c == 'C')
+				ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
 			continue;
 		}
 
@@ -5755,6 +5759,9 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->clock = optarg;
+			ctx->instance->flags |= BUFFER_FL_HAS_CLOCK;
+			if (is_top_instance(ctx->instance))
+				guest_sync_set = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5979,6 +5986,20 @@ static void parse_record_options(int argc,
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

