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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923B3C433ED
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74D0C611AD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhETDVk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhETDVj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:39 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDD5C06175F
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id s22so22734273ejv.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hQYYC2TnA8NLtdWvLkwQiO+hUHTcdaTSemyO9tb4ixc=;
        b=t00L184Lp9VnxIqgopI1w4lnYZb2H2jlYcu17ChpMRe6KE4RBuqEWpWyTz1YQembDo
         BvCZCOWh6hJG3dWGaqglixAFbLvDIaEvUu3uorCJa4A4/6pG1NDu6XTTLKNXyQCAU9nl
         rRJRKOvKcIoB6KeAaOHHAicHCsNKHnm58D6qRhLsyBaG/vChRQOGoiQ7B/p4ejOtToRP
         gVVnW8UNQuu/4YNpjp3g5tTJ1P9Z5/N05P0HwXhPAgqhvOOFA1l9qrcRlex2VDC4Dn1c
         Nm4YU3/3ZMqebYq+hdJTZsQT1eR/mBb5umg9tdIDIZGep9qsBdMjvxKPXRgSKw8wELqF
         HdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hQYYC2TnA8NLtdWvLkwQiO+hUHTcdaTSemyO9tb4ixc=;
        b=KQ9KesQXdCRaXnGkGVflmvch2QUwzSA4bmxaV2jNaJRrTUSiQe+wlD3XTYXxWl5Js/
         +I3hA+F2Jte1DlZkO155cp62OY8WQDNhZASKXC0K+QDDRmq7ezfeEea2L9xdMa1m25Cn
         OfV8oeWoFnd4YhfB8rlCwTktcpA2Yptdda5um0NhwdRTFBeHF5qPUPyc5pRdioMNPCGS
         y/9OpFJAqCE/U7F8DS6NITHQz0rnEel4CDjwXIt/nme3svTQ+mAvSkYdNfFLQGhGm0D8
         bLz8B/HOLRxHHjWtuigLlqasrfdohQDqwTtkTT48or2mwcqrLhVlddld+fSNbjrf+8v4
         H0Zw==
X-Gm-Message-State: AOAM532XE1Bp8T4+4CYZVJpAclAzad7lPesoM4+tqn6jHQLAU/CNwAhr
        LeVUMeYBIm5sW5oStdrJBf3FR4HworsK4g==
X-Google-Smtp-Source: ABdhPJx0QBqMkDar2SxDPwA7VQImc7q5X61jpI2xAyl0g6n2HF6sKFQTJ8jhIXkeXbdLW7WBl0pTfQ==
X-Received: by 2002:a17:907:10c7:: with SMTP id rv7mr2426996ejb.125.1621480817024;
        Wed, 19 May 2021 20:20:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 13/29] trace-cmd library: Inherit compression algorithm from input file
Date:   Thu, 20 May 2021 06:19:43 +0300
Message-Id: <20210520031959.346165-14-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
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
index 2846f7f1..f0ebc1af 100644
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

