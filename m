Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F76C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D46720866
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbfCZPnf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:43:35 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37820 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbfCZPne (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:34 -0400
Received: by mail-wr1-f67.google.com with SMTP id w10so14947865wrm.4;
        Tue, 26 Mar 2019 08:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OtWNvrczy9+nV+RCDF2iOR7mnvgfA9hr6XE0rdj350A=;
        b=A6sCU2rTlqqAjSLebFVzp7p60ggvIWxG7t10A3uf/V9qLhDgzuZlgsz98jAgmTvL8j
         sOaApiSi9+EbLRW7RDKgLtWezlLP59LbxrupjF7Us0ikoUXyqPxEkpbGSUtprLcBO06Q
         GuEm55oQ7A5T4KTB4alDZCiHJSpiickHOjHiF4aVZzoA3XlmPiOJ8JOgroQWjaNBlhMR
         HoPP4fCkWnAD8/hWVDjewFIYzIsX/z+72NuQQMQs/D0nJfGUSzbkn163dkPc4ssGfgPy
         kuruk17bFgNqamZnZtN9jGaRMY+VxpIckJcIV4MmAuYLGME/fMIuNbF9iE196QCrrgGH
         1CRA==
X-Gm-Message-State: APjAAAUzMqJffwjd/B79BmrHHeHeVdZrEQWyNLjkzgt/kyH7kiDtqhDh
        tBgDJG01O2KwR130F3C2VuRNhg2d
X-Google-Smtp-Source: APXvYqwo7nEOkwa9h0Uzm+0prYavAbUt4us/MGVUDqC3o8vV0q24GbhUZPlOaz18NJM/emsFsNvZUA==
X-Received: by 2002:adf:e487:: with SMTP id i7mr20397498wrm.264.1553615012594;
        Tue, 26 Mar 2019 08:43:32 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:31 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] tools/lib/traceevent: Add counter to track parsing failures
Date:   Tue, 26 Mar 2019 17:43:22 +0200
Message-Id: <20190326154328.28718-3-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326154328.28718-1-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch adds a parsing failures counter to struct tep_handle. The counter can
be used to track failures on parsing event format files. It is updated
automatically by tep_parse_event(), when failure is detected. The patch also
adds two new APIs for accessing the counter:
 tep_get_parsing_failures() - returns the current value of the counter.
 tep_clear_parsing_failures() - clears the counter.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c   | 27 ++++++++++++++++++++++++
 tools/lib/traceevent/event-parse-local.h |  2 ++
 tools/lib/traceevent/event-parse.c       |  8 ++++++-
 tools/lib/traceevent/event-parse.h       |  2 ++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index 46670bb87051..1fe284b1fac8 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -371,3 +371,30 @@ void tep_set_test_filters(struct tep_handle *tep, int test_filters)
 	if (tep)
 		tep->test_filters = test_filters;
 }
+
+/**
+ * tep_get_parsing_failures - get the count of parsing failures
+ * @tep: a handle to a tep_handle
+ *
+ * Every time when tep_parse_event() fails to parse an event format file,
+ * a parsing failure is registered. This returns the parsing failures count.
+ */
+int tep_get_parsing_failures(struct tep_handle *tep)
+{
+	if (tep)
+		return tep->parsing_failures;
+	return 0;
+}
+
+/**
+ * tep_clear_parsing_failures - clear parsing failures count
+ * @tep: a handle to a tep_handle
+ *
+ * Every time when tep_parse_event() fails to parse an event format file,
+ * a parsing failure is registered. This clears the parsing failures counter.
+ */
+void tep_clear_parsing_failures(struct tep_handle *tep)
+{
+	if (tep)
+		tep->parsing_failures = 0;
+}
diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 35833ee32d6c..c5c8eb4c4ab7 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -83,6 +83,8 @@ struct tep_handle {
 	struct event_handler *handlers;
 	struct tep_function_handler *func_handlers;
 
+	int parsing_failures;
+
 	/* cache */
 	struct tep_event *last_event;
 
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f309b6d7e08a..4144c4e20e4e 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6230,7 +6230,13 @@ enum tep_errno tep_parse_event(struct tep_handle *pevent, const char *buf,
 			       unsigned long size, const char *sys)
 {
 	struct tep_event *event = NULL;
-	return __parse_event(pevent, &event, buf, size, sys);
+	enum tep_errno ret;
+
+	ret = __parse_event(pevent, &event, buf, size, sys);
+	if (ret != TEP_ERRNO__SUCCESS)
+		pevent->parsing_failures++;
+
+	return ret;
 }
 
 int get_field_val(struct trace_seq *s, struct tep_format_field *field,
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index f3b822736d87..dcf0385684b8 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -464,6 +464,8 @@ enum tep_errno tep_parse_format(struct tep_handle *pevent,
 				struct tep_event **eventp,
 				const char *buf,
 				unsigned long size, const char *sys);
+int tep_get_parsing_failures(struct tep_handle *tep);
+void tep_clear_parsing_failures(struct tep_handle *tep);
 
 void *tep_get_field_raw(struct trace_seq *s, struct tep_event *event,
 			const char *name, struct tep_record *record,
-- 
2.20.1

