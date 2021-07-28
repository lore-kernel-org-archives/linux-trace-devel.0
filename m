Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB3DC4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BEA6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbhG1Ndy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbhG1Ndx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:53 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCA6C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:51 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id nb11so4660732ejc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vtMunl471kmNR7k8ha0iaaJzxK0FZwZ35acTTpIpOGQ=;
        b=g3M2mBq0ASqSTAz6len/Qe5Fx02b1iU/Smbze4fJ2ws3Td0dCstRngCVAo9B81U5JP
         S0QKhULwsGVbypLINmkSn4GJpqbGXHqaaUR03YKxJeCPpdOC8unjfyISh2E/Lkbzf+Fk
         o+YLm9Uz1814T72WoqPvHerCXlguhZRGUWBldx8CIWRlO2sr0yiuLFCFL8aB8u93f4jg
         vFOC6H2ISJ1LyUWFMbOs6saahSHqjyj/fI2AEw4wacRXF+8ao1oWABq0K9AmSqx+xSKa
         5OYWbKO0ujZRu8nelxm8SJ0xu2ioNWR0p8ZvQPIhAgYmr/Nq5/l8mdMLDIEgYkPmXX5u
         UN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vtMunl471kmNR7k8ha0iaaJzxK0FZwZ35acTTpIpOGQ=;
        b=k092flXD/D3FbDI14Vtju81Tq7ax/16d80kl6jbH90Il3QDPm3PHQa5u2hYuHipoS9
         CIIij8XL5yYNjWRN5yfJNFfw4Jhs6aq+43bcOa5YGqHyt7W2TrAkNLa/HtPNhspOK4Zy
         WL+LMyNpr7UtIFGY5jo89vcMVLwEa2TufGeKInSxhp20+8m21UGKbkWHFUKmEY13eH60
         DFl7tkMh2kHvxZfLw3D80fnXQERvGt4y0r7fCuoIZddB4JaXxcyoYKB0N9tTJOTZDcF4
         5sxhWh9eZZ2oVy4K+X0J/PZPQaDjssr6CAntEjC1HIlFkG5fkwNi+36ghsjY/MHP5PJu
         4Phw==
X-Gm-Message-State: AOAM530at4Za4XyWp/kcDP1sQOquKijk0V8G+IHO1ZT2TR9Io5JhCMVc
        oeTxkv/IFgK7mexreagZdjtfNI2luxsNNg==
X-Google-Smtp-Source: ABdhPJx4gIM+1z6MLOvhWOhzQFiBdq41LTMrZYaQPOWH79ejtIzrz4iehEt/88WMnLKjQcCDeoXHTw==
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr18266864ejb.549.1627479229947;
        Wed, 28 Jul 2021 06:33:49 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:49 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 57/87] trace-cmd report: Use the new latency API to read data
Date:   Wed, 28 Jul 2021 16:32:20 +0300
Message-Id: <20210728133250.234140-58-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
 tracecmd/trace-read.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 31724b09..416c6ee3 100644
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
@@ -1241,7 +1243,8 @@ static void read_data_info(struct list_head *handle_list, enum output_type otype
 		if (ret > 0) {
 			if (multi_inputs)
 				die("latency traces do not work with multiple inputs");
-			read_rest();
+
+			read_latency(handles->handle);
 			return;
 		}
 
-- 
2.31.1

