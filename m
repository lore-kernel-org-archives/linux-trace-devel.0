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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FDBC4320E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36D9061052
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233938AbhG2FKb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhG2FKa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:30 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768E7C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:27 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id oz16so8446090ejc.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bZV8VezGtTIXq/yNYWV/d3QACsxZ7pN3NcbaApSLeSI=;
        b=fD0MPuDNLqKvnYGFpteZwd7TXGPsPCQS5cNU4ezAtdjSgra5Xcaa1vxri+Fn5IaG5L
         2FfbVUz3/j0MpMY/b6itrSOW17HpMIEqfHLpUOsN+9mu1DnDXgywOy8yxTaB9ShL2/2R
         dLLqi+aMoU1AHsrR5NIhgYVVXWIEJC6LUCsz/Yx4FQ6U6alNhlE1VOxW09XwbrSo+WUz
         7wWfgRqEZGXynQawcIAaOJOrHVUSY4Srn80dXzDyyscmVzaIJuRkCey69SDv4KzGwe2R
         N98NgfX7WNaDdoGAUeR4eP1jwNCEX+vU73pMAM9jx/XZeeMNVKU+FIfzDYzuDuC1lA0B
         pdnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZV8VezGtTIXq/yNYWV/d3QACsxZ7pN3NcbaApSLeSI=;
        b=P+wvBTV5E1cGT/n8HZHPrgh8pjxJzt2cjkpRjiHQaphNVOIw5xiLVOfwruCeiEMdw4
         PhWabZK8kxgZ4aFb7C15hO3LqR7cFteAXn6byrt0XUZvvMPXLe8o17j42ORVKa/M5D56
         3al8lN7KUuk6pWafwjqT7swGXhUN68B3Fe4DlgAxlyCkl2RO2m/ID+RLei/9lA6h9uV4
         L6S2CGr6xwSOUyQ318U8wj+g+BJXiuqGXZKmX21jucBoTfrQi3eLmvV80NVbXzS9xmjU
         KUQR/IlsvNSITyR5TrcPVT9bKbbXJAD+vu5s5Sy8rmFv0p3lXnrWQwtv7MgWP9RScz3/
         Qonw==
X-Gm-Message-State: AOAM530fm0rnV2zJ2tYi/5QAvXHxWov0TmRqEGTiS6tMfhUJntCaUQOr
        6WtJMpvn1EvJhDpxK0pUs6kEMGrflDNRzA==
X-Google-Smtp-Source: ABdhPJwH1RzqGvf/ZV12rL75mRQTr/vhMIdb+3qamTbs4U6RsRcaU42d5mbX12ShzEp/U3hGJb/PxA==
X-Received: by 2002:a17:906:9742:: with SMTP id o2mr2880747ejy.532.1627535426100;
        Wed, 28 Jul 2021 22:10:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 25/87] trace-cmd library: Compress the trace data
Date:   Thu, 29 Jul 2021 08:08:57 +0300
Message-Id: <20210729050959.12263-26-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
index 90625c4e..e232a678 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1895,7 +1895,7 @@ struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, in
 	if (!path)
 		goto out_free;
 
-	copy_file(handle, path);
+	copy_file_compress(handle, path, NULL);
 
 	put_tracing_file(path);
 
@@ -2042,7 +2042,8 @@ __hidden int out_write_cpu_data(struct tracecmd_output *handle,
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

