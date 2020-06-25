Return-Path: <SRS0=vwyE=AG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48F0C433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9204020702
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Jun 2020 10:04:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nia75yUG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390842AbgFYKEr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 06:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390025AbgFYKEr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 06:04:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB916C061573
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:46 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h15so5192914wrq.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jun 2020 03:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=60iuJDtlWBAk7jZrpTAS8e3t78c4MVMAXgyNyfhBEmg=;
        b=Nia75yUG7ntI30fPP/STN592/1Tgtb3yZX47sJ593SOa0/LMOb5R2Es7gijTATroBu
         m73DBZAvkzf0OhLLS+r4bt5wd2jmzBu500FDPG61e2OKxqN2xxHGGdlvgbbVXUk/k2L+
         EuMKVZUEQmFAkM/qA6b+uSd0l2+H7eoczz1dcKPbMLDKso1NY5cpoQlZKXepuV6sYtrA
         FB8dvbpH+oHGTBHKlVQZ9KxJ0+1XUyi/MgXXh9A36xSUCm3Jp4CLvn2YGGvq/JvtRXb+
         jS/GsegqDbp0i6K9drfi1TvKdafnBstca9sIxdHrt1rGcyF4en7I4xryFQrBlv7Zn/AL
         0/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=60iuJDtlWBAk7jZrpTAS8e3t78c4MVMAXgyNyfhBEmg=;
        b=jzG9Yn+KP0oRyy1j6JM1Lh2mDfSDe2uB32iq1IEFL43GnzdHRF4VIccy9LkDrjkamo
         bIOo5AVZRhVasrcqJFR6uvTFb8NGaq7iYOzA8sI14jyyfpbqnrqFu8JcN+UWEYIxxZgL
         yTCKEtGmxp8KSm4ZirPwQxZav3+xFED4fLR0ne3UDqHa9gQ0U8hKHhUzn+PTdZNsbxUV
         0cq6WbfUESVEuEfbEA1ce0xt5/0EoPrs5OWyfmY4u/7UNXt3UU3dc9b+OTEy1Ods/fr2
         mXl310g7WDo7YiPitmALjDEeXc37v5QGOoc2Xq+GMdy+Bxo0obtxuXWPoxD0RJgsPX90
         KHYg==
X-Gm-Message-State: AOAM5312fw5hRUgNZt8oU23vnLMXFg7Ux8J4IcHNkBvQFtJxhWHKs6Aj
        pJcrw/xiLEMkiDKqAtCjDqGWgKs8B30=
X-Google-Smtp-Source: ABdhPJy64aqa3au1AiHp4NuSuXeraF6MSV3P+9OeLCPdynhFz8G1yA1shyCmV506GBVU59KT+7MzEA==
X-Received: by 2002:a5d:6150:: with SMTP id y16mr38474375wrt.219.1593079485471;
        Thu, 25 Jun 2020 03:04:45 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm7519008wmf.33.2020.06.25.03.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 03:04:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/3] trace-cmd traceevent: Add handler for __builtin_expect()
Date:   Thu, 25 Jun 2020 13:04:40 +0300
Message-Id: <20200625100440.365196-4-tz.stoyanov@gmail.com>
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

In order to move pointer checks like IS_ERR_VALUE() out of the hotpath
and into the reader path of a trace event, user space tools need to be
able to parse that. IS_ERR_VALUE() is defined as:

 #define IS_ERR_VALUE() unlikely((unsigned long)(void *)(x) >= (unsigned long)-MAX_ERRNO)

Which eventually turns into:

  __builtin_expect(!!((unsigned long)(void *)(x) >= (unsigned long)-4095), 0)

Now the traceevent parser can handle most of that except for the
__builtin_expect(), which needs to be added.

Link: https://lore.kernel.org/linux-mm/20200320055823.27089-3-jaewon31.kim@samsung.com/

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kees Kook <keescook@chromium.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200324200956.821799393@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 7e9cd9bb..ee16be96 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -3084,6 +3084,37 @@ err:
 	return TEP_EVENT_ERROR;
 }
 
+static enum tep_event_type
+process_builtin_expect(struct tep_event *event, struct tep_print_arg *arg, char **tok)
+{
+	enum tep_event_type type;
+	char *token = NULL;
+
+	/* Handle __builtin_expect( cond, #) */
+	type = process_arg(event, arg, &token);
+
+	if (type != TEP_EVENT_DELIM || token[0] != ',')
+		goto out_free;
+
+	free_token(token);
+
+	/* We don't care what the second parameter is of the __builtin_expect() */
+	if (read_expect_type(TEP_EVENT_ITEM, &token) < 0)
+		goto out_free;
+
+	if (read_expected(TEP_EVENT_DELIM, ")") < 0)
+		goto out_free;
+
+	free_token(token);
+	type = read_token_item(tok);
+	return type;
+
+out_free:
+	free_token(token);
+	*tok = NULL;
+	return TEP_EVENT_ERROR;
+}
+
 static enum tep_event_type
 process_function(struct tep_event *event, struct tep_print_arg *arg,
 		 char *token, char **tok)
@@ -3128,6 +3159,10 @@ process_function(struct tep_event *event, struct tep_print_arg *arg,
 		free_token(token);
 		return process_dynamic_array_len(event, arg, tok);
 	}
+	if (strcmp(token, "__builtin_expect") == 0) {
+		free_token(token);
+		return process_builtin_expect(event, arg, tok);
+	}
 
 	func = find_func_handler(event->tep, token);
 	if (func) {
-- 
2.26.2

