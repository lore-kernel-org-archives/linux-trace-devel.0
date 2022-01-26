Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC99C2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239359AbiAZJtU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbiAZJtU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:49:20 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDDAC06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:19 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a18so67954267edj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oJdcfe5htLq4+cuvF+RE/UomtxkyZLcc9KMRIotIKOM=;
        b=WHMGvhPcNazCDmMtR1LQGbfpqD/PEXA+pDPBeEE/Hwac/Vx705WFDoziEtNuOTO4+e
         UQ2WWdImhhvwd7wpGtlvtKGu1cKgV6Jq1ls5fsFtOBggEJcvKWRlddUr3ZCQQD+S6bAT
         Eqltu78iziwz/GewinHzyu4cbx4XNfKdDyin98DTC85y81SL3Eo3T/EXf6VET+++Lciu
         zDHYpbSkNFr8+Xtjmni0l6fZdUB2MmNdjt9yGG3/DyqYfk6FOMK4SdelY1tN//sVQOg5
         A44mBEKBItZMbFeqJ7ngsXjN0Jf/YfnYmsxBbqT6XW9bMX9UCZxKsR7xWJQPkN1Rf5r4
         +8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oJdcfe5htLq4+cuvF+RE/UomtxkyZLcc9KMRIotIKOM=;
        b=YdUw1UE1Hm8r7nriL1QXZ2Pw2RTZtBoLFxgEJwx7suGPzk6zQkz4U3aTvVr+XY7wu7
         AOWWMItl4zVIA+WEIaUes79Dsy9q5/KnDlaCXGrWrrbqf/jZl69gn768U5vJCb8KMIFX
         b//m0gJXCSW2M6mqus71ZNCS5lzpImiLPyZhbHHd8AX2CWzMENDI3apBRFwzBUGL3iMo
         Njwm/YhPRmTaDLNbRj1h4o6XobYjxwrXIpieerhaUuI8f7els8YWObEofgXQ7wQ8/ud7
         hsqWEgQl39AjxU7vS7sBOChlOYBEsUqpql90tlK5UMHGhDNT1gx4OHT/WxdlxPTOEqpp
         WLxA==
X-Gm-Message-State: AOAM531vIPGD6loGm6is93P54JT5RmsIPf2Bdu342m6S6hLxj/cvKTkx
        8M3xAPfFzE3APtwf7SdidnK3m4KuUn4=
X-Google-Smtp-Source: ABdhPJzkORNYqHZOpHQFnxl+/4A0ehxjq8KN0iAbw0c5sUk2DOLZg+IIq/7k6giZqDySlMsYsnWWMw==
X-Received: by 2002:a50:e68c:: with SMTP id z12mr24203375edm.297.1643190558248;
        Wed, 26 Jan 2022 01:49:18 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id e17sm7119155eje.218.2022.01.26.01.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:49:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 06/20] trace-cmd library: Write compression header in the trace file
Date:   Wed, 26 Jan 2022 11:48:52 +0200
Message-Id: <20220126094906.570451-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126094906.570451-1-tz.stoyanov@gmail.com>
References: <20220126094906.570451-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index caa8cbc8..76ff4419 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1167,6 +1167,27 @@ out_free:
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
+
+	if (do_write_check(handle, name, strlen(name) + 1))
+		return -1;
+
+	if (do_write_check(handle, ver, strlen(ver) + 1))
+		return -1;
+
+	return 0;
+}
+
 /**
  * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
@@ -1460,6 +1481,12 @@ static int output_write_init(struct tracecmd_output *handle)
 	endian4 = convert_endian_4(handle, handle->page_size);
 	if (do_write_check(handle, &endian4, 4))
 		return -1;
+
+	if (handle->file_version >= FILE_VERSION_COMPRESSION) {
+		if (write_compression_header(handle))
+			return -1;
+	}
+
 	if (HAS_SECTIONS(handle)) {
 		/* Write 0 as options offset and save its location */
 		offset = 0;
-- 
2.34.1

