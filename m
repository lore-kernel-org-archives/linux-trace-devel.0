Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDE4C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240110AbhLJLDZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:24 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F07C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:49 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v1so29004174edx.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T30AEnGqNs/0l3fiuhjZCDhcwPjBp3J5XxtplF3N0Xk=;
        b=dIBgBQPPmdsj8xJaCGBUibSksfp1WB8jA9QrIYUnE7g5uRHqtHMYCmGzZaok9j1IRp
         o0EGRsAmG0jfaRosvDjBqrpadNYBP5aBya9P8jZ/8SYDGOoGH4zlSLwTcfBKOFm2tPFk
         DLM47FqjD2h2D/k9G2iuCux/CpJfFVJc2WMcp4HSTNOIUUuQQj8gIyOrdLUsBsiWG+t7
         +IybqXdJxoVCCk/ChfvW3OhQSanFBs0MFPxtPnwGTHtPEUcjdmjJBlm/PrHq20/K+6im
         pjFGMaSFGFG1mw3wp67NlCkcs6m3HD5M75Mc6eyEaz4fSeprG7cERwsNHzwFEwe8/9zr
         fGbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T30AEnGqNs/0l3fiuhjZCDhcwPjBp3J5XxtplF3N0Xk=;
        b=mc5zaXXOVzR/c/4c5kY6Xr89cVvaMuKtfmPovsNo9IEkNChDNrHkMmZQVg1/b+C7el
         8Joc+Hhp8Y1XDpSNsgPxT9KKAMFOXULUyCuw+CI5mte2rSgSataOVuS4JjXNIzHfuXaP
         V/91igKjB/ColsjMeY+ydzTRLQiGSyjaurUs57uG9d6qpyObsMd/YPRo8PKEhGJ0A3Ls
         +VqfoOHkNV0tEot94CGYCu0TkZA0JBgYQkm2WHbQ6XcQl2j5noekHCI8sNkY1nuqXeVL
         yfHAz+jI2EWUoBuR9t8mlXH+o8AZOt+dyNOBa82+uJvNpLum/5jVfI/CgrtGvYm/ATaw
         LSJA==
X-Gm-Message-State: AOAM530TdeLpkSdr9AH8yOoolwuMw5OJaIvweNfOgrkz51FjWZ0cS0LQ
        BDvA8Pe4G5SCpQm4YE8Aiw8OWWIH7/0=
X-Google-Smtp-Source: ABdhPJzpXhjegbrWZyikAy55/nAgt21loBvmAXzwYfZDATDFATnb+0B6xmY2z8relVEi1xLSyAwwMg==
X-Received: by 2002:a17:907:2da5:: with SMTP id gt37mr23186863ejc.316.1639133988584;
        Fri, 10 Dec 2021 02:59:48 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:48 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Fri, 10 Dec 2021 12:59:28 +0200
Message-Id: <20211210105938.98250-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, options section can be compressed. Extended
the options handling decompression if needed .

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 45 ++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index e35e3c74..f35b61ce 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3035,6 +3035,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3046,23 +3047,32 @@ static int handle_options(struct tracecmd_input *handle)
 			return -1;
 		if (id != TRACECMD_OPTION_DONE)
 			return -1;
+		if (flags & TRACECMD_SEC_FL_COMPRESS)
+			compress = true;
 	}
 
+	if (compress && in_uncompress_block(handle))
+		return -1;
 	for (;;) {
-		if (read2(handle, &option))
-			return -1;
+		ret = read2(handle, &option);
+		if (ret)
+			goto out;
 
 		if (!HAS_SECTIONS(handle) && option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (read4(handle, &size))
-			return -1;
+		ret = read4(handle, &size);
+		if (ret)
+			goto out;
 		buf = malloc(size);
-		if (!buf)
-			return -ENOMEM;
-		if (do_read_check(handle, buf, size))
-			return -1;
+		if (!buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = do_read_check(handle, buf, size);
+		if (ret)
+			goto out;
 
 		switch (option) {
 		case TRACECMD_OPTION_DATE:
@@ -3116,15 +3126,17 @@ static int handle_options(struct tracecmd_input *handle)
 							     buf + 8, 4);
 			ret = tsync_cpu_offsets_load(handle, buf + 12, size - 12);
 			if (ret < 0)
-				return ret;
+				goto out;
 			tracecmd_enable_tsync(handle, true);
 			break;
 		case TRACECMD_OPTION_CPUSTAT:
 			buf[size-1] = '\n';
 			cpustats = realloc(handle->cpustats,
 					   handle->cpustats_size + size + 1);
-			if (!cpustats)
-				return -ENOMEM;
+			if (!cpustats) {
+				ret = -ENOMEM;
+				goto out;
+			}
 			memcpy(cpustats + handle->cpustats_size, buf, size);
 			handle->cpustats_size += size;
 			cpustats[handle->cpustats_size] = 0;
@@ -3134,7 +3146,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3193,6 +3205,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3205,7 +3219,12 @@ static int handle_options(struct tracecmd_input *handle)
 
 	}
 
-	return 0;
+	ret = 0;
+
+out:
+	if (compress)
+		in_uncompress_reset(handle);
+	return ret;
 }
 
 static int read_options_type(struct tracecmd_input *handle)
-- 
2.33.1

