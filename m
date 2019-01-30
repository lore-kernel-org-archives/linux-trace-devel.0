Return-Path: <SRS0=bjmZ=QG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B42BAC282D7
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E1BF20857
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Jan 2019 10:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfA3Kod (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Jan 2019 05:44:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38765 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfA3Kod (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Jan 2019 05:44:33 -0500
Received: by mail-wr1-f65.google.com with SMTP id v13so25440759wrw.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Jan 2019 02:44:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X1p0J0O2F41sMT9Os/4Rv1FgYkr1f9hXI6aZCcKN5+I=;
        b=hNQ2ExpGWVHuwpuUiMJo+MfKx1JLdRDRDfImwzwJbi52jHzRNn+NijZ89daRAGqH7e
         fYpZJmOJGCs83EMuwHaaJStfuBYfeq++O/yU4vdCKi4PjxJ+l6Qp8Bk/028wgoYtgIzK
         VV+FVQ6Xgy6l56Q8amcB0RwDgPsaXxLU5/DbwekWc98Y5nTyXSavFDPxCnaoT8KNuNJr
         gCUu7aH5ez0PM+Tw8q5cUHuzTr4sSSl2ti6qfh1aHBJ14bvvNW+g8nCkRKS+FFcVtt5q
         +cZjw5ZYAk/xXxG4/xwIzLsOyPGsvPG4TZi/eFl8BOPtGDyijjFs93gOejCQ0VtgFRyh
         ockw==
X-Gm-Message-State: AJcUukdw6uiHqNEfLoaz1d6bytMhoMSQ/a3pobtG0/pzG9GQRmrmwFMc
        r7pFbzRpNlPDSIKbXhGwxEd4fC1Q
X-Google-Smtp-Source: ALg8bN6O2ddklWrslx8X4l0z7yp9qJKpE7nzQb5NE38LtOUICG/Q+UgPV7KxGkRd2hFgzDIUia1X9A==
X-Received: by 2002:adf:8544:: with SMTP id 62mr30955120wrh.1.1548845071752;
        Wed, 30 Jan 2019 02:44:31 -0800 (PST)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w12sm503079wrr.23.2019.01.30.02.44.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Jan 2019 02:44:31 -0800 (PST)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/6] trace-cmd: Changed return logic of tep_register_event_handler() API
Date:   Wed, 30 Jan 2019 12:44:23 +0200
Message-Id: <20190130104425.8813-5-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130104425.8813-1-tstoyanov@vmware.com>
References: <20190130104425.8813-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In order to make libtraceevent into a proper library, its API
should be straightforward.

The tep_register_event_handler() functions returns -1 in case it
successfully registers the new event handler. Such return code is used
by the other library APIs in case of an error.

To unify the return logic of tep_register_event_handler() with the other
APIs, this patch introduces enum tep_reg_handler, which is used by this
function as return value, to handle all possible successful return
cases.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20181201040852.628034497@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/traceevent/event-parse.h |  5 +++++
 lib/traceevent/event-parse.c     | 10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
index 426b7eb..b4fa2c7 100644
--- a/include/traceevent/event-parse.h
+++ b/include/traceevent/event-parse.h
@@ -473,6 +473,11 @@ int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event *event, const char *name,
 			 struct tep_record *record, int err);
 
+enum tep_reg_handler {
+	TEP_REGISTER_SUCCESS = 0,
+	TEP_REGISTER_SUCCESS_OVERWRITE,
+};
+
 int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
 			       tep_event_handler_func func, void *context);
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 1f1821d..8cdb5a3 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6699,6 +6699,12 @@ static struct tep_event *search_event(struct tep_handle *pevent, int id,
  *
  * If @id is >= 0, then it is used to find the event.
  * else @sys_name and @event_name are used.
+ *
+ * Returns:
+ *  TEP_REGISTER_SUCCESS_OVERWRITE if an existing handler is overwritten
+ *  TEP_REGISTER_SUCCESS if a new handler is registered successfully
+ *  negative TEP_ERRNO_... in case of an error
+ *
  */
 int tep_register_event_handler(struct tep_handle *pevent, int id,
 			       const char *sys_name, const char *event_name,
@@ -6716,7 +6722,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 
 	event->handler = func;
 	event->context = context;
-	return 0;
+	return TEP_REGISTER_SUCCESS_OVERWRITE;
 
  not_found:
 	/* Save for later use. */
@@ -6746,7 +6752,7 @@ int tep_register_event_handler(struct tep_handle *pevent, int id,
 	pevent->handlers = handle;
 	handle->context = context;
 
-	return -1;
+	return TEP_REGISTER_SUCCESS;
 }
 
 static int handle_matches(struct event_handler *handler, int id,
-- 
2.20.1

