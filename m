Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57122C10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 302042148E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbfDHPXt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34641 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728942AbfDHPXs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so16946694wrq.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g8a5Qskv+fJH7q7QZY11MSTqwNWFhu9miqvuSdfRzBg=;
        b=R2Jr7ilJtF4MnoY0Ygd3IZkF2LTDMEgJj+J31S2TsEsIpuEbH9/VNr2rXvhgRs5et9
         0fAXUEkjveFlYiB9P00I1DBRIhVWjQ4/TOFwx47ORDtKD9Sc/FBRYVcu3KiL97ykb70V
         LBIqfvW4BYFLS3eBSU8+yRHH1CpsBbEdcCbweb5ZYy7WgANhfiQzaoq59WAHvKhtzi3N
         o3Jk+b9AACGh3zZyQTWocEdLhA3ZPRcwP26Ptzgk1kGcQSA8vSh2q61npEnW2deHZ4nb
         xBBqNTagmdmAuizgheorLbuX1+KNy49Vzntr2u6f0bhxVUCJFhzLzRuf0LUzLT8Gfj+P
         Ok3g==
X-Gm-Message-State: APjAAAVwFgBApGD6g5ayD2Gmf14b/ZToAoThvV6KH5guW2qF9hRl2BxU
        uxjMrQMLTDk5hEeILFyTncrVCcdl
X-Google-Smtp-Source: APXvYqy8jKFfWGCif1ZUbcH2Gw0BoITUIf5zUW2ZCGnQ2uHN6WlTlOXtpoHhY8OrO54hQyOXslLAsA==
X-Received: by 2002:adf:f110:: with SMTP id r16mr18403354wro.153.1554737026234;
        Mon, 08 Apr 2019 08:23:46 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:45 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 04/10] tools lib traceevent: Remove tep filter trivial APIs
Date:   Mon,  8 Apr 2019 18:23:34 +0300
Message-Id: <20190408152340.12450-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch removes trivial filter tep APIs:

  enum tep_filter_trivial_type
  tep_filter_event_has_trivial()
  tep_update_trivial()
  tep_filter_clear_trivial()

Trivial filters is an optimization, used only in the first version of
KernelShark. The API is deprecated, the next KernelShark release does
not use it.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20190326154328.28718-4-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164343.968458918@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  16 ---
 lib/traceevent/parse-filter.c    | 169 -------------------------------
 2 files changed, 185 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 0ac9e19..12cbed0 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -721,12 +721,6 @@ struct tep_event_filter *tep_filter_alloc(struct tep_handle *pevent);
 #define FILTER_MISS		TEP_ERRNO__FILTER_MISS
 #define FILTER_MATCH		TEP_ERRNO__FILTER_MATCH
 
-enum tep_filter_trivial_type {
-	TEP_FILTER_TRIVIAL_FALSE,
-	TEP_FILTER_TRIVIAL_TRUE,
-	TEP_FILTER_TRIVIAL_BOTH,
-};
-
 enum tep_errno tep_filter_add_filter_str(struct tep_event_filter *filter,
 					 const char *filter_str);
 
@@ -741,9 +735,6 @@ int tep_event_filtered(struct tep_event_filter *filter,
 
 void tep_filter_reset(struct tep_event_filter *filter);
 
-int tep_filter_clear_trivial(struct tep_event_filter *filter,
-			     enum tep_filter_trivial_type type);
-
 void tep_filter_free(struct tep_event_filter *filter);
 
 char *tep_filter_make_string(struct tep_event_filter *filter, int event_id);
@@ -751,15 +742,8 @@ char *tep_filter_make_string(struct tep_event_filter *filter, int event_id);
 int tep_filter_remove_event(struct tep_event_filter *filter,
 			    int event_id);
 
-int tep_filter_event_has_trivial(struct tep_event_filter *filter,
-				 int event_id,
-				 enum tep_filter_trivial_type type);
-
 int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *source);
 
-int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
-			enum tep_filter_trivial_type type);
-
 int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter *filter2);
 
 #endif /* _PARSE_EVENTS_H */
diff --git a/lib/traceevent/parse-filter.c b/lib/traceevent/parse-filter.c
index cb5ce66..4ffd8b2 100644
--- a/lib/traceevent/parse-filter.c
+++ b/lib/traceevent/parse-filter.c
@@ -1522,167 +1522,6 @@ int tep_filter_copy(struct tep_event_filter *dest, struct tep_event_filter *sour
 	return ret;
 }
 
