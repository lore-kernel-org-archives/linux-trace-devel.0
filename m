Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3DDFC43217
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EAFD60FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239946AbhIMMnb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239085AbhIMMna (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:30 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62092C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:14 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w29so13708748wra.8
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+cl/O5tgZWtqAOva1SZj6PlCWSuAGY002QXYdogqg0g=;
        b=beRZdmOXaKLnNxjeM9QBnyxytQFU1Ju6+d1SQvTSFiEVY6ZslYfkN0az1sZ/RozB/6
         8RilO/+lMO3f8e8pgJgM+fGo/XKPPUUT/4Ch8xq4I0TgUTWQFgZxC8SFr5Dd+jSZSnjw
         tOx+9kY8zGesyHWoDNlT28F6EamxcwqxSXIn90wHRBd00pABaAYBquZQlgM+jmcNUecm
         L/O9h178t+uoEEi6mk5xxlhbP3LWWbRXv4YSocsoqWW/t1nEdrP4h/SgCLVAqKvNZS5V
         PoUWw6dAeEuTA5FlR5Uziw5TyG7nln4UahMLj07T/WM66xwoT0bDvuT+MguiliD43S6t
         jh4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+cl/O5tgZWtqAOva1SZj6PlCWSuAGY002QXYdogqg0g=;
        b=a0Dgb4Q7oFjWfgSaoSZqulFObg+LlvJGi2BzzSlUHiuKzZbBY7x0CRrRfcIpj7kZcd
         nSb1z3kwMjVdhr+GxbVBL4hAqvYdGBmgIluNyZ1E3DHg9svxP2blwHZnJP/dzroZXNGg
         ON28n1aA2p34wUxnB+qL1ImSLE3+jepUOZs6jq6LNCMb40bY+G8o7egwk0D6bvGWhp6j
         BXPxlFp5mu4pwzTZbTloZ3Xz49hBJGjWHVf95WskjqYCqvgZSai0h8HpGcNWvPGiYIpB
         ifCKQUZHzdo8Y/mj+ygJh/WxIggiCfWqo0miviOCCWN8fKKks08vC56Is8JwcGUQNXDP
         w0jA==
X-Gm-Message-State: AOAM532XiIsBxV3GRl7od+BZcBFYps1DZQCpJMka+S7Zyn6STUc96nX8
        OCBe4n6pQ8uWRoGIdM0CgAU=
X-Google-Smtp-Source: ABdhPJx25mQtluW4SWcIlSui7QYc5NJY8p4eCgaGZEdnDtU+uKXJd7bUnuVkL/8Vs/1kVloZxDDkXQ==
X-Received: by 2002:adf:e408:: with SMTP id g8mr12383698wrm.138.1631536933018;
        Mon, 13 Sep 2021 05:42:13 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:12 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/20] trace-cmd library: Compress the trace data
Date:   Mon, 13 Sep 2021 15:41:52 +0300
Message-Id: <20210913124203.3677760-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the output file handler supports compression, use it to compress the
flyrecord and latency trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c69d6d4f..89b502b4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -2086,11 +2086,13 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
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
 
@@ -2191,6 +2193,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 	if (!HAS_SECTIONS(handle) && do_write_check(handle, "flyrecord", 10))
 		goto out_free;
 
+	if (handle->compress)
+		flags |= TRACECMD_SEC_FL_COMPRESS;
 	if (asprintf(&str, "buffer flyrecord %s", buff_name) < 1)
 		goto out_free;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_BUFFER, str, flags, false);
@@ -2236,14 +2240,14 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		if (data[i].size) {
-			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
+			read_size = out_copy_fd_compress(handle, data[i].fd,
+							 data[i].size, &data_files[i].write_size);
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

