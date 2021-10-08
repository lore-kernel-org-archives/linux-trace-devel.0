Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E752CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB10160F6E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237588AbhJHEY2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:22 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81355C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id p13so31789110edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mbkWVYX6bZnepbH8tvfpiRdflloaOMFMD+LcyGxN4jE=;
        b=YwwRm2tkJUo2vLA2pa983oIR0wFiORt4Lw4NL6eaWIa1L3F9mgXYHICcu0J2YoNX9l
         EbXX5C333+SYc3BrW8Fc8duRIjxCQDvKvAqzqfAtjGcX0Dix+Y7SpxcEh8feA53Y6w1r
         igLFoe4kxVAH5kcmvEAKXiVYC/x4yr6QTy0pWk5APKp2l6cpCnr/SZ51B900w2Oerwcs
         g5S6aFMt0KIwsQylfMFw3cLaxA56UzvKNa0wJ1oAF895LEQYfbMmI9xcuAhtLMTbfAHQ
         YeJmY1KhOd1/+s3TWp3V6aQ2nT62rgwudJuQJktg7gX0Gog7CYMkZF96psb01yaVlKn4
         U8fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mbkWVYX6bZnepbH8tvfpiRdflloaOMFMD+LcyGxN4jE=;
        b=rmesFi7o+mKF9HvMIyh83x4BvALXD9kYsI34fVuKUQs527xRkcSMqK5zALPDnfMgbn
         tz7poP6OMAAZn0BhZckiQHEKhtTBSt2jOJqZA2zUPwYEWgK4YmNjbBDgGbsycr0xjW/B
         qKZCHsU3I9OXWJqy88g8sCTnPZIA2pk/PxBkvjG9fOGlijcX55Er9sgucy4OOYCt3sRA
         XpeOyd0MXFfkcaoxRJ6z28w1cV7lus9iuYWZ3lJ4SX2U4iDouHtLuYHoxR8gCVAoKTiT
         NPSKy3FbA93hscS/0sa1jBtbREnep7OfTYfZGgo/hNTrfrCfN6bu49LDgccjon0wR3jX
         SVdg==
X-Gm-Message-State: AOAM531/KurNvClA8oVF0xUXdrQ16l2xWvI1QuxTN7575MuQwQOtHbx+
        wnGVZ9Gy5lBWLe5JHN7aLV1GQZrXDlGoGQ==
X-Google-Smtp-Source: ABdhPJz0GEAAF9YqjHgqjVGYEFBZgjSKHmiSGyApDZFZndtzeoJ3pFhhdZuX/D4yntoxuAOvwtGq8Q==
X-Received: by 2002:a17:906:c7d0:: with SMTP id dc16mr1245817ejb.555.1633666946193;
        Thu, 07 Oct 2021 21:22:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 09/20] trace-cmd library: Compress the trace data
Date:   Fri,  8 Oct 2021 07:22:03 +0300
Message-Id: <20211008042214.977193-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the output file handler supports compression, use it to compress the
flyrecord and latency trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c46643f5..84fecabf 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2079,11 +2079,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (HAS_SECTIONS(handle) &&
 	    !out_add_buffer_option_v7(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
 		goto out_free;
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
 					  "buffer latency", flags, false);
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 	if (out_update_section_header(handle, offset))
 		goto out_free;
 
@@ -2188,6 +2190,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2240,14 +2244,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (data[i].size) {
 			if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 				goto out_free;
-			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
+			read_size = out_copy_fd_compress(handle, data[i].fd,
+							 data[i].size, &data_files[i].write_size);
+
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
 						 read_size, data_files[i].file_size);
 				goto out_free;
 			}
-			data_files[i].write_size = read_size;
 		} else {
 			data_files[i].write_size = 0;
 		}
-- 
2.31.1

