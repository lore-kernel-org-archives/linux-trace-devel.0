Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36210C4332F
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357784AbhLBMXU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357749AbhLBMXT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:23:19 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FE7C061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:19:56 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id o20so114524267eds.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qkFWA9m/wPNbT3BwMwBPVrSzD47LALII3aAmqKi2ek8=;
        b=axE/gtvGic8WYiPfE9Sl9zGPsqY8TaHq/NmoWUJnqkDs5n5vFqHq2kvKujYMZcx3jv
         KPSrNSEVJDFHOLO2mD//d+TO9vuRSuX/jTTN9IOZXhYaDAgMjqnXzn8Az2R+iRHRaxSB
         VWOn7D6o6gG2DUTGpqccL3YjyaWfT+x/IAj5Ilk3WGYDMHv60CQVdSa2gbrc7Th7xsMM
         Y2Ykn6y4F3cQs99oyBesLKhF/KrHTPew/gJKENNoW7Lk94x9wFATiOHAios6rv7dCq1Y
         pg/Zurqdidi31bVkc78r6Ll1dVXcTt0ZtES3hg8baaxKUTAOgkiLxiL4ia9hF3P3xVV/
         8noQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qkFWA9m/wPNbT3BwMwBPVrSzD47LALII3aAmqKi2ek8=;
        b=Y609A+o2vdK1CzzzD2IbL1abVKhU9BjPtl9k8eUrFUkHei0HMQhWkdUpqQA2+BM2m8
         DUKnjSZzgY0X6jT9LmF2eKPx28NJqdddfGNJ/tPSS/rPLnu0XaKSk+PTRnSw6EjFOD/M
         R/Nk8fqPOZGvcdmtsmZJdw/Z0bHdiIFuvaE+rpyIAEh5ntyuwm6B6WA8Q68cAmBj71//
         w5qYFe0ro0XygOppUgea97rl0+/MYg/5x0qaa4XbWRxAQged1dAJdVcpHFhC4EpJFC25
         Z0wTclmkjVHMCHfUr1iPYmeZ6CgTb+wFoXNdydFvviD7BzcvQhbmaQFrBuQC4xnMp/hk
         Ahnw==
X-Gm-Message-State: AOAM530Z7pM9T1IYHWVdIS9Ntwr2zmVrtCaNrD81nu+idpLejh/7fcZu
        lqizmwRaCzzv74+MMrHlB8mNtz3/QiFwfA==
X-Google-Smtp-Source: ABdhPJy2/yXDi65R+ZtIdbyaRk//dtRHPn4kRiWKYvujzqK9u2/BXXcUOR3MpAMcGolkqGpdyS6HAg==
X-Received: by 2002:a17:907:3f9d:: with SMTP id hr29mr15376242ejc.369.1638447595359;
        Thu, 02 Dec 2021 04:19:55 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm2229019eda.13.2021.12.02.04.19.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:19:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/5] trace-cmd library: Remove APIs for create and init output handle
Date:   Thu,  2 Dec 2021 14:19:48 +0200
Message-Id: <20211202121949.43084-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202121949.43084-1-tz.stoyanov@gmail.com>
References: <20211202121949.43084-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

These APIs are redundant, their functionality can be replaced by
existing library APIs. Removed them, to simplify the API set:
  tracecmd_create_init_fd()
  tracecmd_create_init_file()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 --
 lib/trace-cmd/trace-output.c                  | 36 -------------------
 tracecmd/trace-stream.c                       |  3 +-
 3 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 79196147..069283c7 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -281,9 +281,7 @@ int tracecmd_output_write_headers(struct tracecmd_output *handle,
 struct tracecmd_output *tracecmd_output_create(const char *output_file);
 struct tracecmd_output *tracecmd_output_create_fd(int fd);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
-struct tracecmd_output *tracecmd_create_init_fd(int fd);
 
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file);
 struct tracecmd_option *tracecmd_add_option(struct tracecmd_output *handle,
 					    unsigned short id, int size,
 					    const void *data);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 067deae8..a20e42df 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1828,42 +1828,6 @@ struct tracecmd_output *tracecmd_output_create(const char *output_file)
 	return out;
 }
 
-struct tracecmd_output *tracecmd_create_init_fd(int fd)
-{
-	struct tracecmd_output *out;
-
-	out = tracecmd_output_create_fd(fd);
-	if (!out)
-		return NULL;
-	if (tracecmd_output_write_init(out))
-		goto error;
-	if (tracecmd_output_write_headers(out, NULL))
-		goto error;
-
-	return out;
-error:
-	tracecmd_output_close(out);
-	return NULL;
-}
-
-struct tracecmd_output *tracecmd_create_init_file(const char *output_file)
-{
-	struct tracecmd_output *handle;
-	int fd;
-
-	fd = open(output_file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
-	if (fd < 0)
-		return NULL;
-	handle = tracecmd_create_init_fd(fd);
-	if (!handle) {
-		close(fd);
-		unlink(output_file);
-		return NULL;
-	}
-
-	return handle;
-}
-
 /**
  * tracecmd_copy - copy the headers of one trace.dat file for another
  * @ihandle: input handle of the trace.dat file to copy
diff --git a/tracecmd/trace-stream.c b/tracecmd/trace-stream.c
index b47b208c..ee310f3d 100644
--- a/tracecmd/trace-stream.c
+++ b/tracecmd/trace-stream.c
@@ -43,11 +43,12 @@ trace_stream_init(struct buffer_instance *instance, int cpu, int fd, int cpus,
 		tfd = fileno(fp);
 
 		ofd = dup(tfd);
-		trace_output = tracecmd_create_init_fd(ofd);
+		trace_output = tracecmd_output_create_fd(ofd);
 		if (!trace_output) {
 			fclose(fp);
 			return NULL;
 		}
+		tracecmd_output_write_headers(trace_output, NULL);
 		tracecmd_output_free(trace_output);
 	}
 
-- 
2.33.1

