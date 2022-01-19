Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2887BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352454AbiASI13 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352448AbiASI12 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:28 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688EDC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:28 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f21so7482327eds.11
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OdwH4YxJAeE+ENYL/y4J+2dMWHNLN8/7e0aIdw/5UEs=;
        b=Pg8Kd/6zm84Ky88k6xkiXZZH8QH2d+ggcy7TFjHWXBrA+C+XxIIsrESumcweQVGCVr
         wmy32CLLbJc1sQnqfRVqgl6ugSq6O8RtOBsbaxHb4YGxLCoVeo4KocXMmPakDhtfgo2J
         r2VPs+wF66IKBSzJp4fPtrkRWtlTz2PRGbBZrAqPC+46cXDV7hLSHYriOq4dxAjIPzgM
         B6lokGzfS49BxeDlcGMKd+OyqoZDepTZReiDoKNsZ5oaw8kipjffOlWU1+Q8JCg4q15n
         SnflVNZiYVTGSPHTXVSEz+GFo6jxw6A2YFHlPCs9XjstxzweWbhKe9oMz+b5peZn2Kee
         fS/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OdwH4YxJAeE+ENYL/y4J+2dMWHNLN8/7e0aIdw/5UEs=;
        b=KufvaKln7f/8ZL4d+Fk8CPevYpG51+XUIsDm6T6NnBKIgeAWDUp12MmV2UIM7X731J
         UjKGvbQDAWR7F+ex/z7TLCLpIjeXvxGkeDXdMy3wpS+Ci+BkxsOJZkAY9WpqN9z28tf0
         pCKIzUyUN0qqOoxXp5eyFWGY02ftmRWDDB9Lr5aYYAF23BPWmwGGoMzyPIpFFkD+RtAz
         P1V8DfRrPJA8zUwIKUEKIYkRho3a9SVQr+IiYob5d6849e4S9fVHY6MfinlA3pBZH48D
         GS2wy75DxyTAU7SKmYtzvlE2O6kW92P4S6jbh78bzg+iSbAE3PWeUyt1/8LTvH9gOW6s
         RttQ==
X-Gm-Message-State: AOAM531jHI+tPsQ2sGRBTenZUlhKDcGUJjevojoEiehYqczOSnGPHz8l
        e7R6O2oad6KfGIn9WRpUU7aV9eYJR24=
X-Google-Smtp-Source: ABdhPJzDpKUU2mZQPmWepgJhtmSkiGwNJeujjQZfX2Xl9I1XOeKJuPKl+qSe9gCUEvVoOntZtaUm6A==
X-Received: by 2002:a17:906:4a4d:: with SMTP id a13mr1437214ejv.744.1642580847042;
        Wed, 19 Jan 2022 00:27:27 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:26 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 10/20] trace-cmd library: Decompress the options section, if it is compressed
Date:   Wed, 19 Jan 2022 10:27:05 +0200
Message-Id: <20220119082715.245846-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index a81112f0..d5295c98 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3045,6 +3045,7 @@ static int handle_options(struct tracecmd_input *handle)
 	unsigned short id, flags;
 	char *cpustats = NULL;
 	struct hook_list *hook;
+	bool compress = false;
 	char *buf;
 	int cpus;
 	int ret;
@@ -3056,23 +3057,32 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3126,15 +3136,17 @@ static int handle_options(struct tracecmd_input *handle)
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
@@ -3144,7 +3156,7 @@ static int handle_options(struct tracecmd_input *handle)
 		case TRACECMD_OPTION_BUFFER_TEXT:
 			ret = handle_buffer_option(handle, option, buf, size);
 			if (ret < 0)
-				return ret;
+				goto out;
 			break;
 		case TRACECMD_OPTION_TRACECLOCK:
 			if (!handle->ts2secs)
@@ -3203,6 +3215,8 @@ static int handle_options(struct tracecmd_input *handle)
 					      tep_read_number(handle->pevent, buf, 8), 0);
 			break;
 		case TRACECMD_OPTION_DONE:
+			if (compress)
+				in_uncompress_reset(handle);
 			ret = handle_option_done(handle, buf, size);
 			free(buf);
 			return ret;
@@ -3216,7 +3230,12 @@ static int handle_options(struct tracecmd_input *handle)
 
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
2.34.1

