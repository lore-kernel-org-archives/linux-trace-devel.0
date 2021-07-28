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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219A8C4320A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D47A60FED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236641AbhG1NdP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbhG1NdO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5FEC061764
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id h8so3255766ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1wFtw1oFy8DSYcUxIp2gLy3ayAkYtMI1AS0cb4XAagY=;
        b=IY1j1y2jS6Nn8ijBx3EcED3FMrJJg8UM9pYjjsB2TO0UGB7L3cSbAak4iCLOTsmTrK
         ZU64oxuQL9IgINa1P+WV3yEOC81dxfUGIj4YS/9hBLVfTRB2zqhvsU34FtGzOhmf5yUN
         grscZqwrl9r5P6UbIDCxBCZ1ZRyP71d3OzK/yPdUCie/VhI6xaYFW+d0MajbP0aauUOA
         H/3a02Wr1X94M6jTt+KKaU6iEG86Q4vSlCAvygbfr8RAQ6RW78Pc/WfYdnARpSoFaCEq
         2gREwEa5cSd7UuWHMCufESnsOnmpGhErCiZBz2UNkWpiVgxSFEMsmsvtmvlHyj8Pkqjh
         wVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1wFtw1oFy8DSYcUxIp2gLy3ayAkYtMI1AS0cb4XAagY=;
        b=VXP4ADgdZhyy6e2/BS5snYuupLJo+YdYkENR9TE78x/xA9wlTmj356NTYLhl7kEpYm
         rk1//Rv4yvgJatrkC/25YfNOr92ABpqLiQoJnwdnNPqhD7MxihoGGK9fp0zclXiBlIGR
         yXSHX+lFza5wn34jorEI5g2j3JhWX26amTHUqGRlWTBH7Y1x9l6r6mOP1xx7plfHOwHl
         bbzAREq1HYcmuJP1xQhyU8Ru9XtuVW+aj6G1dqrYd1XjWWLIzfq0o3KW1jOCXa/JehBl
         l1SNIBA/C+1tJg6Pa+Cmpox8fkN1b2AP9+M4bhg+ex9U2OJns06jb/8vvYl8n7kC483/
         issA==
X-Gm-Message-State: AOAM532PmLIuBgnUlmeaqqXFi2kfdCqMrNu0S+Xk5ExBhL/kUi3BwU5x
        sEbiaOnbb9VrnytZh6LTknL8X2ou9dAGog==
X-Google-Smtp-Source: ABdhPJxB7IOYbsWV9PRLPMI3jNVej7NvHTQ1i1DCvOuKfWBabNRbdjcNvZloq+1IgzLwBz8DMT0BAQ==
X-Received: by 2002:aa7:c2c4:: with SMTP id m4mr34462895edp.173.1627479191288;
        Wed, 28 Jul 2021 06:33:11 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:10 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 19/87] trace-cmd library: Write compression header in the trace file
Date:   Wed, 28 Jul 2021 16:31:42 +0300
Message-Id: <20210728133250.234140-20-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
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
index 4a3ca2d0..004c783c 100644
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
@@ -1222,6 +1240,11 @@ int tracecmd_output_write_init(struct tracecmd_output *handler)
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

