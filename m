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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF0C433ED
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34302610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbhEJGR5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhEJGR5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:57 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CE5C061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id b25so22696084eju.5
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7YQ5q9T+DM6JDItU8RS9aWYpqQte60zQDz1p2bIZnzM=;
        b=nuZ69mptPIhS0jB8UG50LwivWTGuRKsiJt7NOjP7dpOKa/VwFpN89ZCbudeUYfJ7gC
         eSjsK7Huh+wAJTZnwe81/1+Ryqs6+4TAX34H4VmrHwsRgIs+3QsbRppXiUb08FD186Gi
         ps2U9AzH+ADOK7yT9ow71QaElhJBUA3aTHmBh0bNVnJ+96XejoikNDcQnyHFLDNCCyF+
         xMU0ZEWBYxeUCy8xnkAqRuFVvML0gTCd6gY3wP7swQpuPK+YQUApzBZhKJ+fePTIBRKl
         2ikbYo5iFljGNey5YkPQJMnJ7TerwlzqeGKybgYahOaoWnc9svTSj/eMN54+AoNxJhlj
         4q1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7YQ5q9T+DM6JDItU8RS9aWYpqQte60zQDz1p2bIZnzM=;
        b=d7V1Ytfej/JyJi5zL/G+4Y2ghTFBKdDKysxnBLzd2M/hsTXHk65pQiRzOSfx7G0hh/
         m61xF8ZrgvXZdq7LXFsYwhIj3cqIcb88KXGoowgGPjxtUJdJmlzeaWIr4TYHOOu1TLGD
         c5WW/Cly+FrXzil18gNfDpfPiEB75ga7LmUuDQX05NO3qr5EKGcwxkjB9cpLO8rYJua1
         NlmCTdWKZl899jYTQrBk/W5zZW+A8zxPaQzlZgNbIfrwW1zBLk51dpsllA9WvGzrj36f
         y2Kj2/1kTrbT8TCUtf6LfqnN0Y9DB6KVA5wOD6Gq8bm5VNGuf3bO5M2ae3yNRbQUoaYK
         YRzQ==
X-Gm-Message-State: AOAM531YYTSaIB8833SG9WTORuSlZGps/ZVab9r3kheXYzCtUOR8CCyT
        CkgarWWduRWgEdY8gqH6u9PlLuSvPLyADg==
X-Google-Smtp-Source: ABdhPJwddWqHlgZkyF51Kym+bMx63HfoU1rN3TGlS5WahrzJlZ6riud3oB81W06/I3IMTmmeAtp8Hg==
X-Received: by 2002:a17:906:a0c6:: with SMTP id bh6mr23881269ejb.359.1620627411241;
        Sun, 09 May 2021 23:16:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:50 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 13/21] trace-cmd library: Inherit compression algorithm from input file
Date:   Mon, 10 May 2021 09:16:28 +0300
Message-Id: <20210510061636.1794357-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
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

