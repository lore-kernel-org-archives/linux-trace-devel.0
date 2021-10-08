Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CD1C4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DE9360F44
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbhJHEN1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhJHEN1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:13:27 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0B2C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:11:32 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d9so7303297edh.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DoYYYzDpvuTeIVBq4MF/XOYQ76lu0LvjPUPbkLzOMhE=;
        b=E4bUBmJzEbIXT1N7gQKb90kkjaLNtdFchFTKQnsQyA1APIAzlVFrXivmjnupJ5kodV
         ufIrCttIMdq0KBrNGiLcRiSgkycsVSNS0v4BpxkHt4GTn6X5yK16iS7oZ7fvTKz3UrnN
         lo6FUzzF+0t3WZ9EFjmInkCkhJ4Mjv8hwktr7WwXSQXL26waCBnEWZF/BhNsyD+6y5Uf
         6xbOSX/mqh2o+lLAwcdbN8SFhqcJGGyqr7+zuRDo0cnx9tLqYlnasUnGh61RyTBolTj7
         Lzb+UU9DVlDMTmju8xNTkOuyOnil62yGSctMvtCf1zklowQV7HTYvdXFTJZCZcKK4Fp6
         MqCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DoYYYzDpvuTeIVBq4MF/XOYQ76lu0LvjPUPbkLzOMhE=;
        b=haPEnxyPKB5jEdM6OD6SaBHHNC+yrs+y6SaVjoci8fVE4Hwdh6jltke92aaxGARymO
         l2qfOdYvJ9bIMhMHGQncM5xwmJ53Y1jC11Knj+Ho563I5YXWAWFRDVKzYLHxYw8RyehE
         wUrCm1VljdGgJXL4fb2XVY+LPXIN0z8giDE4ocAbsIWsU3hVafZWxGlAPcMXXpPx4Tm6
         bN45vMWi2LGKDp2gyNvoBwRtXgYQU5bGqwn7cLPCQrRebQ38a3psxHScg3knLx3e/bHu
         VIVNZ0q1BevrgtHoQH9Addjz3zdojojO3A8M/HlGbp4EdjwnU0gV0OD15C8EHyy4Z0L0
         H1Gw==
X-Gm-Message-State: AOAM533+SmhUSr0oMKCvD0EF0fQcaby9ACiwyOO7z/McVOhL5GBEiFiZ
        ALxSbUD57lGbep3ms95LZnWXVgFzht+x0w==
X-Google-Smtp-Source: ABdhPJxNgmJWJjU5SiXJ2biube9gNhjPiFGaA15Qil42HSN7sv6tOCEhrFfG6Oi7zH/3CywtzWyvRA==
X-Received: by 2002:a17:906:3012:: with SMTP id 18mr1392798ejz.136.1633666291015;
        Thu, 07 Oct 2021 21:11:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s3sm447970ejm.49.2021.10.07.21.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:11:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 3/6] trace-cmd library: Fix possible memory leak in read_event_files()
Date:   Fri,  8 Oct 2021 07:11:21 +0300
Message-Id: <20211008041124.972956-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041124.972956-1-tz.stoyanov@gmail.com>
References: <20211008041124.972956-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Some error paths in read_event_files() may lead to a memory leak.
Improved the error handling of this internal function to avoid it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 39 ++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index aaafe3a4..0a42ca4e 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -644,7 +644,7 @@ static int read_ftrace_files(struct tracecmd_input *handle, const char *regex)
 static int read_event_files(struct tracecmd_input *handle, const char *regex)
 {
 	unsigned long long size;
-	char *system;
+	char *system = NULL;
 	regex_t spreg;
 	regex_t epreg;
 	regex_t *sreg = NULL;
@@ -669,13 +669,16 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			return -1;
 	}
 
-	if (read4(handle, &systems) < 0)
-		return -1;
+	ret = read4(handle, &systems);
+	if (ret < 0)
+		goto out;
 
 	for (i = 0; i < systems; i++) {
 		system = read_string(handle);
-		if (!system)
-			return -1;
+		if (!system) {
+			ret = -1;
+			goto out;
+		}
 
 		sys_printed = 0;
 		print_all = 0;
@@ -702,39 +705,35 @@ static int read_event_files(struct tracecmd_input *handle, const char *regex)
 			}
 		}
 
-		if (read4(handle, &count) < 0)
-			goto failed;
+		ret = read4(handle, &count);
+		if (ret < 0)
+			goto out;
 
 		for (x=0; x < count; x++) {
-			if (read8(handle, &size) < 0)
-				goto failed;
+			ret = read8(handle, &size);
+			if (ret < 0)
+				goto out;
 
 			ret = read_event_file(handle, system, size,
 					      print_all, &sys_printed,
 					      reg);
 			if (ret < 0)
-				goto failed;
+				goto out;
 		}
 		free(system);
 	}
-
-	if (sreg) {
-		regfree(sreg);
-		regfree(ereg);
-	}
+	system = NULL;
 
 	handle->file_state = TRACECMD_FILE_ALL_EVENTS;
-
-	return 0;
-
- failed:
+	ret = 0;
+ out:
 	if (sreg) {
 		regfree(sreg);
 		regfree(ereg);
 	}
 
 	free(system);
-	return -1;
+	return ret;
 }
 
 static int read_proc_kallsyms(struct tracecmd_input *handle)
-- 
2.31.1

