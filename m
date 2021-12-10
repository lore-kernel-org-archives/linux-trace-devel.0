Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8B9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240106AbhLJLDY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:24 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E941C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:49 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id x15so29283739edv.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yjPuy8hn8HL+lC9Ml5tr34DiybXLoAWp5sZItqSMxoM=;
        b=WhrvK7/5+TdnCDeib5102nE/R9zSWTmXYYx8wodk2noGwFjy5ILm7TMsXvPSxOVPfY
         USd9iVq+H/mn4SDW2Dpy+8fQpqp517+GKjsw+vRP37OlJJfCT1duBNIdT+LrxRPcyl3K
         NRTGhZ/TZk44AxT1vozqQssLe9l5VF0fGOnrLKdfSac/+DEOE21FPyDjvZTzCjz1LR44
         QoD27PxjO+Y7ABB7gNPJyIKehWhwsaCNvRuAXdodoemHVlHmKqiAo2pVe/R4w26gZ3Hu
         4OzbKfN/uExZ6gOXWOdNOo7KOkj42GvSE4YzDQmISbPtkbUYA58GCcYHQ9rpA2yEZOUI
         u4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjPuy8hn8HL+lC9Ml5tr34DiybXLoAWp5sZItqSMxoM=;
        b=NBpjX5rXBo0wrMZIIy5T1Eg/1vNdvxcEdWyLrJ3NX4lCmN9qaneq5kghsw2f8MKaav
         qHXqIrS3V+WqoJMZ+iPGK49Yd7MpKcFUH4WeXzf8HjI6pNeQJYBOMb/7UoZSIV30w9jy
         7J3fan8eDSwKSu4bPw5g04+q1/r2EaBTYW0ePKzQYjvSUdgjWspTEFRpJqAaPAAuwVaX
         ccZJHK2PWi7be+y/PlvwwA/4go2mE8bOWjUZqGBfuP+L+pccwjN0HcdmVMApgM+m8LWy
         6zgCnCaP8SDwAnC/SYyNxKWIcGirDqdLFNj11CjJYrEGfRaeZGhmgg5WTmvEATCpGcRM
         YIrw==
X-Gm-Message-State: AOAM531Z8yBD8weF3fnJHJ3N6HHkabnwYG9Ba4PGlM+8Krm2Z+tfHj3O
        zpPLox+tQQMjDIKaBGn54y3gyTgNs5M=
X-Google-Smtp-Source: ABdhPJyvKBszgA2/HRzeJqf+HXEZLcEEzwjW+fP46W2jPB7e38miEl8qiJzFbBTgtqmi3HABwZ7GOQ==
X-Received: by 2002:a17:906:dc8d:: with SMTP id cs13mr23563496ejc.323.1639133987667;
        Fri, 10 Dec 2021 02:59:47 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:47 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 09/20] trace-cmd library: Compress the trace data
Date:   Fri, 10 Dec 2021 12:59:27 +0200
Message-Id: <20211210105938.98250-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index 3bd67312..4ba971c4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2176,11 +2176,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
 
@@ -2283,6 +2285,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2335,14 +2339,15 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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
2.33.1

