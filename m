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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAA9C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4392060200
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Apr 2021 07:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhDVHSE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Apr 2021 03:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbhDVHSB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Apr 2021 03:18:01 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5518C06174A
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:25 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r20so17451097ejo.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 22 Apr 2021 00:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nLfqYVJ5ReZHuveY230oy9gX5PfHumKgd17jA78/AkQ=;
        b=O5Dj1MTe50B+FcVFzpBirRwrbcf849Rwr7YU1UZkCRyB7Tuej1wyBWwqyIoQlUrizI
         oeVQutzQTnloZS2CWkndwSAgg3EhPz4+GfDHT2b2QVdaNrc4oLn9nBXZ90YoH56mQl6g
         E4uIFYy3p3tDhITe6kmmapHlJJtYbpAVXf8aSKewdnitXDNOh5gmL7Pcg78SkYILiLdZ
         +YrRdlTNWSJ2fE2+dbZomVhtqTmCoso69JexDhnxqFWVZcDUF5dJEXlDeWEVsK7E67fk
         RVK1R5VnsyAlj7BvbyXjdgXAoIznFEGZAtoCN9LOrcxcjaEkz8ElnFb9DRUjoBG5d8/1
         rMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLfqYVJ5ReZHuveY230oy9gX5PfHumKgd17jA78/AkQ=;
        b=eC38wQh7lfbttQhe6NFmOT0ToF9ZkNy3Jv7Ua2Fut7O0Y3vtvcLtX4q9rLszkpqqkZ
         z7YJ1cPyDGjBWgS7nDthYlYgDDYZJVZnZ/7Ll40z/uT522lICAXp045S8RCXVDpSCYOV
         txKzGMO60kYej2WtjZJeUlc/1SjkFppCBeiMwROvzZ4qUxgfV6JsfZ5xDcMTizMWJGbS
         JTphgS2cZnyNX/YwTQ57s3WdhVW2VY2YQL3wtVJBaOPdw8NVuTEqWJxU9TQCv7gzVi+1
         u4zKNztRYdSqKeJk+bya7Nvqz2Q3bgmzxprseSEWw+7AVySmwiBKipdoOyF+LZ6g+utY
         ewgQ==
X-Gm-Message-State: AOAM533yRbUlZpl3YC4Mq0jBPr4vTDNCD2ktzlJE4cS/FWBN6wIoPF7F
        iY4nNlZhGVUBodkUGtAYJFyxwFL3Xk/67A==
X-Google-Smtp-Source: ABdhPJzosOBMc3EFYcbpTl54AIg0y9xVmQ9i2eajQztTJ2ui4oNw8O8helOJ+Gem/1O+9S9ptkmnaQ==
X-Received: by 2002:a17:906:b191:: with SMTP id w17mr1915324ejy.200.1619075844419;
        Thu, 22 Apr 2021 00:17:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k19sm1193958ejk.117.2021.04.22.00.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 00:17:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 3/6] trace-cmd library: Select the file version when writing trace file
Date:   Thu, 22 Apr 2021 10:17:15 +0300
Message-Id: <20210422071718.483383-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210422071718.483383-1-tz.stoyanov@gmail.com>
References: <20210422071718.483383-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new output handler to trace file is allocated, select the proper
file version. If this output handler is based on an existing input trace
file handler, inherit the trace file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index a4a1eecc..dab07392 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -57,6 +57,7 @@ struct tracecmd_output {
 	int			nr_options;
 	bool			quiet;
 	unsigned long		file_state;
+	unsigned long		file_version;
 	struct list_head	options;
 	struct tracecmd_msg_handle *msg_handle;
 	char			*trace_clock;
@@ -907,6 +908,17 @@ out_free:
 	return ret;
 }
 
+static int select_file_version(struct tracecmd_output *handle,
+				struct tracecmd_input *ihandle)
+{
+	if (ihandle)
+		handle->file_version = tracecmd_get_file_version(ihandle);
+	else
+		handle->file_version = FILE_VERSION;
+
+	return 0;
+}
+
 static struct tracecmd_output *
 create_file_fd(int fd, struct tracecmd_input *ihandle,
 	       const char *tracing_dir,
@@ -933,6 +945,9 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 
 	handle->msg_handle = msg_handle;
 
+	if (select_file_version(handle, ihandle))
+		goto out_free;
+
 	list_head_init(&handle->options);
 
 	buf[0] = 23;
@@ -943,7 +958,8 @@ create_file_fd(int fd, struct tracecmd_input *ihandle,
 	if (do_write_check(handle, buf, 10))
 		goto out_free;
 
-	if (do_write_check(handle, FILE_VERSION_STRING, strlen(FILE_VERSION_STRING) + 1))
+	sprintf(buf, "%lu", handle->file_version);
+	if (do_write_check(handle, buf, strlen(buf) + 1))
 		goto out_free;
 
 	/* get endian and page size */
@@ -1602,6 +1618,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->pevent = tracecmd_get_tep(ihandle);
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
+	handle->file_version = tracecmd_get_file_version(ihandle);
 	list_head_init(&handle->options);
 
 	tracecmd_close(ihandle);
-- 
2.30.2

