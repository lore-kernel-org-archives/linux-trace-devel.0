Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A30C433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4E161073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhJHEYT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbhJHEYT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:19 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD0FC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d3so3893358edp.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kLY994riiAtfXyV0uZnSFb+ehr5ETVupLTBx32ojddg=;
        b=NKOlEiV7npiDwT+VUulpRCrs8MCtxb3LAXEq1rBznk/L5E5ihUsG2VN55fZTFACVnm
         3TN52qyDqDzScCejdppJPUtu7og8gn30G0ubBY3o47ckL1byOTXQ5LAevG7gkRZANqgm
         x+n4bXtdyun01VWLgxDdhyiGFPjtTXq/3nGaCm+kkw8NZlsqB+p6VGSF92ojsZ/AU8K3
         Mn6yuvMpCRI72WknTI9qCeLn11oNT4T1YuR49dQ3/HC/yfUWJ28m4sv1kk9PbRva3PJc
         CQGPfMb65HQ242xncKc6YYlT+5fkA5lmEbTukjvZrfeUAJM7HIaOycYpTmgNZw6/Ryfu
         d59Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kLY994riiAtfXyV0uZnSFb+ehr5ETVupLTBx32ojddg=;
        b=PRWj+P6AHbGn2uTKuvYpZz3A/aLAbyaFqJurDSROWcmedNsPQctHtmc0FmBBBUKjp8
         TO2dCll5PpM2GuxFTX2dZxqedNDEp8jUH5+4CBgYs3HlpeaTi2N6i9rr070+fYSxQiWT
         q5rUx7vORVkfhGdj2TUM+L2nHVTsVivwTwYfVVc1g4OWWP05ZBGMSWHKE2L1j1MU2ShB
         X9Zx8aFq2dfG764dlPL8jYuKnKAU2YbGfcmGoME2/l1UBCa9wMcXfUQnvsPSA30GT0mc
         fspkmTedOLdGmlOIAM3qRm3Isv0995ExBgqXDPMBWMJCQl9sp/WKaO8V0BALoTKxjT0Y
         LOmA==
X-Gm-Message-State: AOAM530+xpHdfCOQPoO6tb1gaEB54dO8S1OP2C+tqVgSLy976nfS5jq6
        HjK7kYyjZHVt8PeHi5Cruts=
X-Google-Smtp-Source: ABdhPJwX5Or5IX/FA6Jgo1QSfCNE6U1428HSa9bx6VXsSBaea+tIB3qkFR2dEAzKw/QiKq969l2gOw==
X-Received: by 2002:a17:906:1e0c:: with SMTP id g12mr1268858ejj.155.1633666943137;
        Thu, 07 Oct 2021 21:22:23 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:22 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 06/20] trace-cmd library: Write compression header in the trace file
Date:   Fri,  8 Oct 2021 07:22:00 +0300
Message-Id: <20211008042214.977193-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If there is a compression configured on the output file handler and if
the file version is at least 7, write compression header in the file.
The compression header is two null terminated strings - name and version
of the compression algorithm, used to compress some parts of the file.
The header is located after the page size in the file. The new header is
mandatory for trace files version 7. If no compression is used, the
string "none" is saved as name of the compression algorithm and empty
string as compression algorithm version.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-output.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index f3afa7e6..ee978409 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1076,6 +1076,24 @@ out_free:
 	return ret;
 }
 
+static int write_compression_header(struct tracecmd_output *handle)
+{
+	const char *name = NULL;
+	const char *ver = NULL;
+	int ret;
+
+	ret = tracecmd_compress_proto_get_name(handle->compress, &name, &ver);
+	if (ret < 0 || !name || !ver) {
+		name = "none";
+		ver = "";
+	}
+	if (do_write_check(handle, name, strlen(name) + 1))
+		return -1;
+	if (do_write_check(handle, ver, strlen(ver) + 1))
+		return -1;
+	return 0;
+}
+
 /**
  * tracecmd_output_allocate - allocate new output handler to a trace file
  * @handle: file descriptor to an empty file, it can be -1 if the handler
@@ -1355,6 +1373,10 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	endian4 = convert_endian_4(handler, handler->page_size);
 	if (do_write_check(handler, &endian4, 4))
 		return -1;
+	if (handler->file_version >= FILE_VERSION_COMPRESSION) {
+		if (write_compression_header(handler))
+			return -1;
+	}
 	if (HAS_SECTIONS(handler)) {
 		/* Write 0 as options offset and save its location */
 		offset = 0;
-- 
2.31.1

