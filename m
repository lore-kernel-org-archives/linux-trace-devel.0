Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1151EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBE9160FDA
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhIMMna (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbhIMMn3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:29 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E4C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id m9so14500829wrb.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tC1J6R2ziZNlKPTE9xNNUQxKtbzGe6ytt8wDdKjpt/o=;
        b=cvuPkFzdSdUXd+zXIxbLgrKmzkNp9W2i/TXzYTnc4FXo7hfmfpD2j9npSu9wWFuQfB
         pWcPLSZq9lTfxAeiWo9rLZQIQdK8xSj4U0h6v2BUXR9aBGOPl0rLRlg0FSvNXXZJqDY+
         tFLO48XsUe7RGqoNGSvrIolopr+1ep/RgyTWCYWnPkixTCUhMCBRUO880IYBBB+Gv/6z
         iTbYjPWYJUZkJ4d+ETz2hSbcyf0AsOwDCE3ZygYaq7oKGTnyHb0ftW5VQkKT9lxRaqrs
         xST+AbX49frp4zzYeCZwwtgTh3D4JLRrfC/w9vCh8l5+E38Vpap9ePsugpw00C/5o91W
         45nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tC1J6R2ziZNlKPTE9xNNUQxKtbzGe6ytt8wDdKjpt/o=;
        b=H4M/M1+yWpKlvEclzGIWO5u9GDXu7HMsGHFUgzPMehe/+FR742tn3FWgDbVQ3CogDf
         XX7RdBxMACuxJVtlFUkq1WH+WBaSn6pbFyX6YHAyrGvBPJX0ZA6F+fVPCfpXXjY4Pebh
         4doTfppJNp1immIhxVKgJQdNk6gfJk+J1cNLWSsqK53NT/Ghc6enRQndcBWLWijZzYZZ
         038fbpx23Bao55+YQeIeqvG8iXLUF1TLPlzy4gfUwvoqOJYSJBBSRX/Nq/hBQnQU1kLu
         a2CDINq98Yu/TX61/XqYfM54HHiGS57qApgiIzs/Gm5c4P+3GyF46twZ16EyLz0jHUPx
         wVEA==
X-Gm-Message-State: AOAM533NgkwE4iyIdMudlSF507MkpO1ZHgQ53O9nhsQfY+737jFWvMvU
        yQmWUG74yVk1DogSEiiVPmEWfNFUIkY=
X-Google-Smtp-Source: ABdhPJxQswzCJcO2FXluIwEmQa3EsB9zYDcawKUzLBDZ9Xn+h6Zb7H3qD2o/LVKl9w8EljmhZQ26Bw==
X-Received: by 2002:adf:b319:: with SMTP id j25mr7863614wrd.256.1631536930296;
        Mon, 13 Sep 2021 05:42:10 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 06/20] trace-cmd library: Write compression header in the trace file
Date:   Mon, 13 Sep 2021 15:41:49 +0300
Message-Id: <20210913124203.3677760-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
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
index 802d35ed..c979a6ed 100644
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
@@ -1362,6 +1380,10 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
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

