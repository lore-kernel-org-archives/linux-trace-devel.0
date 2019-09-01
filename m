Return-Path: <SRS0=bLRU=W4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53190C3A5A4
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Sep 2019 12:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29A7623431
	for <linux-trace-devel@archiver.kernel.org>; Sun,  1 Sep 2019 12:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567340799;
	bh=ujhfe8NgW+/eX4mFsWtaDNiTN6epSJWCNZ8VXJreEtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gN2x3K76TFhVlvENnvJV31LT9nlOtBIVo69ED3MDUgk+Mhj/di62oNv41iiRXMivp
	 AtQKyKu/8IUA3k6PwKphkKRNljlFgJhpI7AnTbKoVFhsio+rgki6smy1xSvOV0TXFv
	 hpgZyr9SSWhgRuZnRmmyc5Hi9zT318rHTNnV310M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfIAMYj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 08:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbfIAMYi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 08:24:38 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.35.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD31623697;
        Sun,  1 Sep 2019 12:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567340676;
        bh=ujhfe8NgW+/eX4mFsWtaDNiTN6epSJWCNZ8VXJreEtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa6Js/6H2U/pR+/sWOclkLeUdtxNHhElVn+pr2j9hxvnJBFOVAHsfyxIU1iP6MjOB
         qUpgmUrNw5OdevDu4UWRTXqkZ9t2DZ6UZPMJe3IcXiYTaZwNWHFvIrIVbrWORA8fIx
         +qh5pd2GzOaZpz0s3N3PQ9oIIEokhs8L+PzLzhXM=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Patrick McLean <chutzpah@gentoo.org>,
        linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/47] libtraceevent: Remove tep_register_trace_clock()
Date:   Sun,  1 Sep 2019 09:22:59 -0300
Message-Id: <20190901122326.5793-21-acme@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190901122326.5793-1-acme@kernel.org>
References: <20190901122326.5793-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

The tep_register_trace_clock() API is used to instruct the traceevent
library how to print the event time stamps. As event print interface if
redesigned, this API is not needed any more.  The new event print API is
flexible and the user can specify how the time stamps are printed.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Patrick McLean <chutzpah@gentoo.org>
Cc: linux-trace-devel@vger.kernel.org
Link: http://lore.kernel.org/linux-trace-devel/20190801074959.22023-3-tz.stoyanov@gmail.com
Link: http://lore.kernel.org/lkml/20190805204355.195042846@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse-local.h |  2 --
 tools/lib/traceevent/event-parse.c       | 11 -----------
 tools/lib/traceevent/event-parse.h       |  1 -
 3 files changed, 14 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-local.h b/tools/lib/traceevent/event-parse-local.h
index 6e58ee1fe7c8..cee469803a34 100644
--- a/tools/lib/traceevent/event-parse-local.h
+++ b/tools/lib/traceevent/event-parse-local.h
@@ -81,8 +81,6 @@ struct tep_handle {
 
 	/* cache */
 	struct tep_event *last_event;
-
-	char *trace_clock;
 };
 
 void tep_free_event(struct tep_event *event);
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d1085aab9c43..bb22238debfe 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -393,16 +393,6 @@ int tep_override_comm(struct tep_handle *tep, const char *comm, int pid)
 	return _tep_register_comm(tep, comm, pid, true);
 }
 
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock)
-{
-	tep->trace_clock = strdup(trace_clock);
-	if (!tep->trace_clock) {
-		errno = ENOMEM;
-		return -1;
-	}
-	return 0;
-}
-
 struct func_map {
 	unsigned long long		addr;
 	char				*func;
@@ -7057,7 +7047,6 @@ void tep_free(struct tep_handle *tep)
 		free_handler(handle);
 	}
 
-	free(tep->trace_clock);
 	free(tep->events);
 	free(tep->sort_events);
 	free(tep->func_resolver);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index cf7f302eb44a..d438ee44289f 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -435,7 +435,6 @@ int tep_set_function_resolver(struct tep_handle *tep,
 void tep_reset_function_resolver(struct tep_handle *tep);
 int tep_register_comm(struct tep_handle *tep, const char *comm, int pid);
 int tep_override_comm(struct tep_handle *tep, const char *comm, int pid);
-int tep_register_trace_clock(struct tep_handle *tep, const char *trace_clock);
 int tep_register_function(struct tep_handle *tep, char *name,
 			  unsigned long long addr, char *mod);
 int tep_register_print_string(struct tep_handle *tep, const char *fmt,
-- 
2.21.0