-
-/**
- * tep_update_trivial - update the trivial filters with the given filter
- * @dest - the filter to update
- * @source - the filter as the source of the update
- * @type - the type of trivial filter to update.
- *
- * Scan dest for trivial events matching @type to replace with the source.
- *
- * Returns 0 on success and -1 if there was a problem updating, but
- *   events may have still been updated on error.
- */
-int tep_update_trivial(struct tep_event_filter *dest, struct tep_event_filter *source,
-		       enum tep_filter_trivial_type type)
-{
-	struct tep_handle *src_pevent;
-	struct tep_handle *dest_pevent;
-	struct tep_event *event;
-	struct tep_filter_type *filter_type;
-	struct tep_filter_arg *arg;
-	char *str;
-	int i;
-
-	src_pevent = source->pevent;
-	dest_pevent = dest->pevent;
-
-	/* Do nothing if either of the filters has nothing to filter */
-	if (!dest->filters || !source->filters)
-		return 0;
-
-	for (i = 0; i < dest->filters; i++) {
-		filter_type = &dest->event_filters[i];
-		arg = filter_type->filter;
-		if (arg->type != TEP_FILTER_ARG_BOOLEAN)
-			continue;
-		if ((arg->boolean.value && type == TEP_FILTER_TRIVIAL_FALSE) ||
-		    (!arg->boolean.value && type == TEP_FILTER_TRIVIAL_TRUE))
-			continue;
-
-		event = filter_type->event;
-
-		if (src_pevent != dest_pevent) {
-			/* do a look up */
-			event = tep_find_event_by_name(src_pevent,
-						       event->system,
-						       event->name);
-			if (!event)
-				return -1;
-		}
-
-		str = tep_filter_make_string(source, event->id);
-		if (!str)
-			continue;
-
-		/* Don't bother if the filter is trivial too */
-		if (strcmp(str, "TRUE") != 0 && strcmp(str, "FALSE") != 0)
-			filter_event(dest, event, str, NULL);
-		free(str);
-	}
-	return 0;
-}
-
-/**
- * tep_filter_clear_trivial - clear TRUE and FALSE filters
- * @filter: the filter to remove trivial filters from
- * @type: remove only true, false, or both
- *
- * Removes filters that only contain a TRUE or FALES boolean arg.
- *
- * Returns 0 on success and -1 if there was a problem.
- */
-int tep_filter_clear_trivial(struct tep_event_filter *filter,
-			     enum tep_filter_trivial_type type)
-{
-	struct tep_filter_type *filter_type;
-	int count = 0;
-	int *ids = NULL;
-	int i;
-
-	if (!filter->filters)
-		return 0;
-
-	/*
-	 * Two steps, first get all ids with trivial filters.
-	 *  then remove those ids.
-	 */
-	for (i = 0; i < filter->filters; i++) {
-		int *new_ids;
-
-		filter_type = &filter->event_filters[i];
-		if (filter_type->filter->type != TEP_FILTER_ARG_BOOLEAN)
-			continue;
-		switch (type) {
-		case TEP_FILTER_TRIVIAL_FALSE:
-			if (filter_type->filter->boolean.value)
-				continue;
-			break;
-		case TEP_FILTER_TRIVIAL_TRUE:
-			if (!filter_type->filter->boolean.value)
-				continue;
-		default:
-			break;
-		}
-
-		new_ids = realloc(ids, sizeof(*ids) * (count + 1));
-		if (!new_ids) {
-			free(ids);
-			return -1;
-		}
-
-		ids = new_ids;
-		ids[count++] = filter_type->event_id;
-	}
-
-	if (!count)
-		return 0;
-
-	for (i = 0; i < count; i++)
-		tep_filter_remove_event(filter, ids[i]);
-
-	free(ids);
-	return 0;
-}
-
-/**
- * tep_filter_event_has_trivial - return true event contains trivial filter
- * @filter: the filter with the information
- * @event_id: the id of the event to test
- * @type: trivial type to test for (TRUE, FALSE, EITHER)
- *
- * Returns 1 if the event contains a matching trivial type
- *  otherwise 0.
- */
-int tep_filter_event_has_trivial(struct tep_event_filter *filter,
-				 int event_id,
-				 enum tep_filter_trivial_type type)
-{
-	struct tep_filter_type *filter_type;
-
-	if (!filter->filters)
-		return 0;
-
-	filter_type = find_filter_type(filter, event_id);
-
-	if (!filter_type)
-		return 0;
-
-	if (filter_type->filter->type != TEP_FILTER_ARG_BOOLEAN)
-		return 0;
-
-	switch (type) {
-	case TEP_FILTER_TRIVIAL_FALSE:
-		return !filter_type->filter->boolean.value;
-
-	case TEP_FILTER_TRIVIAL_TRUE:
-		return filter_type->filter->boolean.value;
-	default:
-		return 1;
-	}
-}
-
 static int test_filter(struct tep_event *event, struct tep_filter_arg *arg,
 		       struct tep_record *record, enum tep_errno *err);
 
@@ -2409,14 +2248,6 @@ int tep_filter_compare(struct tep_event_filter *filter1, struct tep_event_filter
 			break;
 		if (filter_type1->filter->type != filter_type2->filter->type)
 			break;
-		switch (filter_type1->filter->type) {
-		case TEP_FILTER_TRIVIAL_FALSE:
-		case TEP_FILTER_TRIVIAL_TRUE:
-			/* trivial types just need the type compared */
-			continue;
-		default:
-			break;
-		}
 		/* The best way to compare complex filters is with strings */
 		str1 = arg_to_str(filter1, filter_type1->filter);
 		str2 = arg_to_str(filter2, filter_type2->filter);
-- 
2.20.1

