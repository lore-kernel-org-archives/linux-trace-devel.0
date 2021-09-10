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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180B9C43217
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F173F611CC
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhIJNwi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:37 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C44C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:26 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id t19so4385945ejr.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=Ew988KLEqSnWryE3g9p5rbkZLyY03+oY5XTly3XHmvQhOayfALgemZMwUGdFf377b6
         0j7AfnzowLd5C+9Vc+lgV34jaKRD1PeEzNx807Kw6l18xGfo380nPl7gouBHgisbfBai
         N9OvagmFsB/HcfRa67eSV5A0kXKiTFgICM+piC6ATrevQelxKrkP9alEMcBmH7V3H5E9
         gTi/RvtmIobMuNLP8rorPAhrlBL5a0EnMkl3JSZvGiqlgo1o3yWRISTZf/yFqpwEJmbi
         bocsAWxhGGt8r9IL81bTrzquKrfqGliMU5lUUID0nOEtUKovFM5/a9o6CK6zkpmQyIwc
         9MzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=cF6J3HrCvWR5dQWPU+J6sUs0vD0ShH8DorgTW2ZwoLwglbREx2sXnDLYoO1OR19R8L
         ZMQFKGJyMPtyXq8gogISwUSa2bvhcXRofv7tIjLpF/wOqLz8sDECXTA3jFOjdc9v8TW7
         /FhNl88lVJauP5vrAw9jTsWMnDJEZycHwl+N1MjliD9NPt7IZHkAHeGlph5jjHx+ZAJx
         IzcN63+U/XEkKeUkpLMOViwCGk7QPhacOeAs4T4SwKuHtVyBBprsqde55fCeLUoOSiPX
         vla1CvDNlYtPdNpwx8qwd4uPQTcFnHdCfnMjkeO1k2rRJ4up0wdJZt8TM3h7sYZzo2qP
         j5ww==
X-Gm-Message-State: AOAM533nzIJeDw2SGZiE9D4XfRDxDZqZjuhzzxtEUh3Ntfy8lTg3ezAY
        +7zWORVzFOEvYmsO2pieXtJKYI6VSbw=
X-Google-Smtp-Source: ABdhPJyaonbxU9YuVv+GwmuQ2gS4Sm4XzCDK+54XUboNQw7gf/r2pyHkfdIJ2kj/4m53RlFGGOHorQ==
X-Received: by 2002:a17:906:914e:: with SMTP id y14mr9586219ejw.223.1631281885296;
        Fri, 10 Sep 2021 06:51:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 23/25] trace-cmd report: Use the new latency API to read data
Date:   Fri, 10 Sep 2021 16:50:59 +0300
Message-Id: <20210910135101.2865226-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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

