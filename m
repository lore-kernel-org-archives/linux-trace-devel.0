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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDE3C4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B97FD60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236646AbhG1NdV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236665AbhG1NdV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:21 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9329FC061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gn26so4673293ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/vE+5eQ/wNA8aSUY7HeTdj6WT3P3G2LpCar+Poil5YE=;
        b=eP6k6rnHgyj0NMrLmY8B4JhzbPSEsD4QNIBUEA7x5sEX/+t+GZAZ9k3ITOZ1gXOVWm
         P5rTHt7k0uJ2rlHH0oCK3KDgveygyyv7Uq6eqoGBj6n1ryeMIlWGRXzztTKuH2i4tegR
         4WEThb2ZDRjYf1JbsetzkAptIEgWXpXVzaJQKHENmV7BApQVVg0tvXuiG70GGBPRe+Mt
         UZAhrs6oKWYpopUh8gInyXbnkwkjU+I70u0Xub/oofbpjl3l3Hhpz5AGuHyVDifgXP/9
         XFyFwqEkZbo48peaXenIyLSptfp8gN/TaPDUrNonw51kVCc6N0Wk+HUsrfWJ0pvm/OIa
         Egag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/vE+5eQ/wNA8aSUY7HeTdj6WT3P3G2LpCar+Poil5YE=;
        b=Xs+Q/VhE2Uhz8lRql7DZcuQfBXTKPij+aIGsQuE/+MO5GneeUNxV2pucs/ffT7wEW/
         JLo/il2VqkWLotghF8S1K5miWYoBl73jhYH/3GSfWIZsIxQkQ2pEQWCFRlbQsi+hDc0S
         J+w9hy2ol2mL/2NpCS2f8r9bPzYjLgDr5ylWE7yIxxx4Xs+7Jq/rYAo2zB7TGYmmmSst
         nS3UmfQ932MI1SjdddeZWVLN+o3XtTjHJTfrx/V0D1sOVgG507q+fa5MN2urTG2OyRee
         OU80fXuQWT+6Hw8Sro+w5/Lx+qqM4mtWHmej57EKzLc4tCaFhLFyRlSV49gEZ8aUMC1N
         RJ7Q==
X-Gm-Message-State: AOAM532d9lH95Q/oohr+YQDhGhIn1ZOI8TFlmMolshyoLmHFGW6Ry4km
        DfxRXBtgrY/gUflPxRrxtO4=
X-Google-Smtp-Source: ABdhPJw9GATRtjZ5VwX9H0C7k8RACM0ZABsTSm4sA1KM47/rCT1jS6o831m3WGVJSbZr22yrFB6R1g==
X-Received: by 2002:a17:906:f112:: with SMTP id gv18mr12852240ejb.439.1627479197192;
        Wed, 28 Jul 2021 06:33:17 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:16 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 25/87] trace-cmd library: Compress the trace data
Date:   Wed, 28 Jul 2021 16:31:48 +0300
Message-Id: <20210728133250.234140-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the output file handler supports compression, use it to compress the
flyrecord and latency trace data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index ad0fcaff..ccbdf6cd 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1891,7 +1891,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!path)
 		goto out_free;
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 
 	put_tracing_file(path);
 
@@ -2038,7 +2038,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
 		if (lseek64(data[i].fd, data[i].offset, SEEK_SET) == (off64_t)-1)
 			goto out_free;
 		if (data[i].size) {
-			read_size = copy_file_fd(handle, data[i].fd, data[i].size);
+			read_size = out_copy_fd_compress(handle, data[i].fd,
+							 data[i].size, &data_files[i].write_size);
 			if (read_size != data_files[i].file_size) {
 				errno = EINVAL;
 				tracecmd_warning("did not match size of %lld to %lld",
-- 
2.31.1

