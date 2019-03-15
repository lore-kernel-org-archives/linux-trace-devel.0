Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A22C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB31A218A5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 08:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfCOIL2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:11:28 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33069 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbfCOIL2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 04:11:28 -0400
Received: by mail-wr1-f65.google.com with SMTP id i8so8568501wrm.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 01:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TJY3A+bGwGLzpuFqVNWo7flZwtrTjkhTU4aajFieNCQ=;
        b=X7YADj0DdodndY5eleizHcxhETiOM7gohZE+Djl4qGBnwDrxCxa4OJUAMfDMCmpFK7
         sS6O0VxWzpRUUgu1ncacy1B/MyylFhVTyLYd6I91GJOzUj2Fx/dDW69oLe4OlQxhPsEI
         nHnl6O/9gavRjpQrr/y+HqJKQNmAQV+yhHZOSM7tTAjQC1OTqu/3NdBFDHuVxL1bYK6s
         HHMAwKltv1n9KBaR3mmXUaKDGld0uIXDIfqgZUwiuW5tBbjMHO4A0PUIxi+7Ua4QB9rb
         SFchh9vwrahrOdiuyaEPdlT0RzQaQTechxme5HIc4xFCRec54dXac9Df2Ty0BMD2DrlG
         vnXQ==
X-Gm-Message-State: APjAAAXV58sdgeahXUYW1PxLugcycw0BCtK9fFcenQL1HPqWZ2SWh3cn
        dhTLZPZUmheoc5DKppgazNfU8avU
X-Google-Smtp-Source: APXvYqxZWr7kEPuy3jciHV9vTHSrpTRr6ocAaYJB/ewE+swq+FshdI793A4DfIF7OARdyac8vPxsoQ==
X-Received: by 2002:a5d:474f:: with SMTP id o15mr1454730wrs.70.1552637485740;
        Fri, 15 Mar 2019 01:11:25 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id a8sm1420405wmh.26.2019.03.15.01.11.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Mar 2019 01:11:24 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4] tools/lib/traceevent: Change description of few APIs
Date:   Fri, 15 Mar 2019 10:11:23 +0200
Message-Id: <20190315081123.21723-1-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

APIs descriptions should describe the purpose of the
function, its parameters and return value. While working
on man pages implementation, I noticed mismatches in the
descriptions of few APIs. This patch changes the description
of these APIs, making them consistent with the man pages:
tep_print_num_field(), tep_print_func_field(),
tep_get_header_page_size(), tep_get_long_size(),
tep_set_long_size(), tep_get_page_size() and
tep_set_page_size().

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
---
 tools/lib/traceevent/event-parse-api.c | 21 ++++++++++++---------
 tools/lib/traceevent/event-parse.c     |  4 ++--
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index d4368dcc16ea..2d5d3642e3e9 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -100,10 +100,10 @@ tep_data2host8(struct tep_handle *pevent, unsigned long long data)
 }
 
 /**
- * tep_get_header_page_size - get size of the header page
+ * tep_get_header_page_size - get the size of a long integer, in kernel context
  * @pevent: a handle to the tep_handle
  *
- * This returns size of the header page
+ * This returns the size of a long integer, in kernel context
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_header_page_size(struct tep_handle *pevent)
@@ -140,10 +140,11 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
 }
 
 /**
- * tep_get_long_size - get the size of a long integer on the current machine
+ * tep_get_long_size - get the size of a long integer on the traced machine
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a long integer on the current machine
+ * This returns the size of a long integer on the machine,
+ * where the trace is generated
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_long_size(struct tep_handle *pevent)
@@ -154,7 +155,7 @@ int tep_get_long_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_set_long_size - set the size of a long integer on the current machine
+ * tep_set_long_size - set the size of a long integer on the traced machine
  * @pevent: a handle to the tep_handle
  * @size: size, in bytes, of a long integer
  *
@@ -167,10 +168,11 @@ void tep_set_long_size(struct tep_handle *pevent, int long_size)
 }
 
 /**
- * tep_get_page_size - get the size of a memory page on the current machine
+ * tep_get_page_size - get the size of a memory page on the traced machine
  * @pevent: a handle to the tep_handle
  *
- * This returns the size of a memory page on the current machine
+ * This returns the size of a memory page on the machine,
+ * where the trace is generated
  * If @pevent is NULL, 0 is returned.
  */
 int tep_get_page_size(struct tep_handle *pevent)
@@ -181,11 +183,12 @@ int tep_get_page_size(struct tep_handle *pevent)
 }
 
 /**
- * tep_set_page_size - set the size of a memory page on the current machine
+ * tep_set_page_size - set the size of a memory page on the traced machine
  * @pevent: a handle to the tep_handle
  * @_page_size: size of a memory page, in bytes
  *
- * This sets the size of a memory page on the current machine
+ * This sets the size of a memory page on the machine,
+ * where the trace is generated
  */
 void tep_set_page_size(struct tep_handle *pevent, int _page_size)
 {
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 8f6ff7e0b51e..e6c7dcc5f3ee 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6441,7 +6441,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns: 1 on success, -1 field not found, or 0 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event *event, const char *name,
@@ -6473,7 +6473,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns: 1 on success, -1 field not found, or 0 if buffer is full.
  */
 int tep_print_func_field(struct trace_seq *s, const char *fmt,
 			 struct tep_event *event, const char *name,
-- 
2.20.1

