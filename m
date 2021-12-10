Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D15C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 Dec 2021 10:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240100AbhLJLDV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 Dec 2021 06:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237285AbhLJLDV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 Dec 2021 06:03:21 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B65C061746
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:46 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id l25so28878957eda.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 10 Dec 2021 02:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dHwGyEPp8asw5TFDr8bVu7XDrtbEXAAbBY9t8ZhHKvI=;
        b=e/EVgiiElZemDBcUXdMOypJfJH3iQXMHYJqJD2UNu9BENNAqoyx2u7um8VvYW105ed
         lYv3P62hME9Lebet/gkOL/AjGruL7CHnPmj7t4Ym2KDotxP51C+4PQnQ2Ohc4qS3wm5S
         0frGBgDVpb687g3rJi7qgrltUjf7AoWIMF8LfFZ8zjz7o3e8zCOyEgm6qipokkbB5nKt
         oWKJ5s8f/YImfIWuQ5ErG3pdECGzbmKSwUGjqWH5T5OdDSQag+AwffBuWND1IfoNesP8
         VrkYemkMSPE1ZVUyrR9qH0kfRoj9OHePrpJ+NkcSe08liSJXhqcJknj8zShpeG6PC4lD
         5+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dHwGyEPp8asw5TFDr8bVu7XDrtbEXAAbBY9t8ZhHKvI=;
        b=xk9WKhXlL3PXi0uWnhmcz1p/Yl85gMq8veojzWGec1AtZ22ohEF37VCcoazEwQ6pvp
         9mjX6Iw4Mu0Y3Fiabwds1eNryRnSvCA49htHpsU9UUPT0y8LvNEwyOB85+8AS2fscRdp
         5aMsvBHug/uS3oGfIKUM9TkwMnyS5zahzbTPTR706i0NUVkHYVeafgJRdy+I3cr+tr/n
         vVZFllUIfIRoOxQmkwsZ+e1I4uPUafPzE7sF+jF/6xBDAnUO6Nw68tAGgW2fJSBtO1Uq
         ZxgKcuMC7RukWZ8M85p+J7Wgt4PfQt+lvbyRbPZVhCQgZ77wGfpyn3JXjKrnZ1h3B8Mz
         bZrg==
X-Gm-Message-State: AOAM531q6UrYit0K3Wow0lbANiWBf9zzVS3EVrEokTaMHPSoU3nnad9H
        zqCfa3gh/yjqynoLxtKKKHmaLSIMxtQ=
X-Google-Smtp-Source: ABdhPJxKLs2CHk5wS1wUljxqCf0VZpTav4jeAMrMqJZbtF98yo0ZmEFNgbeY/yo6PCRnA7YDjRg2lg==
X-Received: by 2002:a17:907:7ba8:: with SMTP id ne40mr23087114ejc.391.1639133984911;
        Fri, 10 Dec 2021 02:59:44 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j17sm1320379edj.0.2021.12.10.02.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 02:59:44 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 06/20] trace-cmd library: Write compression header in the trace file
Date:   Fri, 10 Dec 2021 12:59:24 +0200
Message-Id: <20211210105938.98250-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210105938.98250-1-tz.stoyanov@gmail.com>
References: <20211210105938.98250-1-tz.stoyanov@gmail.com>
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
index 9c996cd0..43667c8b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1151,6 +1151,24 @@ out_free:
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
@@ -1443,6 +1461,10 @@ static int output_write_init(struct tracecmd_output *handle)
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

