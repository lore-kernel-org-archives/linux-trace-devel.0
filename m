Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DAAC433E7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A4A206F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 21:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbgGNVXW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728098AbgGNVXW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 17:23:22 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B75A3206F5;
        Tue, 14 Jul 2020 21:23:21 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.93)
        (envelope-from <rostedt@goodmis.org>)
        id 1jvSOW-004vaA-P7; Tue, 14 Jul 2020 17:23:20 -0400
Message-ID: <20200714212320.643881701@goodmis.org>
User-Agent: quilt/0.66
Date:   Tue, 14 Jul 2020 17:19:35 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Namhyung Kim <namhyung@kernel.org>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Subject: [PATCH 6/8] libtraceevent: Fixed type in PRINT_FMT_STING
References: <20200714211929.828530560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>

PRINT_FMT_STING -> PRINT_FMT_STRING

Link: https://lore.kernel.org/r/CAM9d7cj1LJ=QO8QxhBo_oDM9APpAswX4BbTwge0JhZ3Y4-Bv9w@mail.gmail.com
Link: https://lore.kernel.org/linux-trace-devel/20200714103027.2477584-7-tz.stoyanov@gmail.com

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 lib/traceevent/event-parse-local.h | 2 +-
 lib/traceevent/event-parse.c       | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/traceevent/event-parse-local.h b/lib/traceevent/event-parse-local.h
index e71296a62236..d805a920af6f 100644
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
index 4de9729ccc05..186fee3364e3 100644
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


