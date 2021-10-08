Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BF6C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED7F561073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbhJHEY2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbhJHEY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:27 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9697EC061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id x7so30440353edd.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OplLznRiYNZoJoYX1kaMLf/ADzl46nZzui0VyRKjHlI=;
        b=dqwc/XTYhcPTD/utk3NscaUt/Go+VcrF8yl6XNWrztYz6wVqdBOmk78wBFIYgjfQ1I
         1WR4YIKde5wcY4DVgcw8A/2yciuQZFASDGlvyPJfKtr4Rw6MC6/5ukYXq3Udj4F2Araf
         BM9hLfNF9vja6ZlAHpHR55GqJfMPjkDBSx3wUbcWfRmKMxDm/aGfE8WRrJczABUwSohw
         wOLJGt5Y/CmU1I47KbW8+bLMO8JLizyBFS5DeYw7p69enOygxiTYn9ew8MT4N1v2JtDf
         1zjE1sFFJlNClmWZgkd5l3zbEEB/3s34p574pO6LByYV3ZK+iKsrwgFoUsypGK9V6qR9
         OpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OplLznRiYNZoJoYX1kaMLf/ADzl46nZzui0VyRKjHlI=;
        b=DU3z4g1+8+Yq9zX3LIBzLSoy/XIjOH8Ug+S10OaC7A9hTIvXHdcq0o5qnvLpl6D0lt
         eeonbbtA33fcpF3aQMqwTAf+SKgaTozf1YW4upVdif9jDid0BMP1Wi/jOouNOTwjcpIL
         CQlguacWMUqzzu5u0xP40xlB0tbyVlsrVvI82Sg8kj2svz5SM0pDdh6ll9mbqE5tNr4L
         HtRDMXnJz0Z00VBmjTLi/0OazTmJFSFP3s5IpzJ+boCaebCerhPQQye243pU/LiaJDb3
         Dc6aOlKlmXKlJ98kF6GDH44J4JnpfwYKxYPCtdWlf+AkKGvf6l9N05wA/3IzF/FtC+lA
         1kOA==
X-Gm-Message-State: AOAM533ETIi0T84kaTCQi00Ir3b1CMd8f8DCKYxJuPMrymLieWvKlfSQ
        u+IdgpHEtyhmUeBYeXRCFZZ9oHu2aV7PhA==
X-Google-Smtp-Source: ABdhPJxR5G/ZuGzHRSZcKLVDJBCh+Uq1YAqRAHU/0GVyDgLplvMdZ+bTGW9fD4OjXSUqMv091hmLjg==
X-Received: by 2002:a17:906:c0d7:: with SMTP id bn23mr1362250ejb.426.1633666947218;
        Thu, 07 Oct 2021 21:22:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Fri,  8 Oct 2021 07:22:04 +0300
Message-Id: <20211008042214.977193-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index 35b49ac6..2bac5d2c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3030,6 +3030,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3041,23 +3042,32 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3107,15 +3117,17 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3125,7 +3137,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3184,6 +3196,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3196,7 +3210,12 @@ static int handle_options(struct tracecmd_input *handle)
 
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
2.31.1

