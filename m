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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024EAC48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D793061370
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232594AbhFNHxs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:53:48 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:35711 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhFNHxr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:53:47 -0400
Received: by mail-ed1-f47.google.com with SMTP id ba2so43439673edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R7tpJUkfWQT6boWeVeVRny1IdcYdoZq+HnAPbHcv2Wg=;
        b=suKvipB4gJp8f/+nPQE6/hT+rh9kBhESV6xeGb2l5o327WleG+A7q2PT8URFfvPQ0Y
         8AfUoeBY3Y3BcNJAoMZevZ4hE9gFiyp6PzhTNWUgl5sI6dnaoSn9laA0yrZeL+E7/z6v
         NSpnpeeGN/AvjYIGaF2eCJxIrtWI3x5CWw2KHM8eHDlddXYJv+EqFbqkXS3hhaNp5IjX
         F8MiBoYNjffXMeIPsxquuu9OWo1CqPZzIsR7gw8Jawz8CZh4ztB7AAfPCaS36sWAWEBk
         xtTi/5yQacuRIo7NtYTpWOtWYfTmlB1SH5PyWziFd4AN4fLtAv778fz9KddDX94NBRNe
         gTww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R7tpJUkfWQT6boWeVeVRny1IdcYdoZq+HnAPbHcv2Wg=;
        b=lIn7waHr7zvX9OaVBM/XLHy8z1uEkuju/uvxzCBwojsxVHIThHy5bhdNPyQAqLJWkd
         aI2wzFLtXweNUeDvuFw5rYyGJo3QTN42zs55HBTRz2K4Eg6EBHXbhyznJuPdmlcnFexs
         AAW5wXWi3hsIh+GasvYxGYh1T6SVp0gvpLLGLcXLEd1TBiogSryJ9TYauwC3/5o7nj7u
         MmFcNrHhA3XaOlmCXps8C94/WZVjVj57ZdjclhlBdh3ZyUKxCtu/XAIcdWCDEE56BaX6
         OlKTuP47OWpsozMY3meNQlzYq3b8AFhYo+p2L/PeUieW3p7IlYAnoC7IUnXqAtMHzqd2
         0jnw==
X-Gm-Message-State: AOAM530l7p+/avZvZBZd0ZCTO86qyZIsNuWGl1FKuCr9BaasKNwdSC83
        k/a5fb9AqK2aR53CbdTBk4Q3PajfR18UcQ==
X-Google-Smtp-Source: ABdhPJytCH9DB0lGIaLgtdXQyx1IJWkzelMqL44fDhRF7wfRdsF/NgNLNjRbaNRQrVnnr8Z0ZDw3Vw==
X-Received: by 2002:a50:eb92:: with SMTP id y18mr15606023edr.249.1623657044778;
        Mon, 14 Jun 2021 00:50:44 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:44 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 13/45] trace-cmd library: Inherit compression algorithm from input file
Date:   Mon, 14 Jun 2021 10:49:57 +0300
Message-Id: <20210614075029.598048-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 87816b37..82b3e5df 100644
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
 		handle->file_version = tracecmd_get_in_file_version(ihandle);
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
 	handle->file_version = tracecmd_get_in_file_version(ihandle);
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

