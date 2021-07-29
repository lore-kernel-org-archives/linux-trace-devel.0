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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68026C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522D460EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhG2FLC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbhG2FLA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DEBC0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:56 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ga41so8409769ejc.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ybeGOAZKYXmJFsd3anpx3SK0c5hb8fOH9icHxAb15T0=;
        b=FVhfzGbf86ycrUQ483b4ZLwyonl+uCQR4qtiNGAgKlNm2CsNpJCzXF07E2Mk6hRt32
         adezeRg5xW+zdnEJMl8Q0XfcmesT4YceSdlGvjsmrW/kPDNTzoV8fzDFpIhQILz+X0t4
         8Ux7ah+Mh15eupDmPReGlQxKA5OTQcEbKYSpS9naDJ+Hs/tXrsDG4be1mrn48wKgi2OE
         G29IN0+7rkdaUqOhORCjwN6IUv7SWEDPGk6wBJBXwX08kQ0VSjr7d/YmhFY1w4W0AgP3
         7v0dDhCW60UnLv9a2Ayes32epJ+dOiQ9Cbr6wi1/9b622SGzredqlU42jmNyuQu23XX4
         6woA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ybeGOAZKYXmJFsd3anpx3SK0c5hb8fOH9icHxAb15T0=;
        b=Jw8+gilSNJy21cKPcx2ADLS65HBRW4764LYq9XO2CzdSxJh2S68zFRAZ8Dq+oKJ5pO
         IOkqOsOSFnmsKfKdR3daXgyG64yDZLqclP2SgWPeWTdxdBSLQL1geIMj+njY4Z6TJlLG
         9mxrWnOuoqWw62IQ2H0duWA2ySq6kcORzCEcIM9GengXkE0J3Zu7rDNRMeAYiNVXzPtn
         boGF8y6eSrFbtaCCOfDRCmVyBGzWn9KMg5O/wYhijLZyBqBRUyY2MNgyCs99SWXiVkzT
         G+/n1Gnk+S59aatzi9naQOG54t+SY01o9a4XpYPOAopSzfAOobWx/bsS1JbkTWzqHGrz
         4yKA==
X-Gm-Message-State: AOAM531C38yvlAS8GdOfnZb+RmxJdOAVggyT4sAUOR8+TtebGnmedvl9
        zfONBffV4a8qNDE6JMq4yqBusXNe5vt+Hg==
X-Google-Smtp-Source: ABdhPJzUykfp96uCxvkG5AgN8IWYfas8e/dLKSQsrgIXACkm5F6p3EFo4yFWZNvSxDvbSoripEagcA==
X-Received: by 2002:a17:906:2bd3:: with SMTP id n19mr2963201ejg.232.1627535455650;
        Wed, 28 Jul 2021 22:10:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 56/87] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Thu, 29 Jul 2021 08:09:28 +0300
Message-Id: <20210729050959.12263-57-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index b9340160..2b98e6d8 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4809,34 +4809,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->flags |= TRACECMD_FL_BUFFER_INSTANCE;
 
 	new_handle->pid_maps = NULL;
+	if (handle->file_version < 7) {
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

