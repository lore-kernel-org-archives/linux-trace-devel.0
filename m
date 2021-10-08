Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD5EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F0860F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJHEWV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhJHEWU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:22:20 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D10C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:20:25 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t16so9439300eds.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=nqXf52TcwrcKU2SAETojS/Ltfh7ZA2UWEsS9r+DvdOedTV/ZoQ5QisABlG+KtG1MPt
         OGLPlfmvQFDI2uW5vMyiRC6ZYDGdzTaCkwD/2dyQrsgVlnUdolZZh0of9v9uuZ/2enc6
         3yyFGaT56c0qxUdTlryFEzA5zXmlvwcJmqEzGRo+V1/jZ2WCXlPAcliBgXajVdn1hER8
         HZQh1oxNg+4mXPQh8nOi/Aek3BotUF5YU6gVJYpUquEsEmuZ8MWxYd3dM1D/Zw0KfTht
         CGyTB9H+NnfatmFNMmYk7EJZb0Dtxex4SF8ztHWYmCvgbiVYK7VcYNumUwMloBOkJnIf
         TKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3tPykFm2R2AzWLPxwlstSRNlrsQRpaeRcBxHgbq+Eck=;
        b=46A6Y9RsFvVtDVUhb25pelmX9s1m8BwtLfrNiFM3nSloCeGM2cOt40dY12aBa+SDIn
         yPPqoPrsfEuFLRi6DXm5UEL8YS1G40XmIsiJfgQ4QvBDfpZbL7+AJcVK1OHpnc33VRZ0
         smehlonksLjGUkUphBnp2rYiFhyYVNJjYLYbXpnuiHa6ztJ5eAqEs3m2mtef/GEPf0Xp
         PH6wOyqsAsmjBCFiofR0ly+YHp2fpmrf4fGSQGRv11jvQg+CCNq/O6E18okUO6Jr1Nbm
         3j1kysUw7ZgZb5COrUZafegG6PGyIwyYiMi5Nf+JfkxFgH3b/sWebtSYeirZkwmaU04e
         M59w==
X-Gm-Message-State: AOAM530sybUeSbDbZ2D9nyBKiMCSHhxBMD2VMLJ1kUWuJKGzbOHBdxwO
        FS4YKdSJYqJJNtIYNb33TvI8T+S6zWCSHQ==
X-Google-Smtp-Source: ABdhPJwf9dYRnCc9HbPHW14Rl/JxkYKARCoZwStfWd6a0XDfZ6J09qSLNwhNSV9sh4AECyASHkBTqw==
X-Received: by 2002:a17:907:784f:: with SMTP id lb15mr1254404ejc.260.1633666824470;
        Thu, 07 Oct 2021 21:20:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id p6sm511669edi.18.2021.10.07.21.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:20:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 23/25] trace-cmd report: Use the new latency API to read data
Date:   Fri,  8 Oct 2021 07:19:56 +0300
Message-Id: <20211008041958.976309-24-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041958.976309-1-tz.stoyanov@gmail.com>
References: <20211008041958.976309-1-tz.stoyanov@gmail.com>
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

