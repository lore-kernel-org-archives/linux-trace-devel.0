Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C96A0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE9D361108
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhKKPOy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233959AbhKKPOx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:14:53 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7756DC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:04 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id r12so25429578edt.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fE4TGTHK0TVJo1GEztfPc8OHAPrM7NY2fZxIr74H3UA=;
        b=Drm210+sDD1RmwMQOGjoqiw2IAgab9XWwmej/OiE46tFeQQfQXyr96sl2eytpVmx/F
         s/3C4NEqkIWR+Q/RSOI8vCOPuo36jlLWuwknF5AwH3ggBEkoIT/kOnoxgE79XYQ+NFbh
         V+INj0tLY/eTZI2bJg9PhiXWcoqv3z/zC81M5GoA1eoqedHJI+XphBk9jAGNs0flrw5C
         J3YSwJuRAPIEl0VPew+9jssG7UGdd9hth3/3wtEvD/YYmIl1Wp88wW4n0DiUaAFR6KDO
         fAAVMK5u9hmJDuXe4zRvUCzC0g8RJ5eK2vw6NfeZ1XGcsG7pbB1kOiVsKu9FLeoxuyO5
         V5gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fE4TGTHK0TVJo1GEztfPc8OHAPrM7NY2fZxIr74H3UA=;
        b=pmnHuS8eUuT/9FTNmStgpEbeka6QK53VBzeJr4oltlKTncr5c/L448R+lTaE8nQ3cq
         I6K3VNCPbi3V1Qr+PJWA2ySK1t5C3EtFgq2HBr2tEM+Z/gosx/AohQhuuVyDQUSPLMxo
         BNNqrUz7UbmfNiRnL8YRmNmxOsU6At83RFMGvxth9KvI/L5eS3vreAfVQo/Z2MGD2BFm
         l7DT7jyIii6JoWiAsh1Dnd2y0kFpboC0kgHoDjPnmjAQ0zNK8WM5g+DrdEz5JHPNPLen
         T+QLzYT/ayJyUJRDshigXfdvr4RnKFunCxDChYr3q+dTf3n7JcCnN1Euj2OAneHu72ME
         tomA==
X-Gm-Message-State: AOAM533nMRhH0XnOXUt0ukmTDIA5fqy/lXFZv5pWPvEvoqCvny2uBR59
        aty88A/CoymI3JMdatRcZgxiYunhUjz9Fg==
X-Google-Smtp-Source: ABdhPJw5wKiRl35fTb6RhKpVNS1PoPmgUPC/GnzMC1hiJh7ynYiE2MUXsOOiAwsiVIYJ0PRHYKJhVQ==
X-Received: by 2002:a05:6402:1a4f:: with SMTP id bf15mr1965160edb.260.1636643523061;
        Thu, 11 Nov 2021 07:12:03 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id qf9sm1479509ejc.18.2021.11.11.07.12.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:12:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 06/20] trace-cmd library: Write compression header in the trace file
Date:   Thu, 11 Nov 2021 17:11:39 +0200
Message-Id: <20211111151153.86855-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151153.86855-1-tz.stoyanov@gmail.com>
References: <20211111151153.86855-1-tz.stoyanov@gmail.com>
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
index 6119721c..cbe53199 100644
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
2.33.1

