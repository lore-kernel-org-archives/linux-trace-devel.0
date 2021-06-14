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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0FAC48BE8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E7B61289
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhFNHwp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbhFNHwo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:52:44 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC47EC061766
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id ba2so43439024edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ul0cYskXBCYyoanWYB1IZdsjLcqgyRalazjxs5buo98=;
        b=tdAbbPcrRdlMxz98cVpyKjBaM3XbOK2kAs+DmShjTvdeeS5TnaeV1sNDkiBX13fO5R
         LLMwihuqhvHrJaFwqVIDfkAZgJscM0Rgd1HppITy2gBxMKdwRE1tiXoHjN73CqeF5BPc
         yuZR7BFcMdHCEz2chDVU334Z6zpSXxUdfDOhRC7vbEmlWaYhIPw+QWHUm1Jv0F+l5cNK
         5FmdqREuq19o/eW7mRWxsZBfBsocrHsm2GuOjzka/xSxm+thrHKpWPXIJEeFfDb3c3b8
         TN1MHqi+QJOY7qkd4qKor31aGCZKzAZvA52dkUOFerwtstZwkdax/SIyOVj6KV3PFHqE
         hwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ul0cYskXBCYyoanWYB1IZdsjLcqgyRalazjxs5buo98=;
        b=Y0PxcvLqwjgVbiL8y0SAgR+27sV9ea3cewsfWZMWQzEHZt396Q/BpufH8Urk3X1dzz
         0vuiob7IWFfC5eBOlNU3nlMJ/M2wp72Tw9DPUWm8xvQdyoOVwEPcUGUVwrU+7eN9GiCC
         0v3HleyjtCBHLqCxwNL3uWXb2u26xT5bLusa2rcZW91Rm9BIowLGuwEMxeH4FNsA61R1
         lnjuybtkq1vMK2VgAohy+UEuwnXuIiJl6m34Gd5YY3jdyodiaC7E9iGIWd9em3Xsq52R
         cGOttCPK9PM1r4Qw2VG0kOmX2Xhl90VJdKXGR8h4kpN/juWx1uhgdTQpj0sfOA+NlIVp
         j9Cw==
X-Gm-Message-State: AOAM530hiL4fk5/8EhyUG9+cS3p2VdVKM9/wIPxEcUL3ZA5J/KXKRfAF
        Ul/Y+vPB+kT41joTxbPlVRze0a5frRP/DA==
X-Google-Smtp-Source: ABdhPJy7wFS/RvAVUEs3nkoIB9WPXMMW18+6/HZi7lnpBwrUQpzBZ0+0vktmu/ago5jDACElZSbF1Q==
X-Received: by 2002:a50:bf0f:: with SMTP id f15mr15429669edk.205.1623657033544;
        Mon, 14 Jun 2021 00:50:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.50.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:50:33 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 02/45] trace-cmd library: Remove unused API tracecmd_update_option
Date:   Mon, 14 Jun 2021 10:49:46 +0300
Message-Id: <20210614075029.598048-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
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
index 4bd36baa..49539432 100644
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

