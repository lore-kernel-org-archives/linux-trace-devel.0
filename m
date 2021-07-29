Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A497CC4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF6B60EB2
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhG2FLC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhG2FLB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:11:01 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB5CC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r16so6379840edt.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ho/IUuK1D6V9ESHNX2ltgR4QXMDHcbCK00QO/msZh5A=;
        b=nEEGF2qgRp+gfdgw+8xN6erSxeNY8I6f92ZK3QHRgqGqswmklzYDb4m5Z1BEEIqNoY
         D9SMUEbi05iAtrnqkdzhn3Pd6SgdqCUoAMRt9CICK+6x2mTrit6qQbsdH7CpLKshg3mz
         5dqdgkGGuTyhwFDIrzMZ4frhTl8MBmVpv8NEND+vqy5bm0BVzkDEZcCqHylLmbEww4Ec
         4BLTQ2mDmUlk8XTgucR2W7nsZHxpKKvvD9YxT2RtSQs+F4g1gCWZ3eBS2FpSH4eCOet1
         WprguOzS5FKZzzMgYLoQ5irP0D/G4AU9KH1x+yUV6QGhtpenGOCIcKVl8Hon7kBCvfah
         6K7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ho/IUuK1D6V9ESHNX2ltgR4QXMDHcbCK00QO/msZh5A=;
        b=pTaImnEEVj4Zw5BcIs/5y3FrlAfRPzKBLMWz9D6FX0189LnBJfUmAvdEneRSlVSbHP
         4xTnb+ZUtkbKWGHhGx1NIN3TM3wWLOaOOXWsa/8xtEsbABVM7PgIA8g0lyRo443tLyQF
         yql1KQIEH9XEUWH9XR/nuf0kwG2gBExhbtlRA7XB5CV6F/JOB68fGoIV8WxPmLn3pjxS
         8Y7XsDqL4taZ3Z7bb+jNaHi898XUXBlTMGvVDyGWRJ7pRF19pOL/tsWGk1W93k02+JdC
         5QOLV/SUIHWN5b2sliaQxHqdwTAvAeMcXpDeEW8gqcQ2kRhtpcIzFnT3f6cyks7YD44F
         255A==
X-Gm-Message-State: AOAM532U3O42rY0p0nJ39wvq7bNlWLJIwivhjiU73H1z8L001EoYHYba
        d4VmMoVa0CRqE+vzSo4+7i8=
X-Google-Smtp-Source: ABdhPJwi+uh0Qbzfe43q/IdRPfFYjeXcxET4Hl5jm+KAaYAu5BoS81TV2yHlHHBgHVZdfV2A1FZSug==
X-Received: by 2002:a05:6402:2714:: with SMTP id y20mr3955190edd.190.1627535456562;
        Wed, 28 Jul 2021 22:10:56 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:56 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 57/87] trace-cmd report: Use the new latency API to read data
Date:   Thu, 29 Jul 2021 08:09:29 +0300
Message-Id: <20210729050959.12263-58-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading latency trace data, use the new API
 tracecmd_latency_data_read()
It handles reading latency trace data from both version 6 and 7 trace
files.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 31724b09..0ec2b2d1 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -948,18 +948,20 @@ void trace_show_data(struct tracecmd_input *handle, struct tep_record *record)
 	printf("\n");
 }
 
-static void read_rest(void)
+static void read_latency(struct tracecmd_input *handle)
 {
-	char buf[BUFSIZ + 1];
+	char *buf = NULL;
+	size_t size = 0;
 	int r;
 
 	do {
-		r = read(input_fd, buf, BUFSIZ);
-		if (r > 0) {
-			buf[r] = 0;
-			printf("%s", buf);
-		}
+		r = tracecmd_latency_data_read(handle, &buf, &size);
+		if (r > 0)
+			printf("%.*s", r, buf);
 	} while (r > 0);
+
+	printf("\n");
+	free(buf);
 }
 
 static int
@@ -1241,7 +1243,7 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.31.1

