Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD2D4C28CF5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239442AbiAZJ5m (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiAZJ5l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:57:41 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F47C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:40 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id s13so37775298ejy.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3snN9fCXIbqsYDCsAS2tERAWPra9RAUNVpdT4Gg8AAQ=;
        b=BmQp2aKJPucoW1Gf3eP6Db56We/S0RBFtnGMKn/BdmWnywLO7AqOOoNX4yQNoVLnMa
         jVRtHRV7jk7cFPJrIeD0aRFuPCmudKm26qyax+Bf1L6trH+oUbOpkCyfZdkrLUO/ZLur
         5CgiYJUYEr5ZAtYwJkneX0Yf8A22Fz5miRRZRyY7Eu/2xcnwWxlHlb1eyoVVelpZrQT3
         IyAHiOwPjcy3LLG8x7AuzN6ULGAGZbp5C8986CNqUHlHxARhdDCK9PuLn21+YHlxtNTA
         lkbFf6iA4wF8XJtGisaZ02e1DK46LjECknBJZ6FeAdm/bV7Bh00Dq+zPJKdq+4eqc+DB
         F/sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3snN9fCXIbqsYDCsAS2tERAWPra9RAUNVpdT4Gg8AAQ=;
        b=3J0KPE3fTT83iCu5Ke6HfYG8O7w9oTrxrWdCOm9tVH9Zi5VDAQ0F4NiSmITcWbSEqt
         Yud43ylmeU6uUmnPCT/5aIgGcAhdXZomD1Lb2LRed8cbATaH8Onf+W5PGsvie1id+m7o
         fRWaE+3mFHeixPx+8hBEsbiQLGhAljTkwbe2QdhPYrybPH7ZtNDotEtWa70rMmcL8Tv4
         CkSmOLfLQIiBRgkOaxKEXN0aqM2qe96cz4KVcjHI2onfH3c9Q91JQHKffT5JPpr+MC5u
         JFWrBG/EMYyTu/RwIBAfrKWkgWEar1M+MsS3pRIjbsptLi+xAUiVIkZRrTWyUSTmo2AS
         1B7w==
X-Gm-Message-State: AOAM530otEPeL9oy5c71xJwIt+yaGPnqWd5VszxqK61x/wmxn1qTbxoC
        VQN/TMgoX7I+gyJwjI53gPttAn4ZOWA=
X-Google-Smtp-Source: ABdhPJyVKz4wrIaw4OwN74Ofx1O2k4XXs0TFYRVPXo5G06eZAR2WBbjEa8YaY+dvb322qWDzrYM46w==
X-Received: by 2002:a17:906:4945:: with SMTP id f5mr19260406ejt.429.1643191059014;
        Wed, 26 Jan 2022 01:57:39 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id j20sm7145299eje.81.2022.01.26.01.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:57:38 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 1/2] trace-cmd library: Use the real trace buffer page size
Date:   Wed, 26 Jan 2022 11:57:34 +0200
Message-Id: <20220126095735.571222-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095735.571222-1-tz.stoyanov@gmail.com>
References: <20220126095735.571222-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When new output handler is created, it assumes that the trace buffer page
size is equal to the system memory page size. This assumption is valid
for the current ftrace implementation, but it may change in the future.
The newly introduced traceevent library API should be used to get the
real trace buffer page size, bases on the information from the
"events/header_page" ftrace file.

This commit depends on:
 [PATCH] libtraceevent: A new API for trace page size
 https://lore.kernel.org/linux-trace-devel/20211001062338.2389024-1-tz.stoyanov@gmail.com/

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 37 +++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e7915aa6..cd40d312 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1299,6 +1299,41 @@ static int write_compression_header(struct tracecmd_output *handle)
 	return 0;
 }
 
+static int get_trace_page_size(struct tracecmd_output *handle)
+{
+	struct tracefs_instance *instance;
+	struct tep_handle *tep = NULL;
+	int psize, size;
+	char *buff = NULL;
+
+	/* In case of an error, return user space page size */
+	psize = getpagesize();
+
+	instance = tracefs_instance_alloc(find_tracing_dir(handle), NULL);
+	if (!instance)
+		goto out;
+
+	buff = tracefs_instance_file_read(instance, "events/header_page", &size);
+	if (!buff)
+		goto out;
+
+	tep = tep_alloc();
+	if (!tep)
+		goto out;
+
+	if (tep_parse_header_page(tep, buff, size, sizeof(long long)))
+		goto out;
+
+	psize = tep_get_sub_buffer_size(tep);
+
+out:
+	tracefs_instance_free(instance);
+	tep_free(tep);
+	free(buff);
+
+	return psize;
+}
+
 /**
  * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
@@ -1323,7 +1358,7 @@ struct tracecmd_output *tracecmd_output_create_fd(int fd)
 
 	handle->file_version = FILE_VERSION_DEFAULT;
 
-	handle->page_size = getpagesize();
+	handle->page_size = get_trace_page_size(handle);
 	handle->big_endian = tracecmd_host_bigendian();
 
 	list_head_init(&handle->options);
-- 
2.34.1

