Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234A8C10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F105420883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbfDHPXz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55139 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728951AbfDHPXz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id c1so14836806wml.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z8f/+JPxDRCvU3Om2ZqS7htdKtk15rNN0RbUl8FJsdo=;
        b=RHsMIvawVh95MS1oARm7mzGFuHRgcqQVg944Er2o2C7I7xNV2khlyK6Cu4TZGTT/4d
         itUnOJmx266BJXWggBwVEyuEkdvGkqMZpXGXiJDXHksfSgJeGxZvFJgtc5K0JA9zfze4
         YEb0hsCffMp6ppOf+CtU3R1UZ+iNfd+kVj4ZpmNNb+ym7hZiEO+yugdMw/iFbDniNvv1
         cCl2NC3JPvm4k0gbSXazwCTASXw8SWfXb6FnF26f3YOcuK9aVVkc/S28Fmh6YgJr5Csy
         iFCPGms8vLoS6tTV1PCPVpnUcsrnrMBOZRg9eJUXqKkhXUgtiVJYsPsVt2W7LlOiISZu
         kLnw==
X-Gm-Message-State: APjAAAVvK/jGqr0Y4Ul0x3T4iNuOpYUij9GAUssA6x52DITkR/3PqoSD
        fYFrVSgJmOGpEFxDSX5hkIc=
X-Google-Smtp-Source: APXvYqzNgLxNVVTgkXsd2d0SvZ6Qqs4LBXOucyVNUQ7IEUTRi+qDsQMZp4qz7ZlMm7eMwQeOLunm0w==
X-Received: by 2002:a1c:f504:: with SMTP id t4mr16984891wmh.121.1554737034036;
        Mon, 08 Apr 2019 08:23:54 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:52 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/10] perf tools, tools lib traceevent: Rename "pevent" member of struct tep_event_filter to "tep"
Date:   Mon,  8 Apr 2019 18:23:39 +0300
Message-Id: <20190408152340.12450-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The member "pevent" of the struct tep_event_filter is renamed to "tep".
This makes the struct consistent with the chosen naming convention:

  tep (trace event parser), instead of the old pevent.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/linux-trace-devel/20190401132111.13727-4-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164344.785896189@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  2 +-
 lib/traceevent/parse-filter.c    | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index bedff0b..bded403 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -707,7 +707,7 @@ struct tep_filter_type {
 #define TEP_FILTER_ERROR_BUFSZ  1024
 
 struct tep_event_filter {
-	struct tep_handle	*pevent;
+	struct tep_handle	*tep;
 	int			filters;
 	struct tep_filter_type	*event_filters;
 	char			error_buffer[TEP_FILTER_ERROR_BUFSZ];
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index 1233582..6a4d5d1 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
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
@@ -1377,7 +1377,7 @@ int tep_filter_strerror(struct tep_event_filter *filter, enum tep_errno err,
 		return 0;
 	}
 
-	return tep_strerror(filter->pevent, err, buf, buflen);
+	return tep_strerror(filter->tep, err, buf, buflen);
 }
 
 /**
@@ -1440,7 +1440,7 @@ void tep_filter_reset(struct tep_event_filter *filter)
 
 void tep_filter_free(struct tep_event_filter *filter)
 {
-	tep_unref(filter->pevent);
+	tep_unref(filter->tep);
 
 	tep_filter_reset(filter);
 
@@ -1462,7 +1462,7 @@ static int copy_filter_type(struct tep_event_filter *filter,
 	/* Can't assume that the pevent's are the same */
 	sys = filter_type->event->system;
 	name = filter_type->event->name;
-	event = tep_find_event_by_name(filter->pevent, sys, name);
+	event = tep_find_event_by_name(filter->tep, sys, name);
 	if (!event)
 		return -1;
 
@@ -1872,7 +1872,7 @@ int tep_event_filtered(struct tep_event_filter *filter, int event_id)
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

