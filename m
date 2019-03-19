Return-Path: <SRS0=vzsu=RW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6B9EC10F03
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17D720828
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Mar 2019 11:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfCSLT3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 07:19:29 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37121 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfCSLT3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 07:19:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id y15so20568687wro.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Mar 2019 04:19:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K5TxoNiYuP8LFxE4NWOwT4yZabbiWyeIomT/r9DFxQk=;
        b=FTCoa2xk15dSOyj40g+POG68Zk0WUK0TL/H5+rnchqhIsGc1vEjakr7V822l9+/xeD
         OEfCsOy8QWlnC0ioBJMFKl8Zoj384Qwjtzj25WcMiZkwvCKuDZLZE25LhtcBh+nHs+3a
         NRMDUFaLrsBFutuKv1CMlgdYLhWgYzNwB4l07kzKYJPBCpMjoSt+0wPAyXUkVFRXaPx9
         WwsYY2Jq2Z6hsoM9w4IQOk8UCE8/QZWWXciCf3T3EwAVGq2rMrG4ef0AolVA4D+S1eDQ
         C8st1FvZyHxFbWxLR5tAKESnjWKS8ZvaT4dzoJ4VgjA1TGiWXSPm/MxNhCIHif3+m9D2
         LoEA==
X-Gm-Message-State: APjAAAVKxWiOqYmAQKuCFUpLS8LIH+9MpYWmYjBx0Cw3kVo+myvQExxC
        ViIdO+MrMu09hZlH1Gm3r5A=
X-Google-Smtp-Source: APXvYqxaD/bCTiYAKsUc6OltANEzsVfKnst/s9vioEJVuHmhzxiEO2dB3mJ8hncNgM1BBpi3YjctCw==
X-Received: by 2002:a5d:444d:: with SMTP id x13mr16921181wrr.153.1552994367576;
        Tue, 19 Mar 2019 04:19:27 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id v12sm3064407wml.29.2019.03.19.04.19.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 04:19:26 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/3] tools/lib/traceevent: Change description of few APIs
Date:   Tue, 19 Mar 2019 13:19:22 +0200
Message-Id: <20190319111924.17443-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190319111924.17443-1-tstoyanov@vmware.com>
References: <20190319111924.17443-1-tstoyanov@vmware.com>
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
 tools/lib/traceevent/event-parse-api.c | 20 ++++++++++----------
 tools/lib/traceevent/event-parse.c     |  4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/lib/traceevent/event-parse-api.c b/tools/lib/traceevent/event-parse-api.c
index d463761a58f4..3686a221e981 100644
--- a/tools/lib/traceevent/event-parse-api.c
+++ b/tools/lib/traceevent/event-parse-api.c
@@ -43,8 +43,8 @@ int tep_get_events_count(struct tep_handle *tep)
  * @flag: flag, or combination of flags to be set
  * can be any combination from enum tep_flag
  *
- * This sets a flag or mbination of flags  from enum tep_flag
-  */
+ * This sets a flag or combination of flags from enum tep_flag
+ */
 void tep_set_flag(struct tep_handle *tep, int flag)
 {
 	if(tep)
@@ -140,10 +140,10 @@ void tep_set_cpus(struct tep_handle *pevent, int cpus)
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
@@ -154,11 +154,11 @@ int tep_get_long_size(struct tep_handle *pevent)
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
@@ -167,10 +167,10 @@ void tep_set_long_size(struct tep_handle *pevent, int long_size)
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
@@ -181,11 +181,11 @@ int tep_get_page_size(struct tep_handle *pevent)
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
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 87494c7c619d..69af77896283 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -6386,7 +6386,7 @@ int tep_get_any_field_val(struct trace_seq *s, struct tep_event *event,
  * @record: The record with the field name.
  * @err: print default error if failed.
  *
- * Returns: 0 on success, -1 field not found, or 1 if buffer is full.
+ * Returns: 1 on success, -1 field not found, or 0 if buffer is full.
  */
 int tep_print_num_field(struct trace_seq *s, const char *fmt,
 			struct tep_event *event, const char *name,
@@ -6418,7 +6418,7 @@ int tep_print_num_field(struct trace_seq *s, const char *fmt,
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

