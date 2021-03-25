Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B785C433E2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3109F61A23
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Mar 2021 06:42:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhCYGle (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Mar 2021 02:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhCYGlC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Mar 2021 02:41:02 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8769BC06174A
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:02 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k8so1121472wrc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 23:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDq4JxpNtg/mIRxKEMjeZkSbCUogjXW4ab8x4Wk8n5Q=;
        b=biTOBMeduNszFl/Z5VoxmfO9qkPNRQe9hTCwyioMgFdQmrlTH0+cKaTu6JvO0J1/oW
         Rrz96JBdirD8LObGWIuM7V7JMXSQoq3PUGbxqUZtQyIel7FcEgBHayrE4a/Vs8kCu+y4
         PkXE3K7x5eWFRR3HNMjaJHRLWbO2QCd8l4AW5sKn52p81wOBqSWeHeBlAyRTvJn1EXiD
         0ZvNFDZkWQ01UwBmeSPvnvpg8DkAkwBVfmPLxTu2EAXw6R2IzLqxMEhRKkrhao6V1qeJ
         4V1FogrqMzXXnX+JNb7M+FaGtnDs/hAKppahVntMDcrqToWNwcdibM4TCkPIS/c/Ssrh
         Gtcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDq4JxpNtg/mIRxKEMjeZkSbCUogjXW4ab8x4Wk8n5Q=;
        b=AuYyRcpOBn6d88fb8m4CX/YY1IV7z7Dw7l7ZqgARFH8hUQMJzTDMgZEZOaAQ+zkjST
         NwUVWBBY3Mq73FTCqG0YqUooOrrTIQbMXCq+PQ7CjyNiFZM88Tm5ZoyCRRZm9xnaGZCU
         8HntPjv1Dw5GBDLkJoKRNsYZUcIuGKkzOQFFpgOpOH1ZJhDJXMz2kMYXUi/taSLxQC7/
         ZyM42SGJSRGuUd4z1s1kET0ttA7r7pReSjuJRo2sPr0rdnZvKx/os0VhoxoHLGWTh2LQ
         F394yRgi0eRGap4qXxltuaTKpqU+4t59y7Z6HqbjkzX+iuDpE30cQloxd7NDxpFB0VVc
         n73g==
X-Gm-Message-State: AOAM530H8kyiMvd9cY9kShQ0BAmWNZzLwKIKqG92X6MToQS/RpvDf62d
        IMaqMhYAlgd0zoqVLfbVd9fKObNAp7ThIQ==
X-Google-Smtp-Source: ABdhPJxHYAuXj3nWmsxffq6u3qzSMMepNisVTCb2TQMdXirrGD4xgkvwyn4QVmVEjxs7ZoNJc6HRoA==
X-Received: by 2002:adf:de91:: with SMTP id w17mr7209370wrl.268.1616654461305;
        Wed, 24 Mar 2021 23:41:01 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e17sm6403259wra.65.2021.03.24.23.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 23:41:00 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/23] trace-cmd: Internal refactoring, move logic for local tep handler in its own function
Date:   Thu, 25 Mar 2021 08:40:36 +0200
Message-Id: <20210325064055.539554-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325064055.539554-1-tz.stoyanov@gmail.com>
References: <20210325064055.539554-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved the logic for initializing a tep handler for ftrace events from
get_date_to_ts() to its own local funciotn, get_ftrace_tep(). That way
the code can be reused in the scope of trace-record.c file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 53 +++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0eb0385..635897e1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4459,52 +4459,59 @@ static char *read_top_file(char *file, int *psize)
 	return tracefs_instance_file_read(top_instance.tracefs, file, psize);
 }
 
+static struct tep_handle *get_ftrace_tep(void)
+{
+	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
+	char *buf;
+	int size;
+	int ret;
+
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep)
+		return NULL;
+	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
+	buf = read_top_file("events/header_page", &size);
+	if (!buf)
+		goto error;
+	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
+	free(buf);
+	if (ret < 0)
+		goto error;
+
+	return tep;
+
+error:
+	tep_free(tep);
+	return NULL;
+}
+
 /*
  * Try to write the date into the ftrace buffer and then
  * read it back, mapping the timestamp to the date.
  */
 static char *get_date_to_ts(void)
 {
-	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
 	unsigned long long min = -1ULL;
 	unsigned long long diff;
 	unsigned long long stamp;
 	unsigned long long min_stamp;
 	unsigned long long min_ts;
 	unsigned long long ts;
-	struct tep_handle *tep;
 	struct timespec start;
 	struct timespec end;
 	char *date2ts = NULL;
-	char *path;
-	char *buf;
-	int size;
 	int tfd;
-	int ret;
 	int i;
 
 	/* Set up a tep to read the raw format */
-	tep = tracefs_local_events_system(NULL, systems);
+	tep = get_ftrace_tep();
 	if (!tep) {
 		warning("failed to alloc tep, --date ignored");
 		return NULL;
 	}
-
-	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
-
-	buf = read_top_file("events/header_page", &size);
-	if (!buf)
-		goto out_pevent;
-	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
-	free(buf);
-	if (ret < 0) {
-		warning("Can't parse header page, --date ignored");
-		goto out_pevent;
-	}
-
-	path = tracefs_get_tracing_file("trace_marker");
-	tfd = open(path, O_WRONLY);
-	tracefs_put_tracing_file(path);
+	tfd = tracefs_instance_file_open(NULL, "trace_marker", O_WRONLY);
 	if (tfd < 0) {
 		warning("Can not open 'trace_marker', --date ignored");
 		goto out_pevent;
-- 
2.30.2

