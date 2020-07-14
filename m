Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D96FC433EB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 571BA21D7B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 10:30:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HMyJYyDC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbgGNKak (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbgGNKaj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 06:30:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68A9C061794
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:38 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id dm19so16448799edb.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 03:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2VVEsnOIp47RSU/vkP91uXhClE90kvRxIvXW2f9IQ1Q=;
        b=HMyJYyDCYSoghPfLQHoy0cdpil1ITiDot2o5g5+tXw0+vqbMWK0zhaxE8l0PEjEIEH
         O43kW+KAbHB2k5CMnYhW8JCFbSMOZhbtOC0jxBHmhIaxP5T1ujCvGsT/lwpwbtif03tv
         wppGpL5WTzr9MoaqARFQ/9YzkrW233BpKUrn+wup5oBIZ10dN5eGeCnNPKuoh32kQiod
         PVYK9VHxMBb+p2aV7D0bmIg2uY7EhcMYUe3qiOumCxh699tPjzQq11+9hTqOrACf3uIZ
         UAJGFPoQBIep+XB90UwS6RWrAbOPDUikPtl0WnORWaaQvhpRDN9yy3WNMtNAGAeFaoms
         MkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2VVEsnOIp47RSU/vkP91uXhClE90kvRxIvXW2f9IQ1Q=;
        b=crNi04ZEvTcSer5xIPUwCztyp7AeznHHbe6X9q0FDo0pT0R67gufBkjJ0uX9b2sJ2B
         v/5ClRZvPu4AFh3mov/S+TEJDZp5iAqmHl1smw3wkT6/pLMZ3XBD2f1GYH7acHRXLt6m
         1dQkBXSgdANclZXr7liGppHNuXBi7ntZ+t+eyCme6xXe1Eh38xg3DFVn2IDlKyI06JJV
         IP0LieOligfQny4lQQAdrcshiRTxTbiLlMCFQJtB2axxK98wYte5KjPmbKH8khGwTvHe
         SPBkUuxr0fdsweI7gx9VgMmNH3yqfcgh2hCzbcc4m2dR+evk5h9w9UIR5plbP4G5UaeM
         Hlvw==
X-Gm-Message-State: AOAM531tmLCXa2BEQ03iKbFyrWKFF6741SI/hGvTyl/zGZ5lD8Ujkbm2
        kuaRdzvBcwR4tknwBTDZm8k=
X-Google-Smtp-Source: ABdhPJy0a2erQnqyr3Ty/8qvxHXcW9k8gZ6t7uysBAzZmvmqrrEqgU9aCwqepkXjeD53b7c4dWOWaA==
X-Received: by 2002:aa7:da4c:: with SMTP id w12mr3715899eds.122.1594722637659;
        Tue, 14 Jul 2020 03:30:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gr15sm11766034ejb.84.2020.07.14.03.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 03:30:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, namhyung@kernel.org
Subject: [PATCH 6/8] trace-cmd: Fixed type in PRINT_FMT_STING
Date:   Tue, 14 Jul 2020 13:30:25 +0300
Message-Id: <20200714103027.2477584-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

PRINT_FMT_STING -> PRINT_FMT_STRING

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

