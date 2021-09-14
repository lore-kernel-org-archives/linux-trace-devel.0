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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36337C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20966610CE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhINNQ1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhINNQ1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:16:27 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B04C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:09 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q26so20142393wrc.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0qAKbxtjAIFzjl3AZiA9q3wc6jSusXtRRz1WPI5jw/Y=;
        b=NOk8R/mHv/qcEYjcGOKJ5mgavaksIWuUpVwEMdJJqT6b7AdFiFCYIdceBMPQ235llC
         /LkxfxLRUOuNbsOXHByLPcLvSsnCSALpggVsQY70GbRbWQoSnxZt4lsfbOcO6UgFFdey
         +FZeuufnVY4h8kZJ3kf+hSVdxe9UBKR7KtGRAXPejCsrP/9Q7BpIKFR3cj3qn+2UQo+i
         5NNDFz0kz9rrxWTn8MfI3o4zE7r/lWCWf8vtzDNpa0gKSZJjwzx1ax+eH02qu0QmSNfH
         fyicNwSD22suPe6xJUhoUPX7J+Qt1ApKGN9rWu/DS4vo4/P9vIAQhsCN3v7WBbm5mtAj
         +9mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0qAKbxtjAIFzjl3AZiA9q3wc6jSusXtRRz1WPI5jw/Y=;
        b=xn6WpVab5fdNS7/kvc68jwpowL0sVfuOqzixEunNL64SmgKFKIT33iUWRF5MQbKEmI
         7Fkk6lZ/WGWyanWtK6M9vd27qYXDonZbEzYx48R54uLED8QcE4mNiX+mLZ594yGJ/yFp
         C/KoxSg10H/Kbu2JkrqXl6kChPgiuw0V7M+3rem4Cqe4R6IYkTvX+q9Y3VaYVOAuTggE
         hR7CjrWgnPeOXIV/4aeznsm/pYkfBbBmfUNEeWQE13daxFp72aohMzq1ELhJD0J4STOZ
         cBwMTAmWTYZUcEmIsD/N2xNyM868LKhAb5+ufgH/C5LFjgkY0iwx//3jQLr5Y7x42j6l
         i7oA==
X-Gm-Message-State: AOAM5318IQmavG41nCCYCJxfvdLc9M6yljgKte7t64viymvicdMO1uNc
        SOSdnO0i6I8M6pu4/dZpscffKUWnzVo=
X-Google-Smtp-Source: ABdhPJyccK+zTcdeo9mAScRI+ClI5LcbIxqgLZymrY3tg8MdTkcDo9yWO+HM6eMEECTjZw2RyLIqUA==
X-Received: by 2002:a5d:5408:: with SMTP id g8mr18996378wrv.34.1631625308511;
        Tue, 14 Sep 2021 06:15:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y9sm1274760wmj.36.2021.09.14.06.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:15:08 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Tue, 14 Sep 2021 16:14:35 +0300
Message-Id: <20210914131438.3965484-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
References: <20210914131438.3965484-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

CPU data initialization is different for trace files version 6 and 7.
When a new input handler to trace buffer is created, initialize the CPU
data according to the file version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 55 +++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 1b4a4d6b..222b9c89 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4481,34 +4481,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
 
-	/* Save where we currently are */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to buffer %s offset %ld\n",
-				  buffer->name, buffer->offset);
-		goto error;
-	}
-
-	/*
-	 * read_options_type() is called right after the CPU count so update
-	 * file state accordingly.
-	 */
-	new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
-	ret = read_options_type(new_handle);
-	if (!ret)
-		ret = read_cpu_data(new_handle);
-	if (ret < 0) {
-		tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
-		goto error;
-	}
+		ret = lseek64(handle->fd, buffer->offset, SEEK_SET);
+		if (ret == (off64_t)-1) {
+			tracecmd_warning("could not seek to buffer %s offset %ld\n",
+					  buffer->name, buffer->offset);
+			goto error;
+		}
+		/*
+		 * read_options_type() is called right after the CPU count so update
+		 * file state accordingly.
+		 */
+		new_handle->file_state = TRACECMD_FILE_CPU_COUNT;
+		ret = read_options_type(new_handle);
+		if (!ret)
+			ret = read_cpu_data(new_handle);
 
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret < 0) {
-		tracecmd_warning("could not seek to back to offset %ld\n", offset);
-		goto error;
+		if (ret < 0) {
+			tracecmd_warning("failed to read sub buffer %s\n", buffer->name);
+			goto error;
+		}
+		ret = lseek64(handle->fd, offset, SEEK_SET);
+		if (ret < 0) {
+			tracecmd_warning("could not seek to back to offset %ld\n", offset);
+			goto error;
+		}
+	} else {
+		if (init_buffer_cpu_data(new_handle, buffer) < 0)
+			goto error;
 	}
 
 	return new_handle;
-- 
2.31.1

