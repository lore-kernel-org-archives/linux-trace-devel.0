Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7A0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0EBE61108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233975AbhKKPO3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbhKKPO2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:28 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E536AC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id f8so25640737edy.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Am4+85r5pphMq6U5RFqrZJhdEeMNK5Aw59BnYLZDBU=;
        b=OYzI7E1ZjL9gbmhDMkCNxOZGbsRNbya6e3gEdulnxSBvYc+wrGNMxGkQmrOc8PYId0
         8H3aOgSisCfG2DFEKNGXrHDOOxLZxG2npZosjboiBVpeOd8wXUF097x7F7IEq5znhyJC
         QpiG3SSUG01tMJjDftfFZPR11Ezw1EVkns4WtryanPNT1/GieSJARsGdeghKJmD7luqo
         trahIPqKzw3YLF8OJYev7BXVobSnvuhB4nunpJfv/3b35N1+5S8Ymp2GpXqWIkwPFhtu
         X2psprY+ppq7IjCIGZy44+N5mbkffoxaceY0Lt8rs9qdjTk73WIoLVtBWvA7D8TIQ0V9
         vJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Am4+85r5pphMq6U5RFqrZJhdEeMNK5Aw59BnYLZDBU=;
        b=Y5rPIj3QiC9rre7kHjcxxirygX0xrArgt47VtGkAusM2tVDeNvNjOBq80k8kczmra+
         oZmyTUidlIkjj/7Xvy/+G4X3CiVT2U6FeF8JLnqUhNMEOGjVSA+MzI87rnVzqjfE1B78
         SX+so31OLuzMsVR0doZpVnSzYmcw2Po59Z6Zs4u0NdO4DHegVyGSKpc8vJJVGuGBiNi+
         xLZzuYoHT7TT64ncoeEKxidbXh9Q5L5FW6loKu2I+4m13dGrkAVEIP6CQV5Rx/0bW5ul
         rz2EhtR05SGzcPuAr6VByOumACvl/+NUhxlggVw2zx1r5IKpLjxCDViHNIbfW4I1WoYT
         yYug==
X-Gm-Message-State: AOAM532Lms2er4vInipTAMWoeKslRTuXGcowhCkdIqDFjkKBHiXDWxqC
        s1RiLFzaT75FKDHFtY91gc/n0nFBqQd8Ig==
X-Google-Smtp-Source: ABdhPJwu2IY350PbkXL1F0HAJ19YB3KFyGFRZMNnW61KrUld6ByLuKk3H3bxmvaqQSInE422VWcINw==
X-Received: by 2002:a17:907:8a24:: with SMTP id sc36mr9887552ejc.530.1636643497540;
        Thu, 11 Nov 2021 07:11:37 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm967018edu.57.2021.11.11.07.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:11:37 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 23/25] trace-cmd report: Use the new latency API to read data
Date:   Thu, 11 Nov 2021 17:11:31 +0200
Message-Id: <20211111151133.86788-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151133.86788-1-tz.stoyanov@gmail.com>
References: <20211111151133.86788-1-tz.stoyanov@gmail.com>
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

