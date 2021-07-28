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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55822C4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AE5C60EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbhG1Ndq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235325AbhG1Ndp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:45 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2A8C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:44 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id go31so4629840ejc.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktdh3gE2kcZr2Wha2HZXIwaGhzNkGiNC+DBLrZlZA1Y=;
        b=Hc0CEcBxQW1ssPsp83uDqZlUmm1k8lPcGLNgj/kpwzgFqa/Fo2o96dAqFvV72aZ/uA
         /V0niRfoFAgJuCpkwFMBfJ4SIB4zydp6ejI2+sVrCd/F3s/+Zay6ci0x6CRWa7js9Wbz
         Vil/86BdWU5kk1fPJja7Tg6h+pPSG5rRz7DOtRs4pkcJCmoBQZ7435WeFPNNJTLJ+iI5
         U4r/SvmG14PA4ka7q/0Cf5FF33HC3UPa2PTlguvKIaG824SPEKUV5kNQ/KIQ/riraSdI
         IN2i4uQ0sYAZvAlCtAlRaMFApMCSh/SpaptBsx5h15peCsYbeM9i/JP/TDvDhPRVhHZ9
         xSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktdh3gE2kcZr2Wha2HZXIwaGhzNkGiNC+DBLrZlZA1Y=;
        b=uP6w1ZTUsaQTZA+zhSHdz4AOi/eyVQNVDTw6MHJh8gGXER/ei29byKZYWWjzXl7Vy9
         SwBkj3s7Ek5sQWihQN6HTf5ls5hkY3nWPuF9Ppeo0159LFgTUDulx/NNnOed+aCfYzy4
         ptdbRKCis36wW+HfQA7P2zU+DWUEvie5P+6E5WAsIyXj665NFmnW4VhSY69UvDfbb20M
         zGwdG90rbQOy3UOesAtJu8FGF/lLH2XrWhWQZwnrZxevAQp55TGA0yC0k9M26f0ZT+7+
         AiVk5klKTypm5xeiyptOyf+IuF4oLdkni+Z1s+w9ggsEvXC8g6ciueb+Ac781nOcqGu2
         TOcw==
X-Gm-Message-State: AOAM532Bmfmv/4Eh4Lu5h2cAc4/uZXqbs3XG+8d44g6VlzMOE3N44KqJ
        +8fhgcrj3+fosjjCRatLzzk=
X-Google-Smtp-Source: ABdhPJy+4ujQize8o9Hb/H7yeD9yYf05gaufLpOGxlpO6PpHfS7tJz9ywMmV+JCnQkHwDUVLwfoOvA==
X-Received: by 2002:a17:906:f112:: with SMTP id gv18mr12854343ejb.439.1627479222890;
        Wed, 28 Jul 2021 06:33:42 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:42 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 50/87] trace-cmd library: Read compression header
Date:   Wed, 28 Jul 2021 16:32:13 +0300
Message-Id: <20210728133250.234140-51-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 795ed9e1..5ee0adcf 100644
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

