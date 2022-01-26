Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 234AEC63684
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239363AbiAZJtY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239369AbiAZJtX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:23 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB1DC061744
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:23 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id jx6so37799344ejb.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ForQ2qqpPQ3a4bUjE7kAKoqICHmE22x1hl1wSGFTDw0=;
        b=l0PFozvEXWPIzWunKFAaRiIxx4nPKXad4NQvizCFZxffbEGlxxHMY9XYcWVrTAgh7e
         6gHaHd53ljyfjYoDvvKtVQ8CDT7hiazOCkJ7IjSbaVA/qhSMTkfqeXMHUpmuHdpRrHeI
         0hCQ3n0jO19hAU/bbo2gnApZZynY3PZKc5YTd8lbyXbNeat86cqS27I3Gk2QI7OPWku0
         l37JzCrsIMunvq7nPMySw83dt3e7MVhgT5PGkmsfwMw+eDpMF46oQUS8c4ufMAnLcMfT
         iIogmK/0mz1qsEh8XmA7Bqb69lSfBXuqgvqpC1KTPZuNRKHClYgvTATbc2UyYwcx5f8l
         WoQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ForQ2qqpPQ3a4bUjE7kAKoqICHmE22x1hl1wSGFTDw0=;
        b=LQzz/XGAZ8UD7b99LLjf78etMQGpOdOO7nhXilQVmMwrTknm0yEEAlJMr9d+0s88Kh
         lasixS/8SfuRtbhjgU2wl+zF363LLgX8MUPRin4nK0vy9ZMP38aHa3gKXMdSU/fabHh8
         njH3DUniBkX4TnKbhp7LFb08NQ2GsRxOR5Klyyq/Inyo6iFKdnRLbZcBOF7TwwxxF55l
         ku/cWryxHcKdL/5+kq0TVRdwy+LYMGlWadrnlDqBgSwgfX+SH/60qqYOkGO1MVjzpRtD
         FyCrJftEz1FVCZmYThjeExfaTzm1RPeMIpRTsrLvIx3I+Zut5qQWe48etbyMHhS8yCv8
         FqPw==
X-Gm-Message-State: AOAM531pxR8OUCz5mMDqe3ojlO5XQO/mjfTFVFiD+GUFlcO57PynKz0C
        f5TWeLQcMCSUv4T/zRQxM0sK5B4ifCY=
X-Google-Smtp-Source: ABdhPJwQrGZKMu6/LJRCDwnXLVCaAhnmhAJNcxAYV9qAfbdyc5ZeboTQsPDimZdGRUS29tTVZXjpMw==
X-Received: by 2002:a17:907:2cc7:: with SMTP id hg7mr19658654ejc.235.1643190561978;
        Wed, 26 Jan 2022 01:49:21 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:21 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 09/20] trace-cmd library: Compress the trace data
Date:   Wed, 26 Jan 2022 11:48:55 +0200
Message-Id: <20220126094906.570451-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
index 82f3b816..780fb481 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2219,11 +2219,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (HAS_SECTIONS(handle) &&
 	    !out_add_buffer_option(handle, "", TRACECMD_OPTION_BUFFER_TEXT, offset, 0, NULL))
 		goto out_free;
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER_TEXT,
 					  "buffer latency", flags, false);
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 	if (out_update_section_header(handle, offset))
 		goto out_free;
 
@@ -2324,6 +2326,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2376,14 +2380,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
2.34.1

