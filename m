Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA32BC433E1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9758020702
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lF7lY5CW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390838AbgFYKEq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390025AbgFYKEq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:04:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD490C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t194so5291214wmt.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7Wl/d+4IKtFwki+9KWFlwQFRFPk+Az/qCl6wWBoZ+Dk=;
        b=lF7lY5CWI1RfFL0C68opoZCUzw8qgDaiDieSZQRTF1Pa818ZVBm7HxSsEOAYsa9DJq
         dNIT7MvV03ZcQnuduV8GF28T+tjTM81NAYyvIE+LI79+SVwEuQXPp5/UlYsvsaDV0n9Y
         3vlKYfwJdSkBso6WhIzlD8cTDuPYy2e19V0Ey6PL4vKLzb7vOCMBny6kLsvLH6FlYY7R
         tpXVZK4ancxbt9Av6jdh+MugCupdZtxu3sz34hHSHa8Xt0DGv488J5Yv6aMM7ROh9ZAW
         lMOskU96WGhsGjcfZ+Z3jrptMs9WkP7HsQzXs41YSiwlEe8cpRWujxPJ0CrpKxyRcdfz
         36sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7Wl/d+4IKtFwki+9KWFlwQFRFPk+Az/qCl6wWBoZ+Dk=;
        b=Y/BO+Dz8R5ReSLrzxy2jEXfy4OwTEJbVZNjlcugj1ETEhnt1y0wkpWISMuhZSCjUNS
         uW9Evihj8VBQxEeac191MtOYTi1j8Y8Zk/GcBeWDvRdEV0VhloAiX99+81Mwxqkrar/z
         50djWcOF3kh6Y/fZ0dzkACR99nUf6z36ToLjZbFHiwyghxmptI0o0o0qnmUQzI7u1CIN
         eSZPpik0i3cIcqMZsgC0nF5x8uSQXwxgxtkn9wX9tRXA4mvaWG5jguuhfCPthalPgJYL
         zZwlj2hEuDkZ8Th3pO2fD9sT96KBokslsh0+kWxKcBeUtsxMuTCOAm650AREJoHlQlhq
         bCzw==
X-Gm-Message-State: AOAM530GWRS/XY1ibOdhOvw821nfppBF36QqPOz5D/fTVbh5txyoH6eX
        A7hrkJdNSSS1yAiMCjas5Mg=
X-Google-Smtp-Source: ABdhPJyfTYoT8UFJlKaGRznwTgcRQVLxOJ3pVtHEpwQEN20uBtewsuMKiZ6JoVZdich/PVfkY9ePMA==
X-Received: by 2002:a1c:f203:: with SMTP id s3mr2409834wmc.126.1593079484496;
        Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm7519008wmf.33.2020.06.25.03.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:04:43 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/3] trace-cmd traceevent: Handle __attribute__((user)) in field names
Date:   Thu, 25 Jun 2020 13:04:39 +0300
Message-Id: <20200625100440.365196-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625100440.365196-1-tz.stoyanov@gmail.com>
References: <20200625100440.365196-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

Commit c61f13eaa1ee1 ("gcc-plugins: Add structleak for more stack
initialization") added "__attribute__((user))" to the user when
stackleak detector is enabled. This now appears in the field format of
system call trace events for system calls that have user buffers. The
"__attribute__((user))" breaks the parsing in libtraceevent. That needs
to be handled.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200324200956.663647256@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse.c | 39 +++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 6249dacd..7e9cd9bb 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -1444,6 +1444,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 	enum tep_event_type type;
 	char *token;
 	char *last_token;
+	char *delim = " ";
 	int count = 0;
 	int ret;
 
@@ -1504,13 +1505,49 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 					field->flags |= TEP_FIELD_IS_POINTER;
 
 				if (field->type) {
-					ret = append(&field->type, " ", last_token);
+					ret = append(&field->type, delim, last_token);
 					free(last_token);
 					if (ret < 0)
 						goto fail;
 				} else
 					field->type = last_token;
 				last_token = token;
+				delim = " ";
+				continue;
+			}
+
+			/* Handle __attribute__((user)) */
+			if ((type == TEP_EVENT_DELIM) &&
+			    strcmp("__attribute__", last_token) == 0 &&
+			    token[0] == '(') {
+				int depth = 1;
+				int ret;
+
+				ret = append(&field->type, " ", last_token);
+				ret |= append(&field->type, "", "(");
+				if (ret < 0)
+					goto fail;
+
+				delim = " ";
+				while ((type = read_token(&token)) != TEP_EVENT_NONE) {
+					if (type == TEP_EVENT_DELIM) {
+						if (token[0] == '(')
+							depth++;
+						else if (token[0] == ')')
+							depth--;
+						if (!depth)
+							break;
+						ret = append(&field->type, "", token);
+						delim = "";
+					} else {
+						ret = append(&field->type, delim, token);
+						delim = " ";
+					}
+					if (ret < 0)
+						goto fail;
+					free(last_token);
+					last_token = token;
+				}
 				continue;
 			}
 			break;
-- 
2.26.2

