Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEF2C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352451AbiASI13 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI12 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714BDC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:27 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id p12so7522427edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l4VpDDGnpeFEAKGWzW1MYwObtP8anbC24KAg/QZZZ/U=;
        b=Jn1Mnemf4iVKz8VrtDI6/bBV/BX+GoXa9RNaj5YUITaYDV1miB2T6XU1L6VQ9yTtUF
         mgR8enecYnJMSTk1bMiO9vH2gDsuRzM5hx4rQ1bVhiKUz2owviT2a0jSSJLvvKjIRVFB
         oEqnqtVXDANG8siHcjCh88M6Z7hzgH4gqP/PjJ+nDtGI875ziZXLYhKQDJ1P8biHPnFL
         IkOtCuqc14bsmswVV9S4tFNhK2Q7bjtGcRQvOfAYv0i0626bFcqmhzcHUC4r7ta4dFcr
         2k09gpag2GVPjtL5x7bHC6Kr+LyOvY2nMqchg1omVawA4Oj2TW5HnjT0JmZ36ZKFgBDI
         hMdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l4VpDDGnpeFEAKGWzW1MYwObtP8anbC24KAg/QZZZ/U=;
        b=gTzdTkKoawclqO6s6jNgu6+/mNcIJHOIwAJJHbVpKu8eO91hTUt5rysyqqVBqGTTo3
         2AaLILmzW1JOx2HyxEwPXO0Bz+g9t4WelPnvA35AEMeQdTtT/XYFtl+MR/zrzP4fua0O
         2OPWiWP8PaKXNQ2AAsW24K/OaX7FkdBzSIbQn0zHZqISwgpgc6fmKAqNy1pXRLoyeMOM
         F/hnyyivG/bDaAZ6pQ2RfZWoC93oKoLQpgFNjdT3jfRvqMQ+QzZj3gmsy6b1hzVUpZfd
         HfxDxbVAdAMZq7BaPL7yz2XiZ9V64FvCBi2KMjTZ/oipYgTmsYK4qe6movDI2v76vcxC
         5ETg==
X-Gm-Message-State: AOAM5303Uj8rrPXtpvnJYmWA6M+FK/WSdBQWIS65EThKDFBfnEEodSAW
        a5wahtp72J6dy9lUcequGanD+4VlOI8=
X-Google-Smtp-Source: ABdhPJx9cQyIuPQiy+eyS2vpQVmFlPXsgE6hzvopE1cJS9kx41hLGlil2kGIi9VsG74SwvsKG+pp5g==
X-Received: by 2002:a17:906:c1d8:: with SMTP id bw24mr13243649ejb.286.1642580846100;
        Wed, 19 Jan 2022 00:27:26 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:25 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 09/20] trace-cmd library: Compress the trace data
Date:   Wed, 19 Jan 2022 10:27:04 +0200
Message-Id: <20220119082715.245846-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index e2e03cf9..09146a0a 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2194,11 +2194,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
 
@@ -2299,6 +2301,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2351,14 +2355,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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

