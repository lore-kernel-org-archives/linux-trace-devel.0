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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984DEC43461
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BA91613B4
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhELGjo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhELGjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD97BC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:31 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id s20so27793068ejr.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=ZLuIGyOdAt8FdvNI3yGRkN4RE2pLPsv5DTlhA4LIRmExVrroJ9IA97P/ODES9dFsfE
         Up5Sp6Iib2M+L/HySCi4lqw3KjAzIaaWU/wUuILWWXN/L9mCeJBCEbUh53GzzH/XriTK
         4T6/8DN/uHya5sfFbKKCuXl8yXKxmHVBJD1hEKzArBP2NgJycxHJW5tri1sRQqLXqAJ8
         kB7o+pssPBlVlu8mBA+d8OkjqPpq0xbo2/iPWYONI4E5/Jyd7NblCWRRm7fERSooy6Al
         0E1J+7HQPwfZZi3u/ceU1UCfe2xvnuS9ITApZlrpRCd4OUF7BAc6tr16+df7E1teH5NI
         SBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=KiS53aMV0kOesRHLyyCjxCe0R6eRzetNaDgOX5bOGrQMevWmZKXNETTECime68/L30
         wLYewkePMZDMAofFN8fD/gFjpXNpf28hksH9RKXNIvYqxzduyxwN/vnoI3eIi4S3TQ4T
         Z380n8hdVpliDBX7/Uc/x/gNRlryVi3L6aUJYzgIioLf6IsJ08SMFMX6W7v4jYiblkvA
         OXE9Mha+v01XQ4epYGXYb5egBxpVlFisKe8Zn3BHnjxNvJEQ7avdwa85nlSC1AXBD9Xo
         SUtTRBuagTJGzs3LOrIQ1DnmGR/Yea8xUtTEf2Y3khTdQ2fVuXc1jEoNNkhyH5L2t8he
         yP1g==
X-Gm-Message-State: AOAM531v0ZZT34j8ak8h/egcdQjBed3sG4HTxf+8Ilb/3jSXD/gHLVjO
        X4D48sIcKWOVrkzHqj9upv4=
X-Google-Smtp-Source: ABdhPJx/As7VUcIiPTJxSHyfQ9rq8oJlakGLd4mjmaQrEDALwHUToflIIG9FGre10TjxOtdasuR4ZQ==
X-Received: by 2002:a17:907:10cb:: with SMTP id rv11mr36221198ejb.379.1620801510583;
        Tue, 11 May 2021 23:38:30 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 05/25] trace-cmd library: Select the file version when writing trace file
Date:   Wed, 12 May 2021 09:38:03 +0300
Message-Id: <20210512063823.324610-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
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

