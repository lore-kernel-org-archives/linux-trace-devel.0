Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF9CFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346844AbhLBM0W (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358122AbhLBMZj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:25:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EE8C0613E0
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:22:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y13so115182545edd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Am4+85r5pphMq6U5RFqrZJhdEeMNK5Aw59BnYLZDBU=;
        b=UEDcHmJGmok9qbSj+eY80nK0ca6bcDXGqV/x4OaWoojp4mjS1BLXZv/LrSKZrqbm3A
         MUJjAH+WxilKF4ptUBEI4MpfE8l8fRfwdjRXDvOltqHwmvJptzpOqTRWkqS3fF/43iQX
         av+GNmTKt1qs5Yr/v4JaxGERwB9X1hiqLNpPV2REd2HLxT0qD4A2vFr89N6zANBiNZ2O
         CcCFyQ4JPkVMQ9/waXmckxGxBvtjQL6t4FtPsNgB5XkWgKzmsbUpc4cJp0aBr6siKqda
         If0ureQGHPqH+U5TmXlAkYUzwMmkF965/I34UXPk797NdFeFGZfe6iy82bU6z7HW7EOJ
         Zhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Am4+85r5pphMq6U5RFqrZJhdEeMNK5Aw59BnYLZDBU=;
        b=65Y4l9XWtdvx8ymCOt4gGNbjhWx24UKaALfU4UqxRMMfwlntkSkTAeI9CyBtHl7r1F
         I43KFRau4KqCe9qbbkh2+Q1ly86ASNma1y9xct663DtlM9JnMG9rr5t3fWcF3Ha5XwPn
         mL5RY7Q0mCqqdnxF1pCp1N/7mw+qD1IXXFp5+hcd4Mr4fTJPvwSLCO6EG1APEhgD00lU
         tJlFPuBPh0ooMFcwTtWCstpr5T+Y901okmfaY8vTFqGNS3SuS8QxOizBxW3dMom9nZZC
         /btLMNgQ0DOGvtEsca1h7FLKXA2eaL6+ocXSYLMPWQZwx7Huefu42h+AOQUpkKIjz9U6
         AF4Q==
X-Gm-Message-State: AOAM530huWfqIPTMoOBhSIz54OG8PQkqytChTi9wWcEArRoZPV8lG8Ub
        SSCTR+Portej/bopdHAzFVAn3TFCQbCv0w==
X-Google-Smtp-Source: ABdhPJxIFBLC03SByrPSKNwC5QzKEmGCuKMqJfAylyC4qqbI1FSLBrdVPcK9odd74RLqaVn560Jkww==
X-Received: by 2002:a05:6402:147:: with SMTP id s7mr17133582edu.8.1638447735156;
        Thu, 02 Dec 2021 04:22:15 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb42sm1892772ejc.49.2021.12.02.04.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:22:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 21/23] trace-cmd report: Use the new latency API to read data
Date:   Thu,  2 Dec 2021 14:21:50 +0200
Message-Id: <20211202122152.43275-22-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122152.43275-1-tz.stoyanov@gmail.com>
References: <20211202122152.43275-1-tz.stoyanov@gmail.com>
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
2.33.1

