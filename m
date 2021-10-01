Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD42C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 388E461A58
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhJAGZ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 02:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbhJAGZZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 02:25:25 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF94C06176A
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Sep 2021 23:23:42 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v18so30203837edc.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Sep 2021 23:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Am2NEuYv6uXZhBNv2vkfHbE0eSGkjgzb5C6QgF7qyMU=;
        b=RPvtksEGLI1rq4DiDrn2c5aRGbeBkZJigXSUYjh+OKuvcyWd7DSgzmt/cmSOvptDVh
         2aRxi/Exm+2XrHxvhbBVLnuRWvMLNQhlpVA3unRJntgj1HhkIjYFUogULyGfwVlyg0dC
         ruJpeFAnIwR7Cw6DOdkM1lByD3ccXcNRZQ8oUT6gJDE7KkLTVXUrVDx5H3jSej3hzo6I
         OJKEhAXsNXvezsb+GD1c2bC7dTZ6td7vqy4aOoQDizrBDSWFYdX8zkq678h7zCuoD0Fd
         IFKONX0Q9YToyxX8gMwnwkNRcOhI0z+/o0fb2nvVMj4YXm4gXuM1PskqWX7gLw6vg/+4
         NSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Am2NEuYv6uXZhBNv2vkfHbE0eSGkjgzb5C6QgF7qyMU=;
        b=5pc43fTC24CUDkCd058dLD0kPSYBD4NOQGNRK5K57Couyp4c0I1v7znyDvpCOrruVw
         NwpiFAB2tvmef/3Fs+mLLnTo7JYK5343z8uGyQvJX5UARC9ZjaEjUiDE4hMQFIFMq0jC
         p6asFkv2YDCqhujxxPdUP2nKfYo8PrziTsiBcJVUojisteEkWPI7WyX442bpxOjamwrR
         lSyM+NO2KEK7DeHblnSCNxGurDBOEuM06qjg2heSWvlggGXBerdKSR4fKmMiV2ayqDeL
         lmwj5yVJc0ZA+0bzN0u3TnLf/JrPSmKkYLgd3jE5We1CErhLG4JQr8wHXVIee6lqmtY3
         zUVw==
X-Gm-Message-State: AOAM532mPjNYNDBunG1QJ0PE4euiZEemp362SktfGHrMazK1l48fF0BC
        tXZ5yXl6uiLpvbM2LXlzEPC4deKFfdj9dw==
X-Google-Smtp-Source: ABdhPJzQoHCuDzMA7IEJ771OnCJj7Opa0Jpl6gRAWavNq6dIM4DOB/p0rGw5TjXl+hcqVMg2ZEkYxQ==
X-Received: by 2002:a50:e043:: with SMTP id g3mr12454700edl.196.1633069420621;
        Thu, 30 Sep 2021 23:23:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k20sm2406806ejd.33.2021.09.30.23.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 23:23:40 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtraceevent: A new API for trace page size
Date:   Fri,  1 Oct 2021 09:23:38 +0300
Message-Id: <20211001062338.2389024-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Currently, the size of a trace buffer page is equal to the system memory
page size. This may change in the future, so this assumption may not be
valid. The proper way to determine the trace buffer page size is by
using the information from "events/header_page" ftrace file:
 ...
 field: char data;	offset:16;	size:4080;	signed:1;
The trace buffer page size is the size of the "data" filed + its offset.

A new libtraceevent API is introduced, for getting the trace buffer page
size using that formula:
 tep_get_trace_page_size()

Note, that some old kernels may not have "events/header_page" file. For
those, the API returns the system memory page size.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/event-parse-api.c | 16 ++++++++++++++++
 src/event-parse.h     |  1 +
 2 files changed, 17 insertions(+)

diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index f8361e4..b5be8d3 100644
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
+ * tep_get_trace_page_size - get the size of a trace page on the traced machine
+ * @tep: a handle to the tep_handle
+ *
+ * This returns the size of a trace page on the traced machine
+ * If @tep is NULL or the kernel is old, user space page size is returned.
+ */
+int tep_get_trace_page_size(struct tep_handle *tep)
+{
+	if (tep && !tep->old_format)
+		return tep->header_page_data_size + tep->header_page_data_offset;
+
+	return getpagesize();
+}
+
 /**
  * tep_is_file_bigendian - return the endian of the file
  * @tep: a handle to the tep_handle
diff --git a/src/event-parse.h b/src/event-parse.h
index 0833893..ea8df35 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -572,6 +572,7 @@ void tep_set_cpus(struct tep_handle *tep, int cpus);
 int tep_get_long_size(struct tep_handle *tep);
 void tep_set_long_size(struct tep_handle *tep, int long_size);
 int tep_get_page_size(struct tep_handle *tep);
+int tep_get_trace_page_size(struct tep_handle *tep);
 void tep_set_page_size(struct tep_handle *tep, int _page_size);
 bool tep_is_file_bigendian(struct tep_handle *tep);
 void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
-- 
2.31.1

