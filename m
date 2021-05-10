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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0066C433B4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F08610CB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 10 May 2021 06:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhEJGRr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 10 May 2021 02:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGRq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 10 May 2021 02:17:46 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D91AC061574
        for <linux-trace-devel@vger.kernel.org>; Sun,  9 May 2021 23:16:41 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y26so17307779eds.4
        for <linux-trace-devel@vger.kernel.org>; Sun, 09 May 2021 23:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dR9cwZyRjBzKaGdEXi13MgximQSnOMDkCL1jWfZl6fY=;
        b=kwpGKqeY8+ZGdB5KDOTlrObmpS+mlQHvoNZh0M+lWT/Xnyiq+pSuxx2yeqFv5OnWvG
         ZEIoYPLGlEl+3Ull1i8Y5p2XQyE0EZJMEPX9wm6bf4WC3h5PJZGtZF+OeIZG9srO9z1j
         7hXqJIlBjAdJYOhCyIbvfprktyAaJeOS2POx6Ju2IdPFpJ41nFAOo69YvBTC+PCL0GIS
         kQE2At6Js9PZZHgDbTJZWdRqItPetnZ4w3nmOlrBhx2GdF6pUC2orCfPqo8c42/tj5tJ
         9EU6aRArzr6r7AoFk1huatTPxCKjosvzYzEm++vzJ1rYAVBHdwVFrZErs20MFhqwpogM
         PRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dR9cwZyRjBzKaGdEXi13MgximQSnOMDkCL1jWfZl6fY=;
        b=qmIroYdrK6t2Fb1uZotifTwcnDDTGmr0Ccrxu8zG4UsR3l9sonA4V9veUMq6t1QNCm
         kSIPPocq0TI5svChum/zYGKaByg1lTs38GH+DOyb0xb7MwuUa8L1DKqGTMnAcXcdeh5t
         0tKgpaAeCKB7O6pAz0U0KxzxQ2fyicIiN7E0qWsvcoYwYGGudQ8ptikmiz9JNqRcbIlP
         W8cEa1lfoT/D1OSSIAKi7+v3fgq6O/wsDc7FB6G7ZPhGPMf2dL1Qxxsfgz/n9N9t9/CM
         A+6UxxCGbdzOlIBi74imP81C/gjlvYFYsjvpMtWDMbXiLQCfNqASY0oLSVW2ta9ZWpoE
         I/IQ==
X-Gm-Message-State: AOAM532pepIQOHMzMQ2jMp4qyKftyLnyZbKd0QoIu+G+WSxgWZy3jPCz
        9q33U9lih5/Mz4pMrC967OM=
X-Google-Smtp-Source: ABdhPJzk+r8lQw02UjPVqXmSTE2oKmS5I9bvnDqGulU4QgAfnRf+HEq3gRomuAVqFxaKhYvZdccufQ==
X-Received: by 2002:a05:6402:6d9:: with SMTP id n25mr19348168edy.229.1620627400075;
        Sun, 09 May 2021 23:16:40 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm5055205eja.25.2021.05.09.23.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 23:16:39 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 02/21] trace-cmd library: Remove unused API tracecmd_update_option
Date:   Mon, 10 May 2021 09:16:17 +0300
Message-Id: <20210510061636.1794357-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
References: <20210510061636.1794357-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Removed not used trace-cmd library API for updating the options section
of already written trace file:
 tracecmd_update_option()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  3 --
 lib/trace-cmd/trace-output.c                  | 40 -------------------
 2 files changed, 43 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 8ec33ea2..ecd172ca 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -290,9 +290,6 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus);
 int tracecmd_write_cmdlines(struct tracecmd_output *handle);
 int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
-int tracecmd_update_option(struct tracecmd_output *handle,
-			   struct tracecmd_option *option, int size,
-			   const void *data);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
 struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9231c319..c0aa58cf 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1229,46 +1229,6 @@ int tracecmd_append_options(struct tracecmd_output *handle)
 	return 0;
 }
 
-int tracecmd_update_option(struct tracecmd_output *handle,
-			   struct tracecmd_option *option, int size,
-			   const void *data)
-{
-	tsize_t offset;
-	stsize_t ret;
-
-	if (size > option->size) {
-		tracecmd_warning("Can't update option with more data than allocated");
-		return -1;
-	}
-
-	if (handle->file_state < TRACECMD_FILE_OPTIONS) {
-		/* Hasn't been written yet. Just update current pointer */
-		option->size = size;
-		memcpy(option->data, data, size);
-		return 0;
-	}
-
-	/* Save current offset */
-	offset = lseek64(handle->fd, 0, SEEK_CUR);
-
-	ret = lseek64(handle->fd, option->offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", option->offset);
-		return -1;
-	}
-
-	if (do_write_check(handle, data, size))
-		return -1;
-
-	ret = lseek64(handle->fd, offset, SEEK_SET);
-	if (ret == (off64_t)-1) {
-		tracecmd_warning("could not seek to %lld\n", offset);
-		return -1;
-	}
-
-	return 0;
-}
-
 struct tracecmd_option *
 tracecmd_add_buffer_option(struct tracecmd_output *handle, const char *name,
 			   int cpus)
-- 
2.31.1

