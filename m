Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EBDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0446620866
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 15:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732089AbfCZPoK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:44:10 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42566 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732081AbfCZPnj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 11:43:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so11439651wrx.9;
        Tue, 26 Mar 2019 08:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SPzWbhECY7YRkPD8wQD2k8BCrJ5/QV8ZXJkGLDDU2L0=;
        b=ncVE8rkq/n1A67myzgwnFUzNucvV3hKzR/tucMtxSXujncsbGDRWxDmSF8yOl13zo9
         B5WomgbLcuQmMlOOwxz7Ps3NDA32bvjyFRM641/z9eYdwbUrImoSPpbFkClc+tCXK4+p
         Fb26XGzahMc8HlLytPLLPbRsZf52rAdUEEe/omnEv4sfwylO7eEarE+lGgNGkwyKkV/o
         voxGerJ4vzXix9VgypfzGQiSkwgPcABBhDvr5fGLynhWacJJ7ZLIvvJJcUQIehJMieln
         B/4cBSnPhPbLzUtuRxIlO6Ed1sPujvVWJJibzqr7vnNOdSMV8PlWZZNZ73z/T6uXAbeY
         SWYg==
X-Gm-Message-State: APjAAAVh/NEknIZ19TjG2xGUzG2WYhTRMI0x75cCLYVOp3ksZ5L14ruH
        0NodVSmV8xWS6usZiWOQY2le2Fhl
X-Google-Smtp-Source: APXvYqz97HmUfZ4jRD1ZJO/Dh2VEMCvIkqj/m06N1yVXykpicQQv1eMzBnv1HBPFY/p+9lq86Kkkcg==
X-Received: by 2002:adf:afee:: with SMTP id y46mr19649646wrd.217.1553615017059;
        Tue, 26 Mar 2019 08:43:37 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n11sm31927685wrt.63.2019.03.26.08.43.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 26 Mar 2019 08:43:35 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] tools/perf,tools/lib/traceevent: rename "pevent" member of struct tep_event_filter to "tep"
Date:   Tue, 26 Mar 2019 17:43:26 +0200
Message-Id: <20190326154328.28718-7-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190326154328.28718-1-tstoyanov@vmware.com>
References: <20190326154328.28718-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch renames "pevent" member of the struct tep_event_filter to "tep".
This makes the struct consistent with the chosen naming convention:
tep (trace event parser), instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse.h  |  2 +-
 tools/lib/traceevent/parse-filter.c | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index d98362ff4bb1..17fb8d2dd081 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -718,7 +718,7 @@ struct tep_filter_type {
 #define TEP_FILTER_ERROR_BUFSZ  1024
 
 struct tep_event_filter {
-	struct tep_handle	*pevent;
+	struct tep_handle	*tep;
 	int			filters;
 	struct tep_filter_type	*event_filters;
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 231e9cae5729..1d2f1343090d 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -154,7 +154,7 @@ add_filter_type(struct tep_event_filter *filter, int id)
 
 	filter_type = &filter->event_filters[i];
 	filter_type->event_id = id;
-	filter_type->event = tep_find_event(filter->pevent, id);
+	filter_type->event = tep_find_event(filter->tep, id);
 	filter_type->filter = NULL;
 
 	filter->filters++;
@@ -175,7 +175,7 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *tep)
 		return NULL;
 
 	memset(filter, 0, sizeof(*filter));
-	filter->pevent = tep;
+	filter->tep = tep;
 	tep_ref(tep);
 
 	return filter;
@@ -1257,7 +1257,7 @@ static void filter_init_error_buf(struct tep_event_filter *filter)
 enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str)
 {
-	struct tep_handle *pevent = filter->pevent;
+	struct tep_handle *pevent = filter->tep;
 	struct event_list *event;
 	struct event_list *events = NULL;
 	const char *filter_start;
@@ -1380,7 +1380,7 @@ int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 		return 0;
 	}
 
-	return tep_strerror(filter->pevent, err, buf, buflen);
+	return tep_strerror(filter->tep, err, buf, buflen);
 }
 
 /**
@@ -1443,7 +1443,7 @@ void tep_filter_reset(struct tep_event_filter *filter)
 
 void tep_filter_free(struct tep_event_filter *filter)
 {
-	tep_unref(filter->pevent);
+	tep_unref(filter->tep);
 
 	tep_filter_reset(filter);
 
@@ -1465,7 +1465,7 @@ static int copy_filter_type(struct tep_event_filter *filter,
 	/* Can't assume that the pevent's are the same */
 	sys = filter_type->event->system;
 	name = filter_type->event->name;
-	event = tep_find_event_by_name(filter->pevent, sys, name);
+	event = tep_find_event_by_name(filter->tep, sys, name);
 	if (!event)
 		return -1;
 
@@ -1875,7 +1875,7 @@ int tep_event_filtered(struct tep_event_filter *filter, int event_id)
 enum tep_errno tep_filter_match(struct tep_event_filter *filter,
 				struct tep_record *record)
 {
-	struct tep_handle *pevent = filter->pevent;
+	struct tep_handle *pevent = filter->tep;
 	struct tep_filter_type *filter_type;
 	int event_id;
 	int ret;
-- 
2.20.1

