Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD95CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9491961252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhKKPO5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhKKPO4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:56 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE7CC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:07 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f4so25348359edx.12
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3wxDM7+gwTNRiXFLdyAKrqj34nBdSxDFv1ck0Ef2oFo=;
        b=EYkqJDNdAR5BmVfnmvIXj6ov1CcxcW6puTb/D0H+BdgHYUG4Mq9qpUPs72JPAxGZtx
         Dnyzopf5LNEl62D9OuihOZX63XK12Bw7sCOnnibw0JW9LYFF0ggYQ9533Q6aw4plVc4a
         8azUK9N1VWpc3OkdVpcwYjMYe2ZLMxe0Uc/K0SxoVrMiH19uJfcWJYXA1F8GcKbmlko4
         4pR8XWIgYxvwJdQAAXiUV75fkFUxGI0r42Yr2UmNdwSPm4TAsBB4p9rKTJsKbchb/MQj
         Sf/i77uthKk5D9vtKUOLslxEANPKI7s8vLJB8acbUKrDpMMhO92QrvJJ20sXZdjfPJF+
         29Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3wxDM7+gwTNRiXFLdyAKrqj34nBdSxDFv1ck0Ef2oFo=;
        b=MTyaMoPnfNr2FpTYCKq6owomGehof2YyU6hmEf2/hJLsEB2kNFpB2UtRm3RwSignK1
         6QOnTzomNlkSdcUIywuD1fwMfNjQKXJx+NpP5fbit1gYvH8ask5GdufvboWTqZ+LLmJ9
         TmubenpuMAusMsCgx0F4cE+PR8UKmqMH+/FKMQ1akX2vdk866Z1m2fUZ/6ZGrPm5v+w+
         gpWsVKcP/1mwWs2NzA+08eerjAWDKOCEPTw8pjKD7aDkc9nwha+QE71t8euMT6wSlivY
         RREr+WAjZVk8hfwY2Y+kBLjIcq50FMtq/xZqmiGOBqIT5nuaDyCdZ6fNCA/3Qsl1Efmp
         Uq+A==
X-Gm-Message-State: AOAM532LDCK8jEe/BxjiX0c5hGWXL1GeBnlew33nXzsWKRUvCS4PugnH
        Ba/wwD8QB7b/lCCmIkLiFVtJgjFuay8fmg==
X-Google-Smtp-Source: ABdhPJycKUzfZo6z81Df6rU4KuCBC97AYlJ1TkqJPgzGBBwy7R6mXxyv4WkwSrlC10U9RA1dZz87kw==
X-Received: by 2002:aa7:cac2:: with SMTP id l2mr10914770edt.168.1636643526162;
        Thu, 11 Nov 2021 07:12:06 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:05 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 09/20] trace-cmd library: Compress the trace data
Date:   Thu, 11 Nov 2021 17:11:42 +0200
Message-Id: <20211111151153.86855-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 627805a7..c4a8058d 100644
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
2.33.1

