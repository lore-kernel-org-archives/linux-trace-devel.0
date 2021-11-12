Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15EA6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA8CA60F45
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Nov 2021 04:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhKLEPG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 23:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhKLEPF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 23:15:05 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82579C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:12:15 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id w1so32541003edd.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 20:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b89qfSwccVgQjEv7H9BT2Aesr+JLh5G6is6aiD7EER0=;
        b=UTSrFr46tNv73MmIXvUyRKnS3JnToakvXTCIKpeeIW1ytn4HCaleZumVjIGP/QenXo
         jXvRrZXYSRUtvggKdGmeXqhNQtHLCsF4NXU7+rGrlwDeqtw3BhU/utUROiUY5Z1BGVuc
         gdh6IJVSqCdKvtC3mPRY5v0QVQK2wseMzmAexOOdcbxb9hAD8vBNivi3IpXV2sC4tRTO
         rpL2Tz+AD1LAGsVUVxxC71v6+kvq9uXMI/PKIHBKViiBRX7fLF+I7t+qR0XQaPLGKXzm
         VykNfuDj9V8za1k+ID3EKA917r7/pvgEuiJbVQwTzrcYAgZHJVZkDvTglInceg/zlS1b
         PPcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b89qfSwccVgQjEv7H9BT2Aesr+JLh5G6is6aiD7EER0=;
        b=lkkKlPV20h1WMODqqbeMhgh89PFiipdWVkbaUKImnISHLMNDeR6iENcRwrZV1LFmlq
         jVyq+mabIsckCAZ35Q2IOiB1/PVP4EykuceZi45Rd3gduotfBxSQ6IgcMe95LaziU3KV
         pdzxjsi6HSxbD0Xfp03ZRT/oJRUw62564UL78WATQawaDqx8SApYmws/G1Q/0eCvf6zq
         Ma6Bi1w1nQtinjsQZUeqNN/Z+d7fSaLVVII+WT5S6OOEduijIeXAI2/YzhjlLC/+CFvH
         AfB1wYoDForcFZTitfZLbU5JKagWDUpArJ5tPPGTsr40riyjR7yXhrzfJaXw2s2KlWF0
         BkEg==
X-Gm-Message-State: AOAM531FvSVB2Hg/DK5119vznZcAryav5M6AHu2mlRMBYb8OxuG5FLdD
        fdGs5YwQEGtFp+lUkh8kuClrqwvaCYnAMg==
X-Google-Smtp-Source: ABdhPJwRsnv72Oml1CpYplGzZDGQuHXVA/rwSsNHT/zX9B3hE2N69qAr+1se5Zms807JZHYqVaNPdg==
X-Received: by 2002:a17:906:2a06:: with SMTP id j6mr15842753eje.401.1636690333983;
        Thu, 11 Nov 2021 20:12:13 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id nd22sm2193903ejc.98.2021.11.11.20.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 20:12:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] libtraceevent: A new API for trace page size
Date:   Fri, 12 Nov 2021 06:12:11 +0200
Message-Id: <20211112041211.23458-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, the size of a trace buffer page is equal to the size of the
system memory page. This may change in the future, so this assumption
may not be valid. The proper way to determine the trace buffer page size
is by using the information from "events/header_page" ftrace file:
 ...
 field: char data;	offset:16;	size:4080;	signed:1;
 ...
The trace buffer page size is the size of the "data" filed + its offset.

A new libtraceevent API is introduced, for getting the trace buffer page
size using that formula:
 tep_get_sub_buffer_size()

Note, that some old kernels may not have "events/header_page" file. For
those, the system memory page size is returned.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---

v2 changes:
 - Renamed tep_get_trace_page_size() to tep_get_sub_buffer_size().
 - Handle the old kernels in tep_parse_header_page() instead of in
   tep_get_sub_buffer_size().

 src/event-parse-api.c | 16 ++++++++++++++++
 src/event-parse.c     |  2 ++
 src/event-parse.h     |  1 +
 3 files changed, 19 insertions(+)

diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index f8361e4..f8433e5 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -4,6 +4,7 @@
  *
  */
 
+#include <unistd.h>
 #include "event-parse.h"
 #include "event-parse-local.h"
 #include "event-utils.h"
@@ -248,6 +249,21 @@ void tep_set_page_size(struct tep_handle *tep, int _page_size)
 		tep->page_size = _page_size;
 }
 
+/**
+ * tep_get_sub_buffer_size - get the size of a trace buffer page
+ * @tep: a handle to the tep_handle
+ *
+ * This returns the size of a trace buffer page on the traced machine.
+ * If @tep is NULL then -1 is returned.
+ */
+int tep_get_sub_buffer_size(struct tep_handle *tep)
+{
+	if (!tep)
+		return -1;
+
+	return tep->header_page_data_size + tep->header_page_data_offset;
+}
+
 /**
  * tep_is_file_bigendian - return the endian of the file
  * @tep: a handle to the tep_handle
diff --git a/src/event-parse.c b/src/event-parse.c
index f42ae38..4b67289 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -17,6 +17,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdint.h>
+#include <unistd.h>
 #include <limits.h>
 #include <linux/time64.h>
 
@@ -6905,6 +6906,7 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 		tep->header_page_ts_size = sizeof(long long);
 		tep->header_page_size_size = long_size;
 		tep->header_page_data_offset = sizeof(long long) + long_size;
+		tep->header_page_data_size = getpagesize() - tep->header_page_data_offset;
 		tep->old_format = 1;
 		return -1;
 	}
diff --git a/src/event-parse.h b/src/event-parse.h
index d4a876f..e4ecde5 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -565,6 +565,7 @@ void tep_set_cpus(struct tep_handle *tep, int cpus);
 int tep_get_long_size(struct tep_handle *tep);
 void tep_set_long_size(struct tep_handle *tep, int long_size);
 int tep_get_page_size(struct tep_handle *tep);
+int tep_get_sub_buffer_size(struct tep_handle *tep);
 void tep_set_page_size(struct tep_handle *tep, int _page_size);
 bool tep_is_file_bigendian(struct tep_handle *tep);
 void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
-- 
2.33.1

