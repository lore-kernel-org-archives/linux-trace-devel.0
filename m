Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B407CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352443AbiASI1Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343541AbiASI1Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:27:25 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DD2C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:24 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cx27so7702161edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zpoh1ToHrvkrUdXW8bnduCOSTQYPppeOMpPDPoLOzFw=;
        b=NOBSFokFonXXC4Nkj1QyXAgJb2eNtnOw2yKvc59+UDA0h7FlYKomhzDh6EWcUFpL2+
         2fLIETbOTwG7r0Xho2V0+NtfWAso0uXERc91CdePqmpu87wLB1b03yrjAYFDzL1ikf08
         TiU/4pIEfvsFo2PTFDTXNzWRAMixJX+tvDCvmO6VuQYvWYk5m9W0p5SYQW8YqO03/Q1p
         Q/L2zrymFhkPGcJhsfajGr7WfkZBwUoR55DKx2LMYw/zF+VP1osI+M5Hpcdpz8T8cW4A
         3KMSk+XbmZoSKYGkTqf1DVSe5NeHCZ6YMt37tCQQ4Gdu/P1EyHb7jqC//UWK+uZVTOS4
         FuFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zpoh1ToHrvkrUdXW8bnduCOSTQYPppeOMpPDPoLOzFw=;
        b=JkMCHiBT0P8f1w/gVct4cXtX2Zb+6lrT6vV9U4SmH4eIN8p+7OMSwNus5XhVvcj0mA
         SFzOewLX3YLbUIfGEblWME5UCLiXlwIKbRLnPjAOvP/6gYEfb8tchHCQkYz7xNLrPi7F
         ClR5VhF55Xu7IZQM7lFpexlNi6n7jQBXdfurJYD0TIZlBxvXXwCyujURbSBgoZHVO9Ar
         mVdj52PFz+AH3Vz+hPigZJeEZ5F4kRVtMGf7o086zFjJVuuRNkirueQb/uWQrEs74u3L
         QJzStN6s0dOHaLn1HOv912YfMGM9gmz/y1dgw3UFHBR3YnXweDpclmBGlbeRQuWhkz40
         yPOw==
X-Gm-Message-State: AOAM530VXMk2EClyZBHHWjByaoXu9aeqrbcc2CC2IB4UDrhmTbS94CsM
        UP1i3IsF0o3OqCz+CdC/uFm3OuW66dU=
X-Google-Smtp-Source: ABdhPJzD/bNuzOtyR640JccbFaapS0MN8Q6/T0OnqPx47dcIZjDXv0S6sdOBc0vdGFfvm8MlkvzGzw==
X-Received: by 2002:a17:907:3e82:: with SMTP id hs2mr24623323ejc.30.1642580843341;
        Wed, 19 Jan 2022 00:27:23 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d14sm848703edu.57.2022.01.19.00.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:27:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 06/20] trace-cmd library: Write compression header in the trace file
Date:   Wed, 19 Jan 2022 10:27:01 +0200
Message-Id: <20220119082715.245846-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119082715.245846-1-tz.stoyanov@gmail.com>
References: <20220119082715.245846-1-tz.stoyanov@gmail.com>
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
index f13d2b8e..e8a02bf9 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1156,6 +1156,24 @@ out_free:
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
@@ -1448,6 +1466,10 @@ static int output_write_init(struct tracecmd_output *handle)
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
2.34.1

