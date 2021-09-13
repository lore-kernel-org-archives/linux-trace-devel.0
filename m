Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE0BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6684760F0F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbhIMMb3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240000AbhIMMb3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:31:29 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A2CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id j17-20020a05600c1c1100b002e754875260so6474428wms.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=Aw3LIkljzzwqQABQKXW8HdNfjDQxGdeEOUTmpla8cVGKYfqG+8RSHzv59qu5mFK1UO
         TRawZgiI9X+CC5ksevgZ14oSqXEjFHu/osDHOccHyqtfX3spg42Lim6QSKiO0l9OBvew
         k8CuBEDelS5EiF1nJ3cgJyJxEgOSKlN0bTH/t04+tXLP3rqS4OEgI1JWTKf3Aa1SHS8c
         rBCEsR0/XSg7Eqdae4gzbuAYLFdu5ylgw4uT9BFGURmwI8fmRIwjvrfnpQvvz+UkmQ/3
         bvOB9QC1Khub4ts4IFA0hh9AtoegfXc4V2uolo8GBatFyfuOjHKAPV/0zB5l7u5XHmAO
         lmGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=ZPn+kH+qT4rX5kzVw/l6VfcYCpiAHXQeVUMf7IVC4QwejoN4XMlTGZFwV6Uz+XvuTp
         QQzk3G5FrqPt7GTHeHV+eEiqZraae0BXfB8gaIyu7fnkmkvM1byDjfjxkESKFr5A2lRW
         ETsn5X1onm3jI9nH5ky5BKkbF4rYy6lZ1LIiKvJQT+lDwDyJ5oD5GyaGSObMEpCK8Srg
         6Q+TguEEeinPBKwaackCXH3D6NllaLqzHowWEN1p32+hplc9ReXh4GdfhoXXk8aWKBEX
         PN3uXCaTTf8gdmfrDe4qb1pPeSudj6RbEY6MWTGSpGosIuOoBoG1ekJn7xc1ax7VaZgW
         NxFg==
X-Gm-Message-State: AOAM533KCy8UDt6cSwaV0sIHxYapGkOnO1jCsgskB3ZPyTw7DRAeKWID
        Y3dM1+oLPrXQX+0PdILx5ijeFJ9BDBI=
X-Google-Smtp-Source: ABdhPJyxltmAZPvioE8MtG/BwKi1+5q5o1vkrncqgzV1Jzep33plduwlaC5i1WESljIluJPppGmxLg==
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr10922205wmg.100.1631536211995;
        Mon, 13 Sep 2021 05:30:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z5sm6842030wmf.33.2021.09.13.05.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:30:11 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 23/25] trace-cmd report: Use the new latency API to read data
Date:   Mon, 13 Sep 2021 15:29:45 +0300
Message-Id: <20210913122947.3673239-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
References: <20210913122947.3673239-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading latency trace data, use the new API
 tracecmd_latency_data_read()
It handles reading latency trace data from both version 6 and 7 trace
files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index f7ffb89e..cafceffe 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -948,18 +948,20 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	printf("\n");
 }
 
-static void read_rest(void)
+static void read_latency(struct tracecmd_input *handle)
 {
-	char buf[BUFSIZ + 1];
+	char *buf = NULL;
+	size_t size = 0;
 	int r;
 
 	do {
-		r = read(input_fd, buf, BUFSIZ);
-		if (r > 0) {
-			buf[r] = 0;
-			printf("%s", buf);
-		}
+		r = tracecmd_latency_data_read(handle, &buf, &size);
+		if (r > 0)
+			printf("%.*s", r, buf);
 	} while (r > 0);
+
+	printf("\n");
+	free(buf);
 }
 
 static int
@@ -1243,7 +1245,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.31.1

