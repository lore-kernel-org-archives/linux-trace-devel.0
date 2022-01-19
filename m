Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEA5C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352405AbiASIZe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352406AbiASIZe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:25:34 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1A9C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:33 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m11so7404855edi.13
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:25:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cKB2R3K8A3E5rbF1P/bWmGpEwbkcmZTpoDw4W+286aQ=;
        b=aTlr6NOWQlZ3tNBBtgy5H4ya6Sk+OaFU7zIVeW/839vqmgzChH4fUiC9BBkmW88Djm
         Y59rItqvX+uz4kW65IwEvPYzGqZp0K4RHiEXQJDBUCXJfiHw7SDJwzFOULdc3YkPaWwe
         lpnApLTtrkFocOIiQ5Rd94Z3YCmB175L1THxXtayv2gJI0ztKa7N+v+IChZUGg2NO1rV
         K34hyKxk49zzTtkYxacIDrdH0qRouMhhzK0r5xiWCx/AH6LMHgBoToBsSTr3yanRsnAK
         jL7yv07k841+FMkM5cTpihRoWqrOi4CqlXfyJEPKtFwah9RYMlBwDvS1Wa01yX9vNakR
         TOtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cKB2R3K8A3E5rbF1P/bWmGpEwbkcmZTpoDw4W+286aQ=;
        b=7eLAQMNFtA93Py+RtujBhtb2t98S2dA5dTXJWGqH6AYNYMqBeXRH4a6UGR4KyfPpry
         DJSeVzyZDFaxG6xwt38VQ05Uftwqi3MRY7IfAlMLM+3uA2nslt6xeiG8yOint+X8uAcO
         ZKGRSTN/3sFcAfPhLxnmhxgp6vsQZ49Rw5iQsNjjNWmMgvrvtzUaE1OfWHWc6n/rDokX
         6LAOjy3jatsJF03tCFXHYZ2L6Bk87vE3mPbMG7IXnINDnJsi5CRds5ZM7HiH55z9IoJj
         u4g7AoptMsdgw+gCLg42uPlgsNg2h4JIDsu5g0i5qd/xfAbyAETMokl1eWE3JCWXESZW
         6J5Q==
X-Gm-Message-State: AOAM530SKqkJE3QT+iTwDEJyOMouF93M6ob+XAd3n3TjXsserz4TxSJ7
        RvaQP8RoJqRomw/bn14BMb6HSu2Lv3k=
X-Google-Smtp-Source: ABdhPJwWdLLIxKV8eJm3qbKN/QthSStLzDhemK//aP0i18pYLpGBbyS4/zTo5Ot3rjK4ghBAs8FX/A==
X-Received: by 2002:a17:907:9687:: with SMTP id hd7mr23283173ejc.12.1642580732428;
        Wed, 19 Jan 2022 00:25:32 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l1sm5011122ejf.44.2022.01.19.00.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:25:31 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 22/25] trace-cmd library: Handle buffer trace data init for version 7 files
Date:   Wed, 19 Jan 2022 10:25:04 +0200
Message-Id: <20220119082507.245600-23-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082507.245600-1-tz.stoyanov@gmail.com>
References: <20220119082507.245600-1-tz.stoyanov@gmail.com>
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
index 6f540c90..ecb56826 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4534,34 +4534,37 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
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
2.34.1

