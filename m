Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F9FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Nov 2021 04:22:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243304AbhKZEZk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Nov 2021 23:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358593AbhKZEXj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Nov 2021 23:23:39 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5AAC06175B
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Nov 2021 19:46:10 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o20so32885849eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Nov 2021 19:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bVi87EES+MUmywceTs5rlcbWOAwG716NpeAX0w5rzDk=;
        b=ZBmeJyto/mWURl4osb/XSARGPSrjDH2rFNIivpCMHNGg6zS/9ih/QXTubLEa6wExab
         dkF17G4MeCfTpTACMuvd1JGUEpViG6stz5p89Ejy0W2d+gfXFLeqWzoWqoi0qgDgIF5k
         Sb9XbOFlhELJSdwGIqoIyI9zoiH9d7aAOhZZniYxXdkDY0aJo9IRSdiKKCLWO+dLY6WQ
         dTBzacnMmP522B7JRirUTtU6h1HexnG3tRth/yijINzN9HQqlLQVcswhGfDzrdfbBZwq
         7iwV/wD4wvSSGDhTYK0dLWuUFGncEBn9clQiUhn1FU/L8aiWZIvIlTHn1PQzPG0ly+oA
         nr1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bVi87EES+MUmywceTs5rlcbWOAwG716NpeAX0w5rzDk=;
        b=X64KoKp2A/vi+yn7pkwxuhA6DTArAcw/PxNBMG2l7v/BJm/kVFRzqV8wg91HjO8fsf
         q/mwcJoGlL16V7jcqn6vnwyMIwHLfmYE0ckiCMJsf/47Bpm9YJG/QjuyNJzgtuvmXbXK
         8Za1zc2QpcVczojJPcmuTRq9ujNz/dnq8RLNRZ3tciJ3DvKT9gxQZr3+qH/qz35NMCLh
         JgnP6SINsF/5THIjRBchHuKSA6OQ9WljGKeD8Hvt4VoBtyFA4PdeJKvlfIryd82n1kV5
         gG9TxNsiwhn4quesM5PByjLAE69ed1s03ZNFRoSqIEO2Wpm0bwiUWjbRofapCIOdF/lC
         8o3w==
X-Gm-Message-State: AOAM5319fACar8HvHk4mKwgtlRkY1LhmJ4rvfRJiC6OKGe6uKnibC/tu
        6S5o/hMsgKVOYgHDrMHyNFK0JU0r8+BceQ==
X-Google-Smtp-Source: ABdhPJwNBT41au20r/7swFbng1ciloeFyZzwUaT+NMcCxmSVt1pGEg6iPDroCNr/JdGgvzKBVYMsog==
X-Received: by 2002:a05:6402:170a:: with SMTP id y10mr45157981edu.324.1637898368852;
        Thu, 25 Nov 2021 19:46:08 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u16sm2981158edr.43.2021.11.25.19.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 19:46:08 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3] libtraceevent: A new API for trace page size
Date:   Fri, 26 Nov 2021 05:46:06 +0200
Message-Id: <20211126034606.190816-1-tz.stoyanov@gmail.com>
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

v3 changes:
 - Removed unneeded unistd.h include.
v2 changes:
 - Renamed tep_get_trace_page_size() to tep_get_sub_buffer_size().
 - Handle the old kernels in tep_parse_header_page() instead of in
   tep_get_sub_buffer_size().

 src/event-parse-api.c | 15 +++++++++++++++
 src/event-parse.c     |  2 ++
 src/event-parse.h     |  1 +
 3 files changed, 18 insertions(+)

diff --git a/src/event-parse-api.c b/src/event-parse-api.c
index f8361e4..a765a68 100644
--- a/src/event-parse-api.c
+++ b/src/event-parse-api.c
@@ -248,6 +248,21 @@ void tep_set_page_size(struct tep_handle *tep, int _page_size)
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
index e3bf87b..34d6c96 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -17,6 +17,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <stdint.h>
+#include <unistd.h>
 #include <limits.h>
 #include <linux/time64.h>
 
@@ -7029,6 +7030,7 @@ int tep_parse_header_page(struct tep_handle *tep, char *buf, unsigned long size,
 		tep->header_page_ts_size = sizeof(long long);
 		tep->header_page_size_size = long_size;
 		tep->header_page_data_offset = sizeof(long long) + long_size;
+		tep->header_page_data_size = getpagesize() - tep->header_page_data_offset;
 		tep->old_format = 1;
 		return -1;
 	}
diff --git a/src/event-parse.h b/src/event-parse.h
index db8bc6d..9723406 100644
--- a/src/event-parse.h
+++ b/src/event-parse.h
@@ -573,6 +573,7 @@ void tep_set_cpus(struct tep_handle *tep, int cpus);
 int tep_get_long_size(struct tep_handle *tep);
 void tep_set_long_size(struct tep_handle *tep, int long_size);
 int tep_get_page_size(struct tep_handle *tep);
+int tep_get_sub_buffer_size(struct tep_handle *tep);
 void tep_set_page_size(struct tep_handle *tep, int _page_size);
 bool tep_is_file_bigendian(struct tep_handle *tep);
 void tep_set_file_bigendian(struct tep_handle *tep, enum tep_endian endian);
-- 
2.33.1

