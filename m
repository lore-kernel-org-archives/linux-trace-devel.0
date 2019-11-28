Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 902B3C43215
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5848321775
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 08:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYB1NuKe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbfK1Iyb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 03:54:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33099 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbfK1Iya (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 03:54:30 -0500
Received: by mail-lj1-f196.google.com with SMTP id t5so27620444ljk.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 00:54:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=kYB1NuKeW/6ScJynfFIossaHEKdV8KojB46gzW2jK3cT/YS6NS8T4+P34EGUOWh8jK
         IYAZPnRr3lmr17r5vs94zuaMoKLmMLK9m3ZyZrzgmNXybbcHi2UJhuqquT/5Uc5XPrqr
         kNxLWsnN/BJD3blOAu42YmuZziqzT4XvrEU1uqDOhA0hPPu9X9qXESSEbZvdAtmjML9q
         qJrKfDYBa1twD9S8dPyDYgUZD6/RfBb+AKPQO7gpM00bi0rExvb1VAr29zHEkXX5OcVO
         E0B1jnNOzC2ekMAuIHqUB59wqqKdNqnkoTz/+w7G3IyqKPaijpKWY1HLjxs+3SLWxKFb
         44Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TzKltY28zxysFwGXwi4Pp9PUBgVROhECvLFXCt3zpQw=;
        b=Xjes+IykxQfCTPmYM9722Upq//l6jRGbmZ/nc27/9kPQObfh3XlNwoQLAauRNm9xQ4
         SjzQi9/8i5x5UI3k3Hrot6QNlJvn6HRp0pnqN9rPpvZDtau1holCheAv6J+0JQo/rEqm
         JRnA7y2U3cRcAtKzR+hZa/Y9O0dt+axRQFpN94eXBIFNO28+cETfafSivV9T6UimiBqh
         jqRP8U3gWCYl8gI7PyPQMeuOo7sqU/baVMwPr0JL/8cTm8RXV1Rk9c56Qw1S9+FgufSm
         fHAIZOiE4mkjGCnUnapR8CJNVMlfV8e18qJNElu0k9FUk9pE4N6ODEb44IXa/lPVclJh
         4tcA==
X-Gm-Message-State: APjAAAUVRfjMHaDRRw58DwF1rEJ75PPzxBjvMaYS3/8Yd/dxwpwjna4q
        dxGaBw+5tDrJh1abMl8fzHc=
X-Google-Smtp-Source: APXvYqwNT4HFRcUgZGI2Vulr0/ovBeRbXgqh8HJ4VSckRnmsJcMkb0ACo/2in08dKbazDczjjJJ4DA==
X-Received: by 2002:a2e:b4c7:: with SMTP id r7mr1575774ljm.82.1574931268402;
        Thu, 28 Nov 2019 00:54:28 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id z19sm8253735ljk.66.2019.11.28.00.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Nov 2019 00:54:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v15 14/18] trace-cmd: Add host trace clock as guest trace argument
Date:   Thu, 28 Nov 2019 10:54:05 +0200
Message-Id: <20191128085409.289684-15-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191128085409.289684-1-tz.stoyanov@gmail.com>
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
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

