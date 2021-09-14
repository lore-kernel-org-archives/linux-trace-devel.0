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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C422AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFBB960724
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:16:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhINNSM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhINNSL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:18:11 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950FFC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:54 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id t18so20211982wrb.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fxMT8pTuiX7OpXgchCrCJXn/ox+XMUxVn/EbfGJgxww=;
        b=ZcY52P61wrJvCt7eSljJ7p8LL0s08VSbaxMgVFONW5flO2l8bgIOJHyCK6bePfnjk9
         S/N1QVRRYqxnQ6ZUsCQGgaT14njPhT+DilzKom3xBdoJTMGpVsVKjuDBdy1X3yK01/7a
         MkY1fDbhRuRbpqZEjYoxJjw1IUTLYobXmjOzVEYCarVULPdkyA6aDzvxC10JFYN/B/M3
         MgLbMBNEkuWB/TvFkl8S5eUS/TP3x5E5aLSKSuBtwiEZtz1I864aDXAh50nwSJLaot11
         ED0uvja9IJTzwmbg9N9BNHibh3+ZmYVaveFLs5f3lpGs/b50tA1J0M+s0bNo69szlCQK
         QboA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fxMT8pTuiX7OpXgchCrCJXn/ox+XMUxVn/EbfGJgxww=;
        b=s2g5MdV8VqPI+XwTo6PgmvXn2AsKZfSLALZpf8GbIR6sP+Afkfp/hvR/1pv5w1OIEY
         BG6DZtoblw6ncnnmSdYqsn3d8ljHyTwLMrd44gInQu1+Fh5ESFQs+bUB2LQ0H4UWHlpn
         waPiaaKT6vwqaFjqS+7A8kevPRimuz4M3z+g2bRhwsxqcJ7CkT5T8kNwszZW8flMPiHT
         KXjexED/vhU+72JNVFQQYkti+DMgF/MT7Hk87amAMrs2qTgFXU2WPZZXqUDo8uUhXbfV
         dEXhy0f20IDcIQ9IYekV6HI2AvIeBFqA35MwPcrJJjGbexFD/2sdR3O/Mh2C7hobEYmj
         qqOg==
X-Gm-Message-State: AOAM532e60JxiyomOKYN1Cz7Ifq6okiGIU4fyslx/IiV4UkBKfqp6e4W
        PXfjQih9loiw4Z65WumWQJIyRY6thls=
X-Google-Smtp-Source: ABdhPJwylErFH7x7Kbb2JMiU/yzx47l9Km3aT0bBFbTZOLddJ5uyzQrf+MAsEUfxtYnpWZY4fU4TOQ==
X-Received: by 2002:a5d:61c1:: with SMTP id q1mr17099246wrv.154.1631625413257;
        Tue, 14 Sep 2021 06:16:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id q10sm1119624wmq.12.2021.09.14.06.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:16:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 06/20] trace-cmd library: Write compression header in the trace file
Date:   Tue, 14 Sep 2021 16:16:31 +0300
Message-Id: <20210914131645.3966308-7-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
References: <20210914131645.3966308-1-tz.stoyanov@gmail.com>
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
index c15c6979..d087b1ba 100644
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

