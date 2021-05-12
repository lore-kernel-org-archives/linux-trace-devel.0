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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9E99C43460
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD5C561628
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELGjs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhELGjr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3CCC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:39 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id n25so25710896edr.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YQ5q9T+DM6JDItU8RS9aWYpqQte60zQDz1p2bIZnzM=;
        b=pwoDwCSB0r5YSEw2gjAIWPOCQBlhheAjPw+3BDJdQsaPKntUaEVpSmhCzQm+CdJiLk
         wREZbvqZCRSs7r08Adnbm+hQMocSEfVWCbvpqgjcvf3qzhIFNMfF4fLUAbhfojfEUF5G
         pPjOwKDLAnfezxG1gPl0nqBPaELVuUaAPIwf81tXuhnSeJi1Kd+45wEr/s9zA9iQnCmW
         S5UxLqvpKjJvqKL+xuK8g98+g/neEGWYtPSXGEVA2BkIcegnTqaTk6FycwIsoszst6qL
         NXHkcAvbdLfvxcJ89KyPzVdNsBp8A9iAJQKLtD2H7HOYXlwp9vZ5kvqHBf/xGS5ZzK81
         7XbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YQ5q9T+DM6JDItU8RS9aWYpqQte60zQDz1p2bIZnzM=;
        b=WWeLQV8PU+qRcK3tDkCkfeBdBfJTslRbu8OoqRl1PyF55h84Fs1FeLPjMA/RQz9v3H
         RZVyxhKO1j2RxIgq4myKSuXCmnI17nnza8nLvtw+gNuPI6e6cMVJw6/zsGR9rDlrB67d
         0DebhVjVEKeT0XHckQ0oDrZYdbxtwygemFMEJgIuA830zrsb4y1nr7CCBroWMVes5uns
         TFiVmMFSg+kZiJ/SXNIkrA2152Kn35xGqnnQeVpGenWiGrBXxhEqm46aRsYYCVWobmLo
         5Wwi5Kf+4TH8d+CyODjoi8DpIKrweaJ7bI0TzMD2nkLtqkJqZY/WadM17aE8zKEfI+r9
         lIMQ==
X-Gm-Message-State: AOAM532g52K+i1E9Ba/1c6tIhw70GqS8CDU/BvlF5IYpsss6QnyCIQBd
        +nb3Y61p0KTnlTDM3NbfItJ6Pc2Q5XHvJw==
X-Google-Smtp-Source: ABdhPJwOtZnmfzPPGFCcCP9K8neKkbTKPT7koQwTJTyRmgqqX81i8ru3qk/ze9dgTWZ6I9sTqLGUcA==
X-Received: by 2002:a05:6402:1281:: with SMTP id w1mr37232606edv.148.1620801517990;
        Tue, 11 May 2021 23:38:37 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:37 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 13/25] trace-cmd library: Inherit compression algorithm from input file
Date:   Wed, 12 May 2021 09:38:11 +0300
Message-Id: <20210512063823.324610-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a new trace file output handler is allocated, based on given trace
file input handler - use the same compression algorithm.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 627cea42..ea90ef75 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -980,17 +980,27 @@ out_free:
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
+	const char *cname = NULL;
+	const char *cver = NULL;
+
 	if (ihandle) {
 		handle->file_version = tracecmd_get_file_version(ihandle);
-	} else {
-		handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
-							   handle->pevent, handle->msg_handle);
-		if (handle->compress)
-			handle->file_version = 7;
-		else
-			handle->file_version = 6;
+		if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+			handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+								   handle->pevent, handle->msg_handle);
+			if (!handle->compress)
+				return -1;
+		}
+		return 0;
 	}
 
+	handle->compress = tracecmd_compress_alloc(NULL, NULL, handle->fd,
+						   handle->pevent, handle->msg_handle);
+	if (handle->compress)
+		handle->file_version = 7;
+	else
+		handle->file_version = 6;
+
 	return 0;
 }
 
@@ -1645,6 +1655,8 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 {
 	struct tracecmd_output *handle = NULL;
 	struct tracecmd_input *ihandle;
+	const char *cname = NULL;
+	const char *cver = NULL;
 	int fd2;
 
 	/* Move the file descriptor to the beginning */
@@ -1682,6 +1694,12 @@ struct tracecmd_output *tracecmd_get_output_handle_fd(int fd)
 	handle->file_version = tracecmd_get_file_version(ihandle);
 	list_head_init(&handle->options);
 
+	if (!tracecmd_get_file_compress_proto(ihandle, &cname, &cver)) {
+		handle->compress = tracecmd_compress_alloc(cname, cver, handle->fd,
+							   handle->pevent, handle->msg_handle);
+		if (!handle->compress)
+			goto out_free;
+	}
 	tracecmd_close(ihandle);
 
 	return handle;
-- 
2.31.1

