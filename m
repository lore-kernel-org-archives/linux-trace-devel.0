Return-Path: <SRS0=eAkL=SL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F149C282DA
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 07:50:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DEDE20883
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Apr 2019 07:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDIHub (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Apr 2019 03:50:31 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39875 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfDIHub (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Apr 2019 03:50:31 -0400
Received: by mail-wr1-f68.google.com with SMTP id j9so19522393wrn.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Apr 2019 00:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z8f/+JPxDRCvU3Om2ZqS7htdKtk15rNN0RbUl8FJsdo=;
        b=dbfRpDV+SjhgPhsMa7PEoL+224/e3aTgFz8N5LJNo2b6jXrt3E2QbU5uX1EISt7lZa
         hzpIiG2vl9zntz+Xy4gZdY3m/YRQhmjdiwEhidL+NEq/9E2Zw0vop6LQy3cnTu2xukxr
         Mevy+PjJzrIcEbI7EcoDfvNpgh73yHrcNoyo1oc06OpwmxLwgPHAQdhOtMqGsbBh0iuX
         shvrkr5Ww4OndYVy2fZhOtzk1tTctMwkG6dthu9oDGcqiMxN1utGAwquvManxechNaft
         42ffhJZltvKAyrx5TPl6VkkisrpG4Lyu4y8P0wCBMrm2hJKKA+/VKx8zQiL1MngDVblI
         10+g==
X-Gm-Message-State: APjAAAW5kZrEyOhEj87QhFbGDxLYf4sDgHWAuddlPAVMRqVk+HiJVRXc
        0NDD/hfYSo3rJNr2u3UETK8=
X-Google-Smtp-Source: APXvYqzJ4i46z+HVCbyvvrqNpzxb5shV8fTyVKbfjxQ6jWhrIuwCwQT4F3ln7bR9FLISB36k3HokTA==
X-Received: by 2002:a5d:660c:: with SMTP id n12mr21893054wru.160.1554796229910;
        Tue, 09 Apr 2019 00:50:29 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id d14sm51766944wro.79.2019.04.09.00.50.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 09 Apr 2019 00:50:29 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 4/5] perf tools, tools lib traceevent: Rename "pevent" member of struct tep_event_filter to "tep"
Date:   Tue,  9 Apr 2019 10:50:23 +0300
Message-Id: <20190409075024.30512-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190409075024.30512-1-tstoyanov@vmware.com>
References: <20190409075024.30512-1-tstoyanov@vmware.com>
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

