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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6D7C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 406D7610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEJGRt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:49 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A786C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:44 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v5so6251294edc.8
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=CQCtuTpmYf/VMlO8xkXOM3Le6dyhBQYyixAed9pHiiBP1X20xo/aPh4d9I97XEwHHc
         zsbzPtlfYLMRkW+PWedIrTO/q54n8tsr3sIUwYYO3Lbn84jZpLXo7je/fcqBwPZH8hOc
         z+k5UZ4iRBmblxoQb0LS6K+/Dq0adZ4m7MrEOQkCh/MLiqbKxIHmJdIVR1onJfTNFk0g
         fWiFRWfiUivGIJ2KV04CZRSbjmrGpV1z6n06dwQtUEwkudwuO7KkEWJtG5QOR3KL9J5h
         lzVtMPUHjmzXWgdJL8SAIToL5amXZWV9MF6l4tnOiGEsGBQ2swhGy3r/RjSmqwOuXXfq
         Ov9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=cCw92dv1SD7FxFha533cpooQBy4stWcDA5/k1U7gKLADbBNFN5s2Rcb+u10uY5/LSq
         TPceKwZpUO9PgkwF33c6s++ckMbADNKdLNBE+Y3OWv7IZX/u2fGcVwIhzDIUmiEkiEfK
         fGDiYKKQ4q2663mFfVypC9uR6Az4H2+hX+9M8EAQJktJuZcU6kR5Yt/AZJV6jzoScmrv
         hJKdTMqqwh8aw9KRSpvMTLYAy+9OMB9b3Kimnh4trUtpxhFSyMDJ7yQf0LfoHW2POLFs
         eGKxkxxzFChGkRT3S1hqrredjOBPaY2QzeMKqJ6VXSY0fc35n0OknkR6QJcL0pnPYtoi
         i+Wg==
X-Gm-Message-State: AOAM530vA0H+mn/8FJHRI7JLdL3kOOebQfoR6HAXm23o0M3a+JN4JGH/
        y3uG3PiFOOETMCKnF9xeizI=
X-Google-Smtp-Source: ABdhPJwhicb+tldZGR3VCMa46ViboX0BUMsCEIxBxk4X6TeNmaVlLsaLqLROBDH29TRG81atM3zyHQ==
X-Received: by 2002:a05:6402:2050:: with SMTP id bc16mr27353774edb.179.1620627403176;
        Sun, 09 May 2021 23:16:43 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 05/21] trace-cmd library: Select the file version when writing trace file
Date:   Mon, 10 May 2021 09:16:20 +0300
Message-Id: <20210510061636.1794357-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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
index c0aa58cf..3c30edc1 100644
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
@@ -1562,6 +1578,7 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->pevent = tracecmd_get_tep(ihandle);
 	tep_ref(handle->pevent);
 	handle->page_size = tracecmd_page_size(ihandle);
+	handle->file_version = tracecmd_get_file_version(ihandle);
 	list_head_init(&handle->options);
 
 	tracecmd_close(ihandle);
-- 
2.31.1

