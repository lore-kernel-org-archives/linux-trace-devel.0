Return-Path: <SRS0=0q7s=A2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5950AC433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3866F20663
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jul 2020 02:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVsN97jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgGOCaW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 22:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgGOCaV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 22:30:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68794C061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:21 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w6so550620ejq.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 19:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0rHb8DgsWADhSVw1tHXxj32vBQZm7HVS0zcUBfS3jfw=;
        b=jVsN97jqy35XE8GdOs40Xpwtpvca1iOxNd42ICjfxTnH0u7dWFbkcFedDdTwyYNzmh
         KCXmoRPOeCOE1w28LNmHmkSN+8OM9V68bJFY0Lr7ASWZi/10Fris78li8RQBIRtwxydC
         Nzj4B0pD9xtPCN4V66+zQT7MDxFkA3tlfDOoz8AC0F83cdvONhXe1lLHz9RwHwcJcV6U
         C5Tpr7cd68m6QWJRGeggdqiKU1psMUxYr6mfTWCxvl8xumtU+x0CYkC3yUase1/LQTCn
         /mv1IW/G9OBV8SZcmSYtcFuxPVxsZRi5BZPbUYqmf5VQWgY3/ENhubnqTkueSnWzNn1+
         2EQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0rHb8DgsWADhSVw1tHXxj32vBQZm7HVS0zcUBfS3jfw=;
        b=K7OKYztRz9aaIwrkew/immnh4Hu8U3Myk6yx9UaUfuSrPQMARzoaYTkiKG9ydg9uzj
         qjz3dBw/d8a2oQEyh/y9560SuIAmxNet1zcKkOThVvke522i2rHkxKpLIDLyiODpQsX9
         mnQnX5FkuBMhk2dv9YM8b8nysvGXDU3vjEEcHzrIs62lKhg6nutJTGBRROv4KBxLPgpX
         aIMOTU+xU40MiEhAYN1nCMj66zrXE38R43QMeBW0keryQC2sjdz5QsyR8tAvKvG4mi1i
         UGWIJifhfU/zkstEhhNHe0NJtr4sWRXoGz/lFqhcKdapRrAz8H0304GB1v7+4s17VGIb
         l9VA==
X-Gm-Message-State: AOAM5317PokZ63oiEIsGarkRLW46R15I+UebhORTwmvFJlgY1emx8+Ig
        ETQnTpuhcaxwfmEo1fxF9K06G530dn8=
X-Google-Smtp-Source: ABdhPJxYlxAZUbJ8MnGWXf0KkODuqmSdXqRYNOdiptHm5iLDH4BdjAasZDI9BIeu5HSRWlqEZN7GCQ==
X-Received: by 2002:a17:906:3a17:: with SMTP id z23mr6977879eje.238.1594780220206;
        Tue, 14 Jul 2020 19:30:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d24sm576474edp.83.2020.07.14.19.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 19:30:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH v2 6/8] trace-cmd libtraceevent: Fix type in PRINT_FMT_STING
Date:   Wed, 15 Jul 2020 05:30:07 +0300
Message-Id: <20200715023009.2503879-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
References: <20200715023009.2503879-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PRINT_FMT_STING -> PRINT_FMT_STRING

Link: https://lore.kernel.org/linux-trace-devel/20200707113138.5a7a27f5@oasis.local.home/T/#md359007fc0883ae3a3088f79b8873a0b568da7bb
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/event-parse-local.h | 2 +-
 lib/traceevent/event-parse.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index e71296a6..d805a920 100644
--- a/lib/traceevent/event-parse-local.h
+++ b/lib/traceevent/event-parse-local.h
@@ -86,7 +86,7 @@ struct tep_handle {
 };
 
 enum tep_print_parse_type {
-	PRINT_FMT_STING,
+	PRINT_FMT_STRING,
 	PRINT_FMT_ARG_DIGIT,
 	PRINT_FMT_ARG_POINTER,
 	PRINT_FMT_ARG_STRING,
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 4de9729c..186fee33 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -5659,7 +5659,7 @@ static int parse_arg_format(struct tep_print_parse **parse,
 		default:
 			snprintf(print_format, 32, ">%c<", *format);
 			parse_arg_add(parse, print_format,
-					PRINT_FMT_STING, NULL, NULL, 0);
+					PRINT_FMT_STRING, NULL, NULL, 0);
 			ret++;
 			return ret;
 		}
@@ -5711,7 +5711,7 @@ static int parse_arg_string(struct tep_print_parse **parse, const char *format)
 		ret++;
 	}
 	trace_seq_terminate(&s);
-	parse_arg_add(parse, s.buffer, PRINT_FMT_STING, NULL, NULL, 0);
+	parse_arg_add(parse, s.buffer, PRINT_FMT_STRING, NULL, NULL, 0);
 	trace_seq_destroy(&s);
 
 	return ret;
@@ -5769,7 +5769,7 @@ static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s
 					 parse->len_as_arg ? len_arg : -1,
 					 data, size, event, parse->arg);
 			break;
-		case PRINT_FMT_STING:
+		case PRINT_FMT_STRING:
 		default:
 			trace_seq_printf(s, "%s", parse->format);
 			break;
-- 
2.26.2

