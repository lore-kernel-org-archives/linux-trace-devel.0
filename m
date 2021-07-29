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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011D0C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBFFE61019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 29 Jul 2021 05:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbhG2FKZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 01:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233700AbhG2FKZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 01:10:25 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E995C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:21 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b7so6429577edu.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 22:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oBYEZ1+W0TvAvSuSkDN98dM8L6x2JWzfmxB8PYHD8YI=;
        b=TLtRye/98JYUIeLwmRy9xx2fl9oYT6O3LGRojJS7AgmJU2/z2ZZ4ckFJ0yECRMFRgg
         68pMIjFiJGGWFDZqNBk8DYYtrX5r6eHIAtodgeL6Kq4HM9sVfdRdaKfaIRcfKfYOFfgH
         xJ654rbm7tPB9r6fFO95rQOiF0CH2flbuUZsXoNr4vv6WuT/Rj0pCbXlzURuG5/+FUZX
         a1ziIY8bSSdbfLx9Zk6YPFxoiv2wuCSPeuZQTMIV9uJjIR7pwFkT3y50SWXY7YCl+ony
         QF4X4gJQ+IBufl/e4JChGA+pUpWy85but3MjAcW0nLJ61BTHWUsZ0z6sYtjoz5HsGRdD
         SwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oBYEZ1+W0TvAvSuSkDN98dM8L6x2JWzfmxB8PYHD8YI=;
        b=MfH+HYnr7dAZgvggSYbdkkzTvN6N+fYw3u/MJijEhnmIKxa0ytHyIjLT8XazM2EK38
         E1s43q7mmKiei+GcJbc64kFgdV5rzynhYvIg/t41sNxYT0X8Uo99P1fCTIGlR5mbBXra
         QeapSKcDVJXOpVLj8uDUcVvHuP8Kbq0DJzW67Oyx/kUwfwyNJhxemhgos/at3ZSQps9O
         AAvrjMdv5jJJg4TANLPLpbGUEUtaai00QuSSFr+0F3fw3jlC0suKEQy5KTIfWaCXADhE
         quuF+vSSxX6bZ3HQgO+Uj66EaXJ0rxU1rSg8c7viC92zxSi3QyvMaxSj9zmcy31UHe6v
         0zjw==
X-Gm-Message-State: AOAM531COaE/DGDpJ6r0MVemXa/p1/DwUCZ9g6eVmFudSFRWE3MYdfPD
        +QyknNx4cN/cI7zcHrBYJFIyfb7cnllWUw==
X-Google-Smtp-Source: ABdhPJyiKJOhejQc56thZneZaOdYw+/99utU4o1FAJzBhydvbGZMoeZi7LvNIvBbsrRdtNg34TbaBA==
X-Received: by 2002:a05:6402:2714:: with SMTP id y20mr3952907edd.190.1627535420256;
        Wed, 28 Jul 2021 22:10:20 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id s20sm530615eji.116.2021.07.28.22.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 22:10:19 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 19/87] trace-cmd library: Write compression header in the trace file
Date:   Thu, 29 Jul 2021 08:08:51 +0300
Message-Id: <20210729050959.12263-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729050959.12263-1-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-output.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 23a10edc..d348d6a5 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -941,6 +941,24 @@ out_free:
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
@@ -1225,6 +1243,11 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
 	endian4 = convert_endian_4(handler, handler->page_size);
 	if (do_write_check(handler, &endian4, 4))
 		return -1;
+	if (handler->file_version >= 7) {
+		if (write_compression_header(handler))
+			return -1;
+	}
+
 	handler->file_state = TRACECMD_FILE_INIT;
 	return 0;
 }
-- 
2.31.1

