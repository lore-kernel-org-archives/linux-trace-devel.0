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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B6CDC433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E8D3611AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhETDVb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhETDVb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:31 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62ADAC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l1so22954518ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=bTgUXz3t1IavBA1SuDARQhcVJeV9uR/FOsYIAVxPKQ18qKAlfH8r1AS11wMI07cLWA
         nu2BjaMHS7A2hC34HhxFXHkwi+/HwfZnN0Can98dTXEFWqdY+8OTMwnpJScyM59Ebvs4
         a7LcPf0u3sXq2sWKnG3ox9fWiMeCVmTugSji+h2EqHMtj+pnPG5aosePljjQC0FD/u62
         hvLrNa9xiDZphN28sJXo6NhX0bONhzuuZojvaBHKV5J42S1UEwJOWq+LpV3LC5457dEw
         qRzjbgghY0g+JYd9E0wuWKcfLzsNzmCPpHFKYslk4+fMUTiX5L5wSdc7oWnqOWKr6SGl
         N5xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HuGT59fpnbaV/Ei2fhVY2rS3y5IDn6cNc88pcWTIj8=;
        b=kxUCAimYLlYwYfBmBvX/X7BzEVWFUnOiY3CYNZxdoee/5/XoUCNDbiHiC/LX/Kqh4+
         ZtOhssum4TW6nkn3hzrkxNHYmzWHzIi58k2B20YDkEsb3RrGp4Ofoe8mHxTG1bD92vxF
         7BYNOpf+UObDJMHdErosvdavZn1miQxFpCe+ORj2wODsrGlL8JGOl/gzQaBEot3pat9F
         9i8ty5URIRgZDhV7eYODdcCUjROySsRsxvUu958J5MyPavYnzykClVhvYocRqU96VtNs
         iHfKM3FhPsh4Jqu8kpwdRjzRkFgK2zO9BfYru6j6ItsGnRHIIPhKsfO0SOZ+VT+Cju7F
         ML1g==
X-Gm-Message-State: AOAM530x3jSwOCwJJCvfEs5n/2DqQuvoxRyQWX2qzD2v4PpWPzdnaS8R
        Wq33WByben2qSHTITrTYO3Y=
X-Google-Smtp-Source: ABdhPJxkrl40oqlmmVnoodyrkBJ0yTfuZEmndw6sgYwnTkQyICESdosHKL3Gha0cR954XSTMa7H6Xg==
X-Received: by 2002:a17:906:2bd0:: with SMTP id n16mr2530788ejg.110.1621480808073;
        Wed, 19 May 2021 20:20:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 05/29] trace-cmd library: Select the file version when writing trace file
Date:   Thu, 20 May 2021 06:19:35 +0300
Message-Id: <20210520031959.346165-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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

