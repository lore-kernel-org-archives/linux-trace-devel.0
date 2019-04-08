Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672CAC10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4319320883
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728941AbfDHPXp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:23:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33098 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728820AbfDHPXo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:23:44 -0400
Received: by mail-wr1-f66.google.com with SMTP id q1so16946664wrp.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:23:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9lEhJgnXh1DD480PQKoKs4XeSGPd5WjxyQQRpp6rfVU=;
        b=ZOVzQV+4T3hDCtjIrbxSRy0YbSei/AnV/mS/sz2D+JWjwQVaFJp07QsHI73Fj4zeF9
         4Moni5iueKohaYiXbC5+o4VPL6B067nscLTAsYHrO08uC5vzA5f5i9B7RBW25LmTbsRK
         pWXWKD4Toj5aX/+bHbMXoecJjDHSCtaXoPTpUUASunQtnWzALRs+VDKMZKBr8drXcqJT
         RVeXk4XR0pw2inYwC10uh8Xk+hMMX122GxExK7p6kUwxMjnNzq6eT7FzukZ0+3hVbPzO
         nZDGSEOny5nUYknWkjEuYjmSm9Q2mvdYZMNK8E0qDscF/F7ltABWYATq9k6j8ArpsnAS
         h+8Q==
X-Gm-Message-State: APjAAAVKoa3ogiyTCp3Krr7TalZScJK6utUr1Gb+JqObGZjmuDKaDFOB
        h8t0xJQvmFuVFZCJTlQqaFujvoHh
X-Google-Smtp-Source: APXvYqxs7BRGkLScVs8fOkBx+fcNXoayUbQqZsXPGz22jbaLh6+O5DEPlvZVW3yLq7li4wwc9CM0MQ==
X-Received: by 2002:adf:fcc5:: with SMTP id f5mr20128776wrs.166.1554737023024;
        Mon, 08 Apr 2019 08:23:43 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c6sm11142498wmb.21.2019.04.08.08.23.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Apr 2019 08:23:42 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/10] tools lib traceevent: Change description of few APIs
Date:   Mon,  8 Apr 2019 18:23:31 +0300
Message-Id: <20190408152340.12450-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190408152340.12450-1-tstoyanov@vmware.com>
References: <20190408152340.12450-1-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

APIs descriptions should describe the purpose of the function, its
parameters and return value. While working  on man pages implementation,
I noticed mismatches in the  descriptions of few APIs.  This patch
changes the description of these APIs, making them consistent with the
man pages:

 - tep_print_num_field()
 - tep_print_func_field()
 - tep_get_header_page_size()
 - tep_get_long_size()
 - tep_set_long_size()
 - tep_get_page_size()
 - tep_set_page_size()

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/linux-trace-devel/20190325145017.30246-2-tstoyanov@vmware.com
Link: http://lkml.kernel.org/r/20190401164343.396759247@goodmis.org
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/event-parse-api.c | 16 ++++++++--------
 lib/traceevent/event-parse.c     |  6 ++++--
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/lib/traceevent/event-parse-api.c b/lib/traceevent/event-parse-api.c
index afafbc8..2c70375 100644
--- a/lib/traceevent/event-parse-api.c
+++ b/lib/traceevent/event-parse-api.c
@@ -196,10 +196,10 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
 }
 
 /**
- * tep_get_long_size - get the size of a long integer on the current machine
+ * tep_get_long_size - get the size of a long integer on the traced machine
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a long integer on the current machine
+ * This returns the size of a long integer on the traced machine
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_long_size(struct tep_handle *pevent)
@@ -210,11 +210,11 @@ int tep_get_long_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_set_long_size - set the size of a long integer on the current machine
+ * tep_set_long_size - set the size of a long integer on the traced machine
  * @pevent: a handle to the tep_handle
  * @size: size, in bytes, of a long integer
  *
- * This sets the size of a long integer on the current machine
+ * This sets the size of a long integer on the traced machine
  */
 void tep_set_long_size(struct tep_handle *pevent, int long_size)
 {
@@ -223,10 +223,10 @@ void tep_set_long_size(struct tep_handle *pevent, int long_size)
 }
 
 /**
- * tep_get_page_size - get the size of a memory page on the current machine
+ * tep_get_page_size - get the size of a memory page on the traced machine
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a memory page on the current machine
+ * This returns the size of a memory page on the traced machine
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_page_size(struct tep_handle *pevent)
@@ -237,11 +237,11 @@ int tep_get_page_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_set_page_size - set the size of a memory page on the current machine
+ * tep_set_page_size - set the size of a memory page on the traced machine
  * @pevent: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
- * This sets the size of a memory page on the current machine
+ * This sets the size of a memory page on the traced machine
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 1c52747..a17f4f8 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -6453,7 +6453,8 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns positive value on success, negative in case of an error,
+ * or 0 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event *event, const char *name,
@@ -6485,7 +6486,8 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns positive value on success, negative in case of an error,
+ * or 0 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event *event, const char *name,
-- 
2.20.1

