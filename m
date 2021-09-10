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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04F4C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA50D611CB
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Sep 2021 13:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhIJNwh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 09:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233767AbhIJNwg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 09:52:36 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFC2C061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:25 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id eb14so2581035edb.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Sep 2021 06:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t0i60wVJNEbiS7qNGeKEB4RPbdOSSnoTLH0C5rwDwx4=;
        b=OHb9bFMIOrtQWcPVyTjnywMMjUZgIXY0i8SIfKYRR6vFDPtYa8pZYKSI5YO+Y2z0Fn
         Fy4Y4kTpP7AGcJFKIzkep8BDjs4QMmXQiZ7YjVZZOQPAyFvmoIoqrSqbzbLnbIic4XGe
         QtXnX9b8DfDW4ABrpG4TgKDTuup4UI3uBNuGjDYabp+HZ8dm4vQHLg4WAh/5XQi/lsx4
         kqHvWVU3x9FiK2nliTi0PWPhcReaUCZgeOrrvOn6AoL4tnACmuf4Xndg6EU8elKSQ0ef
         VSsCzGmFokX1sPgl9x6Qk5Deh40vguWSVLOxm4BJqav7tjAgyR6X7RSryqQszD/9125+
         Zc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t0i60wVJNEbiS7qNGeKEB4RPbdOSSnoTLH0C5rwDwx4=;
        b=hou8rm7Ega97X9WE2iIBc8tFQCdhutvrIPV7w2EvzgO9W9tgaOLsyE7EypeHm+KGy2
         0ylvIparctRycmqodkJUF8rHa8Or0OrfdYbYChGkfBLUo0PyBESdzMCbpva8P+qdxOhg
         Ffbj90i1M8O5dKZ0Py+rxPvIyPRzP24tdx0Zwhb1D5yguTLW0f3NCiLLyNPisQlhvUy+
         g5NyQ7qvOUEyxy7CxCifHw9kmqThXr5St7anjHREgv0BEv4Jg1TsoEyx65eBqO0NDZyu
         f7qYhRlWO7TuE6+/BdtGFcZ6JPhS6KjMG0og7n0wwEjpkHc59gZpZGoOedcthFAgY54P
         VwWQ==
X-Gm-Message-State: AOAM533altqgZjUEBGef0KEFLyyRGMjAawJmny8ii+mbtkI2MluRDw5s
        8lEQ2of6m0cxoWMW93ITaPh42Ha1PzY=
X-Google-Smtp-Source: ABdhPJxS+/2d8d5bD/cuiCdsHSXpcqQLOn1m0TvUx1+cB6rhKyynlvYY6ywImBNeXv+53R8uM4Umpw==
X-Received: by 2002:aa7:cb86:: with SMTP id r6mr9084991edt.181.1631281884326;
        Fri, 10 Sep 2021 06:51:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w13sm2484683ejc.100.2021.09.10.06.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 06:51:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Fri, 10 Sep 2021 16:50:58 +0300
Message-Id: <20210910135101.2865226-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
References: <20210910135101.2865226-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 57 +++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e0f149ee..8059aca5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4481,34 +4481,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (!HAS_SECTIONS(handle)) {
+		/* Save where we currently are */
+		offset = lseek64(handle->fd, 0, SEEK_CUR);
+
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
-
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

