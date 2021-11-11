Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6ABC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 332F261058
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbhKKPKR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbhKKPKQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:16 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F122C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:27 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id g14so25425968edz.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TU1BhuiDlEROr6TrgpWz7vlQmFpSa5IVdhHp5EhPeXQ=;
        b=hJPKImFXEZN3JJnt6XQAEqfE/HCyX7qOdbS3Wl9jh2eP+7yfo3/tiG3VdR2Ri8/pln
         0D3x9gGMODm2otDJvCxf3RNbSfPnBhxI7td4qHuVGxLFz0biy6YL4q4lcbcmIkAEBNqt
         KaANEhDFq8grtc4E82AMXPydQDVCwpS0qclG5fAWQyZovpzrjm5LvN8VznSONKIdQrZA
         IYNnuc9DOdklLH0nhXJGxcGW3ZDGzbBJJWgzosOpIoLVDg4l71W5S5navWnvMatjhT6v
         TiYLWOzD/OLwJdJcjlvi9qSdYDC5Y5Dmivxz6Df8CzNVwGTG31X7OJvYTu1SmfR8YQbV
         bwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TU1BhuiDlEROr6TrgpWz7vlQmFpSa5IVdhHp5EhPeXQ=;
        b=jT6AJvBzeISl7gWeiNWRHCV2NQWwdbrLlqUolF0/D462iZZ+Ayz1zcW5u5pcx4SwIT
         Rt2QEh43IrDJDNKAVJqPXeRJZtOfZERdT5oNhb3e/PeKJd4S7WYzqseIt2vQ78jw1lu7
         oTjFmB5F+//wJjKbDjzfD3xMUEaULsKa5l60hDV+iO+s/FmSDGXF77gdNsJB6YiTAa/2
         9+FIe064/8UXoZwNCxDKfUrPzsRHFMs9C3O2bazXfcXewAGB1gQ7NzUAl14r6fbRl4Cw
         AIW/gMEimiwiU4iuFaIrv9SMlz8iGEQlj34FWDW3EQ4M4peqJ2KNG0Za7bDTCLwZjtmM
         VgRA==
X-Gm-Message-State: AOAM531kR5BJ8Zh9vFURIq6s9Zvp2lsvOnQB0LxrV3P4L61tQXkjMRbs
        vbA2B+kONEvmnyaYcLx68Hwei6U+0ciA0Q==
X-Google-Smtp-Source: ABdhPJykmuBZ1ETvD21/QnhYayzRSvRd8HGyzYEBoG/4zRNHG2k81xvW2C2HdoqpVqQ4bgwx/vmpjQ==
X-Received: by 2002:a17:906:390:: with SMTP id b16mr10180568eja.522.1636643245870;
        Thu, 11 Nov 2021 07:07:25 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k16sm497422edq.77.2021.11.11.07.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:07:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 08/10] trace-cmd library: Use the new flow when creating output handler
Date:   Thu, 11 Nov 2021 17:07:24 +0200
Message-Id: <20211111150724.86304-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The trace-cmd library APIs, that create a new output handler to a trace
file, are converted to use the newly introduced APIs. Affected are:
 tracecmd_create_file_latency()
 tracecmd_create_init_fd()
 tracecmd_create_init_file()
 tracecmd_copy()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 54 ++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f8a16d82..9ea85b1c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1503,11 +1503,19 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 {
 	struct tracecmd_output *handle;
 	char *path;
+	int fd;
 
-	handle = create_file(output_file, NULL, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_write_init(handle))
+		goto out_free;
+	if (tracecmd_output_write_headers(handle, NULL))
+		goto out_free;
 	/*
 	 * Save the command lines;
 	 */
@@ -1801,7 +1809,20 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 
 struct tracecmd_output *tracecmd_create_init_fd(int fd)
 {
-	return create_file_fd(fd, NULL, NULL, NULL, &all_event_list, NULL);
+	struct tracecmd_output *out;
+
+	out = tracecmd_output_allocate(fd);
+	if (!out)
+		return NULL;
+	if (tracecmd_output_write_init(out))
+		goto error;
+	if (tracecmd_output_write_headers(out, NULL))
+		goto error;
+
+	return out;
+error:
+	tracecmd_output_close(out);
+	return NULL;
 }
 
 struct tracecmd_output *
@@ -1826,7 +1847,20 @@ tracecmd_create_init_file_glob(const char *output_file,
 
 struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
 {
-	return create_file(output_file, NULL, NULL, NULL, &all_event_list);
+	struct tracecmd_output *handle;
+	int fd;
+
+	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
+		return NULL;
+	handle = tracecmd_create_init_fd(fd);
+	if (!handle) {
+		close(fd);
+		unlink(output_file);
+		return NULL;
+	}
+
+	return handle;
 }
 
 struct tracecmd_output *tracecmd_create_init_file_override(const char *output_file,
@@ -1849,11 +1883,19 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
 				      const char *file)
 {
 	struct tracecmd_output *handle;
+	int fd;
 
-	handle = create_file(file, ihandle, NULL, NULL, &all_event_list);
-	if (!handle)
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	if (fd < 0)
 		return NULL;
 
+	handle = tracecmd_output_allocate(fd);
+	if (!handle)
+		goto out_free;
+	if (tracecmd_output_set_from_input(handle, ihandle))
+		goto out_free;
+	tracecmd_output_write_init(handle);
+
 	if (tracecmd_copy_headers(ihandle, handle->fd, 0, 0) < 0)
 		goto out_free;
 
-- 
2.33.1

