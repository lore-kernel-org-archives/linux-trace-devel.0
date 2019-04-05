Return-Path: <SRS0=Gl8V=SH=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689CBC4360F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4083321850
	for <linux-trace-devel@archiver.kernel.org>; Fri,  5 Apr 2019 14:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730024AbfDEODj (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:03:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36804 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfDEODi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 10:03:38 -0400
Received: by mail-wr1-f68.google.com with SMTP id y13so8191723wrd.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 05 Apr 2019 07:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yx4U2caucgn7VPFY/CP5G2pGg2ygOwTDd7MpsLfiiVg=;
        b=YRIYuL3YRpfA03szK2XJICOqPxu66AvZOCG9taBVkkzlQb+toLLXkxvDYx9kCw8sHZ
         Sok+qiGLg0q2rO7zjkP1d+p9QbUo0P2IPicIHyRKPwq9ntT3MidXL9D/CnfvqmXhE75u
         ikyhrCm1R7Eai+YIpZF5Jzfo4yD4R0MyKml/kK5+At0bkbPat8/nx74TI1DTXxVDEPuj
         EphAcOrHhULeSeUkEWToKnayb5Yhy2duJZxHnttYXalFJOuD5HuYwvB9LMYCC2CfD/Nx
         hsMpKjPZEPFkZR50XeswcTuI3KE1SnULAFbS69Ps6xBHdBr7i195kS4TcwrGx0gT11I3
         ZiYw==
X-Gm-Message-State: APjAAAXjqWApzbvvt/y+QlVMpJsJYA58CA3oi5hXhGO5LTFZDNM6HOZm
        2M6BAX7uGceHGWT96BMDT80=
X-Google-Smtp-Source: APXvYqwtziKbyhqu+0d83UIuAuqiK0a2zaTYJc4DMYNxEuZ5QXfnAK7j69PTTU8aisGJ+IaD2LjJtw==
X-Received: by 2002:a5d:4a4d:: with SMTP id v13mr8780225wrs.169.1554473016206;
        Fri, 05 Apr 2019 07:03:36 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w16sm29604647wrt.84.2019.04.05.07.03.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 05 Apr 2019 07:03:35 -0700 (PDT)
From:   Tzvetomir Stoyanov <tstoyanov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/10] tools lib traceevent: Change description of few APIs
Date:   Fri,  5 Apr 2019 17:03:23 +0300
Message-Id: <20190405140332.10949-2-tstoyanov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190405140332.10949-1-tstoyanov@vmware.com>
References: <20190405140332.10949-1-tstoyanov@vmware.com>
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
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flore.kernel.org%2Flinux-trace-devel%2F20190325145017.30246-2-tstoyanov%40vmware.com&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C3b44631f578a4d8a5b3608d6b7853784%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180144439785&amp;sdata=nINtsUCGUkVHkl9DapMX%2B5xr7wBfKgGnv7u9Il1MAkk%3D&amp;reserved=0
Link: https://nam04.safelinks.protection.outlook.com/?url=http%3A%2F%2Flkml.kernel.org%2Fr%2F20190401164343.396759247%40goodmis.org&amp;data=02%7C01%7Ctstoyanov%40vmware.com%7C3b44631f578a4d8a5b3608d6b7853784%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C636898180144449793&amp;sdata=9yza8O7RPZhTp8W61gj9RRACu%2Fd9lQoX1Tv%2FEorOyOM%3D&amp;reserved=0
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

