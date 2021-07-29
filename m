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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD16C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471AA61053
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234027AbhG2FKz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbhG2FKy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:54 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1C8C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:51 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id nd39so8464955ejc.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PFUx3VZDL9ywcEd2YoUZx8iPFOxnYwsl8veVsUh+7fw=;
        b=G9QJbtWjmcKJj2ayUXwpOP06+FKr7vjLGxXtakyXfuBWjoIBA/kulRZRJGEiF5SNHw
         rIllQ7X8+P6N6EIRTE6IoYvBNqfcyOSUjn7rxMUeLWODAE1fTO6sRkYVjWdV9OHDMUpc
         /9zUZfxZL68VKRuJdyVAbGXc6hb7fcFfS8AYXV810wKiMOgQHRtL/58hdnn0O/n9Ut10
         ZAl/pyiN24gOfs5abPMpUGTRiN1FiPdhXqYX3xIg8cZwGkmnRYZoPp+GBEEtDFHEVQn5
         wQoi7dVYvLsh9wXbdMQDbpXezI7tlZG9KbyTqAXx+/IOqlUENsnAaHHjXsl6KmW8ASpI
         WeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PFUx3VZDL9ywcEd2YoUZx8iPFOxnYwsl8veVsUh+7fw=;
        b=W/BIM7naP34W3MAYjurSv5vf0qIQ3iLDaT+lExxLn9Eq5ezoI9gANTxpQvBp3yWXa0
         xVXdKq3Xpgiv6RL9HZivh4vOWNWdXmp42MUyyDaBXhKKU8At9Zkgfh/DE0FBhJUO2nV1
         nqKImIov0gqruqxec1JGUX8D09WSE4JXbz2sGdFQYlRVoBW4wM3w7Pso+97TtMbmIba9
         EvPLVmg6un3pANNdNJZX0dA5Pe5E0mMXrtpRp5tA8A2bDS2qZCTNjBMpY0b1ZAnMXyA0
         J+D7YQVHiV1T1f37j3OUEClkuC4vKBHtgSbV52RK7RIqzJQ9hROQ5NAGvPz2yhI9+PqL
         0zhQ==
X-Gm-Message-State: AOAM5300/whP3okA6y2zC8AOpRgPMO2mvbNS6pcX120eqghZJZPuFjT3
        MuGZolVghh6EiOK+rgMcLME=
X-Google-Smtp-Source: ABdhPJxqOoczRtXUNa33xVcPuWrDHM9i4Sa7GRsuJ0MJPTGxUQOfQX5Cs3kEeYAoFMo+Egu0RejbOQ==
X-Received: by 2002:a17:906:8152:: with SMTP id z18mr2903267ejw.419.1627535450053;
        Wed, 28 Jul 2021 22:10:50 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 50/87] trace-cmd library: Read compression header
Date:   Thu, 29 Jul 2021 08:09:22 +0300
Message-Id: <20210729050959.12263-51-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Trace file version 7 introduced new mandatory compression header,
storing information about the compression algorithm used to compress the
trace file. Added code to read that header and to initialize compression
context according to it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9ab20d64..520d611f 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3684,7 +3684,9 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	char test[] = TRACECMD_MAGIC;
 	unsigned int page_size;
 	size_t offset;
-	char *version;
+	char *version = NULL;
+	char *zver = NULL;
+	char *zname = NULL;
 	char buf[BUFSIZ];
 	unsigned long ver;
 
@@ -3723,6 +3725,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	}
 	handle->file_version = ver;
 	free(version);
+	version = NULL;
 
 	if (do_read_check(handle, buf, 1))
 		goto failed_read;
@@ -3752,11 +3755,38 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
 	handle->total_file_size = lseek64(handle->fd, 0, SEEK_END);
 	lseek64(handle->fd, offset, SEEK_SET);
 
+	if (handle->file_version >= 7) {
+		zname = read_string(handle);
+		if (!zname)
+			goto failed_read;
+		zver = read_string(handle);
+		if (!zver)
+			goto failed_read;
+		if (strcmp(zname, "none")) {
+			handle->compress = tracecmd_compress_alloc(zname, zver,
+								   handle->fd,
+								   handle->pevent, NULL);
+			if (!handle->compress) {
+				tracecmd_warning("Unsupported file compression %s %s", zname, zver);
+				goto failed_read;
+			}
+		}
+		if (read8(handle, &(handle->options_start))) {
+			tracecmd_warning("Filed to read the offset of the first option section");
+			goto failed_read;
+		}
+		free(zname);
+		free(zver);
+	}
+
 	handle->file_state = TRACECMD_FILE_INIT;
 
 	return handle;
 
  failed_read:
+	free(version);
+	free(zname);
+	free(zver);
 	free(handle);
 
 	return NULL;
@@ -3952,7 +3982,8 @@ void tracecmd_close(struct tracecmd_input *handle)
 	if (handle->flags & TRACECMD_FL_BUFFER_INSTANCE)
 		tracecmd_close(handle->parent);
 	else {
-		/* Only main handle frees plugins and pevent */
+		/* Only main handle frees plugins, pevent and compression context */
+		tracecmd_compress_destroy(handle->compress);
 		tep_unload_plugins(handle->plugin_list, handle->pevent);
 		tep_free(handle->pevent);
 	}
-- 
2.31.1

