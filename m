Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 970A1C433FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbhLBM2l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLBM2j (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:39 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F84DC061757
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r25so49162873edq.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wYktZ+MsZzYFknwer+nO8UYK0p0Tvf+pEC5aGqGFh14=;
        b=FNyvHRcLn1yl6If6ldtsOTW5LoOFQxsePi1dPBEstpzT6wa514uPd4kezr3CUjGof2
         a99h7Vkaj8a6pGbYTufV0bG+K+w64x7F26OIz/95C7zyG1cAj2T+iRbnzy9QH/wr49rc
         QQaKuejRGQ2r0X3SEdB5SepxaeXaZiaCcvjLeQkAcLOhIX2rdKrOt+nmYYLMhna+V9Gu
         o22cbcWORy3s0qrRTvFoKi0Fe027B23WyrSYX1Xt4cjS6NWfgqLXr2G+e0jka2tk5JZj
         DraMLyiD8uILMumvJ0R0cht0DPa3WMx2b3ej7niJ1bf9vvefdtgVWFKrQdLSLTUN6vW9
         XLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wYktZ+MsZzYFknwer+nO8UYK0p0Tvf+pEC5aGqGFh14=;
        b=G8idjVeVXI+qQYoqUlXJhNKTxYozOE5Ci4HZLMMBwilYvU6ATlc7omv3IqbuWGnja7
         VqKZAsF0z4ViVtpE1OZ1Wkfo3ZL4ShwkpfTUevplhiiA4XK5wn6tPD4fVC7hJSITrbPl
         X/z05OhPOWfOo+eX4X19yN1BT/olNWq+RCb53H225d4styJT7PYXXyMrZMw2pVoGG8JV
         T7b5AI03hXZOpP72AbFoAE/ZB8NS4wmQmtboVqgeRtZSnOD0W627oLjJBU5uZecBoFuk
         +Z/gWFMKonvZBIzsqwuASfxH+lXAgt+qFVyUWg33cQNcwSfzpMORim+3fq3sOB51zJ6w
         l7FQ==
X-Gm-Message-State: AOAM533IxDTLCbgHzgWNUcyBGqK0V5CPsxqS4OEcNKrr3WsVk/iwtd/d
        wFEW8UDM1NNsAJqBxjr2tUK7tuUBgP+UTQ==
X-Google-Smtp-Source: ABdhPJwrw61JeY6OdpL/m9YDLRU3bbOhYP92TqMybw0MHg3m/iR0q3YcuUf0e3Arshm217Zk7xTL3g==
X-Received: by 2002:a17:907:d89:: with SMTP id go9mr15131537ejc.330.1638447914342;
        Thu, 02 Dec 2021 04:25:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 06/20] trace-cmd library: Write compression header in the trace file
Date:   Thu,  2 Dec 2021 14:24:53 +0200
Message-Id: <20211202122507.43572-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index bfd6e385..0dafa2d2 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1082,6 +1082,24 @@ out_free:
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
  * tracecmd_output_create_fd - allocate new output handle to a trace file
  * @fd: File descriptor for the handle to write to.
@@ -1374,6 +1392,10 @@ static int output_write_init(struct tracecmd_output *handle)
 	endian4 = convert_endian_4(handle, handle->page_size);
 	if (do_write_check(handle, &endian4, 4))
 		return -1;
+	if (handle->file_version >= FILE_VERSION_COMPRESSION) {
+		if (write_compression_header(handle))
+			return -1;
+	}
 	if (HAS_SECTIONS(handle)) {
 		/* Write 0 as options offset and save its location */
 		offset = 0;
-- 
2.33.1

