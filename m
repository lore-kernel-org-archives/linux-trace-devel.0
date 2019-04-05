Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D38C10F0F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC2221850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbfDEODq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34374 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731321AbfDEODq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id p10so8208882wrq.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QJShRltNtWakQoHBiZXAoZQ4U/BO0E3LIbRwt60J+dk=;
        b=enBlSocc4Hewm1WzyNNmRgmzGB7R/3BxcYseh4L5CbGALpzp6Mu3Nxc2h+3kQuqsS/
         3yneNFcHRMMoWw6sJAPDZ4ETcdagSXKC29o+zyIGCLQXNbWB8bBpKcSI3BWVyvLW6O8b
         mrv0LDp1H9ZTOThptGPRk9Ynno1i9x1OXvidmGvRWDwhHEmXPp431VWw7hbmMzjTEYVC
         WAI1wIR+MuxIP7oyFQKiCwTFLwICJBo6A1CJ3hNQDzdZb7CXMk9PAkjgczDbm0nmBLuA
         4TS/aixHmytUZjuzntjymUEj/emjCK567lztjHZ97lcqgv9urYm4kWuwtvToJIEPMtmI
         cEbQ==
X-Gm-Message-State: APjAAAWnDfzpif8NIC39xADmwHPe97ajwo8+1HUp643lyKlnNWRpitpq
        SZSMU78doT4WYC6m69ESdig=
X-Google-Smtp-Source: APXvYqwz9HWoo8bINf4sid1k7lekJw+rHkdAwN+bDEDMwTwiLHcc0auWyIWFUkCOV0DbVQeOnl0d7A==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr8429952wrq.94.1554473024521;
        Fri, 05 Apr 2019 07:03:44 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:43 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/10] perf tools, tools lib traceevent: Rename "pevent" member of struct tep_event_filter to "tep"
Date:   Fri,  5 Apr 2019 17:03:31 +0300
Message-Id: <20190405140332.10949-10-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
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
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flore.kernel.org%2Flinux-trace-devel%2F20190401132111.13727-4-tstoyanov%40vmware.com&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C8709eef239c24f62b34808d6b7854a2e%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180455249245&amp;sdata=iReA6l4lDMyNls3Wiz%2F3wtzKeanK6ooU4XEXygi1VQQ%3D&amp;reserved=0
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164344.785896189%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C8709eef239c24f62b34808d6b7854a2e%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180455249245&amp;sdata=IO5GdVmaVTJz1gElgI0McqoaFjt0SEe4uEfi9vs3luE%3D&amp;reserved=0
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

