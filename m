Return-Path: <SRS0=Qwo8=ZV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7239EC43141
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47FE4217BA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 29 Nov 2019 10:17:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0IX6ui8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfK2KRz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 29 Nov 2019 05:17:55 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40212 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbfK2KRy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 29 Nov 2019 05:17:54 -0500
Received: by mail-lj1-f196.google.com with SMTP id s22so12375463ljs.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 29 Nov 2019 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=U0IX6ui8tJai4aQB+t7e5/Ypu4NrLny7p81NlJDcE1aKpwNunPMssEvmtsoqT1ffyT
         o5F0ugftF35XpgDAa5S43w9Jp+DmuoDdKxNhdbVQLTgyGS0kKRUYaJcMz8PPUOSN03jf
         xNtNAOCyf9Hd/Ec/CGzkQhTWAjpx/EyVppZEXTZyfZVghHL4va5pi0hdHzjWFOheu5Jp
         BvMJ6oBKF+k9eA2JW26CA7E8RziLu/p/icQq4ErvH4rVompjiICYU0Hjaa4HTvojtSFm
         AeMwCzjCxMEvMMKYDwWLe1atBk8TufJCHelq5fcrjy+uGZVgAtI7btC5IQIoY/KcgurX
         NBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=j/CBNd+uqFxJN7wMYxDJFlU6lMHbvBOQbwxjlJRy6XzbPNtl6S5EYr9V86uQIJ97mf
         +P3Mwn82ojD+a+I0mZdWWLENf8ahITKj9HuQY4KmVTEpDd9gl1ZSCrZJFViseJB8LMdV
         E/Sh1G0FTgQER5yJ7uwu0Vrl7Mghe3/RCYi581j5izpMayCI2f1D5ivIGjZ8x0POWMxc
         RfpPlroNxheIX0GGGvPMw0lwRvlmPLx54oWXS4IDuKK7HP/V7LiG2lIpSHBoE+rGEm1V
         fD39KhBi01MPpthfuzOz885+VVfOYnQiOY8ibhFx0eY8GwnRuqE6bRaxGH6C1JqhP6Qb
         w/AA==
X-Gm-Message-State: APjAAAWeC7vW81tMemk3u+nLqApZbluhLwkaTjrlGE9SydOVhdzy7Kyh
        RrK601EOVKEr4kAtcafgyxk=
X-Google-Smtp-Source: APXvYqzsqACY5/66KFFVojYHDRd8kbz9mZ2XFsXdl4ANncZN5hLXpx09Y9SnST0lwYFcDbzqmg042w==
X-Received: by 2002:a2e:9356:: with SMTP id m22mr25060046ljh.160.1575022672666;
        Fri, 29 Nov 2019 02:17:52 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id x29sm11367935lfg.45.2019.11.29.02.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 02:17:52 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v16 14/18] trace-cmd: Add host trace clock as guest trace argument
Date:   Fri, 29 Nov 2019 12:17:29 +0200
Message-Id: <20191129101733.375808-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191129101733.375808-1-tz.stoyanov@gmail.com>
References: <20191129101733.375808-1-tz.stoyanov@gmail.com>
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
index 49730d6..e7fb1bd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -5405,6 +5405,8 @@ static void parse_record_options(int argc,
 	char *sav;
 	int name_counter = 0;
 	int neg_event = 0;
+	struct buffer_instance *instance;
+	bool guest_config = false;
 
 	init_common_record_context(ctx, curr_cmd);
 
@@ -5562,6 +5564,7 @@ static void parse_record_options(int argc,
 			break;
 		case 'C':
 			ctx->instance->ftrace->clock = optarg;
+			guest_config = true;
 			break;
 		case 'v':
 			neg_event = 1;
@@ -5779,14 +5782,26 @@ static void parse_record_options(int argc,
 
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

