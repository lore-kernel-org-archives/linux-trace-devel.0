Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482FFC433E6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27648206C1
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2oK19Bg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgGPJU0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgGPJU0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:20:26 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F02C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:26 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so5787025ejb.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3nw1KI6LWm7v8BJsU/Inqrz/v/JDXfD4XkVchaAkiGo=;
        b=b2oK19BgesTC3HAqgSmLOtsNU0Z3Mp8jjPDsUdzp1lnbMMprEDq58Mly6f/gx8LC/Y
         TnuNJ+dawxaAzzPJTLyK6HQmRWtW0H6EaaZnk81XkMOjKWmwtw/JJ9yV+l/CeAGSVMEk
         Ax+sKoTRvC7HIp6cPO2wj7WrbfzKo8MaVnAV9BeUI8oHDIzs78dqZ4jYhhtWzWshEjKc
         FGKQeLIx80rWrBXikjErU/2w+gSbGKrz65z8ABhd7jtH4y2PDDmVgunS/rZPlhRnHfDN
         wyUd6Kx9QxUagMu/TqRArWHXLt+JcEz17hRmwn7eKIsxkgSwEc8RYSNuhBUhChMZMhyj
         revA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3nw1KI6LWm7v8BJsU/Inqrz/v/JDXfD4XkVchaAkiGo=;
        b=a4INCewaySSGiGVJBJUOesco23VqH/hFUbubGPb7aH1tXNHS+bA0IUKuzG3XFRd54W
         ic560+2zqcMk8YZZG1z+zOKF+/kKVygTtUzUJhLPzxkGxgyGjh6jR+/MdEHmnwM1JjHj
         Ukuycj/fjA7G0KBPQsOeFGrBdol62f14H6m7c9M3FgbVTaKvff5ChAebL4KWtISKP9yW
         DYwUaJ0BkWbwFoKPx1P+IxHjuUwO/qs+/92Moa7WCChKV3DWl4T5cUWwxZ0+yUAqzRDN
         LJgrZqVZm3gX8B7Wd2Pridgswvo9Nt/yFzlGH55oeGOI3+YeIarSbmXt9GuQDTaWuOrn
         Rpyg==
X-Gm-Message-State: AOAM531UqebzWrWWDGi3umh2l5QOLDFUIueziEAjX6Kx+RYtYh5QYvos
        gM76hJmzr0I9ospdXy2pXvM=
X-Google-Smtp-Source: ABdhPJwY2NFR3yHeHQqWUESugR2m9uw31RVmo9tO23KzK6joemyzKEhp/jAN1Vl4NA1Tz3wIfJLesA==
X-Received: by 2002:a17:906:38d6:: with SMTP id r22mr431824ejd.219.1594891224770;
        Thu, 16 Jul 2020 02:20:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y1sm5129117ede.7.2020.07.16.02.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:20:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 6/8] tools lib traceevent: Fixed type in PRINT_FMT_STING
Date:   Thu, 16 Jul 2020 12:20:12 +0300
Message-Id: <20200716092014.2613403-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
References: <20200716092014.2613403-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PRINT_FMT_STING -> PRINT_FMT_STRING

Link: https://lore.kernel.org/r/CAM9d7cj1LJ=QO8QxhBo_oDM9APpAswX4BbTwge0JhZ3Y4-Bv9w@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-7-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse-local.h | 2 +-
 tools/lib/traceevent/event-parse.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index e71296a62236..d805a920af6f 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -86,7 +86,7 @@ struct tep_handle {
 };
 
 enum tep_print_parse_type {
-	PRINT_FMT_STING,
+	PRINT_FMT_STRING,
 	PRINT_FMT_ARG_DIGIT,
 	PRINT_FMT_ARG_POINTER,
 	PRINT_FMT_ARG_STRING,
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8ee83f1e4e01..af56b60e5f89 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5612,7 +5612,7 @@ static int parse_arg_format(struct tep_print_parse **parse,
 		default:
 			snprintf(print_format, 32, ">%c<", *format);
 			parse_arg_add(parse, print_format,
-					PRINT_FMT_STING, NULL, NULL, 0);
+					PRINT_FMT_STRING, NULL, NULL, 0);
 			ret++;
 			return ret;
 		}
@@ -5664,7 +5664,7 @@ static int parse_arg_string(struct tep_print_parse **parse, const char *format)
 		ret++;
 	}
 	trace_seq_terminate(&s);
-	parse_arg_add(parse, s.buffer, PRINT_FMT_STING, NULL, NULL, 0);
+	parse_arg_add(parse, s.buffer, PRINT_FMT_STRING, NULL, NULL, 0);
 	trace_seq_destroy(&s);
 
 	return ret;
@@ -5722,7 +5722,7 @@ static void print_event_cache(struct tep_print_parse *parse, struct trace_seq *s
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

