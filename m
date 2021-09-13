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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79786C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C4B560FF2
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhIMM3U (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235143AbhIMM3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:29:19 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2204CC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:04 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n7-20020a05600c3b8700b002f8ca941d89so6470702wms.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=DV1ATpx2wambAt9zJ0wM3pQX3J3L7ytUsK1//X8AnL+6xMKZ121En58ew9SPqbV0UM
         CMycTAjOisCNzll7N/J8QRPPcxrXQEiZ6ctTEMVL4qibIH8HHEuIa1nLinIoxJVx1nIT
         CbGZVHtTHI9pcfGlKCvc9ETvPQ3jgUsHNL3LvqCx4B0zcuXY5lJTp2X9GGL+M45iMjr+
         FNB8ySFl5bjlJ6y9APW4iu/TxgjDCg4tGpAZBs9pXgIEv5FxatM+sSjm4YAu2QYxT97H
         u7h7xHMIh8putbpSMVjOyYAtpDV4KMqJqmN1zlOM9ItvBjJT6e0Jwa4jVri8IAjUrAXR
         P+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=wq3fY81iBTIwKy9btAWY7jrDEyZ8BLKp8BP3pqpkTGe6O0Or65/5ZZVtzV+ruW+5Hl
         tL69FFvIWxn+ExM/LGIeO2CLskAc3e4TllrheAOCyXPYOWe1Sx31ZM9wXb/qyWR/O5oy
         LXgFptqVF98SLMe83rdpt2DlxNY5/kFXmfdiTKLhSfUSy74ldb3PaWkTH4/36CEzXkh2
         DEXbEXx+quFknQD6VxOEBk/lISmdJC+xiFbmb/ed00MjuFm4SBSNZP5T1apY0QHfnReO
         yxes9McwyxPSKWm0vBsQm470P99kq/jGuEoJDSdkKFmGqq+Huzm7OWNcKXfacAEofyKD
         AdIA==
X-Gm-Message-State: AOAM5306dhYGWsYcy/M/6IztgR8WJ0SVRugGfaolcESO35+sW7A7Zbi1
        14HdnLCwtGFjQa4B7P9jsvE=
X-Google-Smtp-Source: ABdhPJx3f/FMDGIkRSSCKssho8/91m8Do/pHuvLjoIxe/An5GLKZjPVigxfCNRrpmDmloTAN/1P4hg==
X-Received: by 2002:a1c:80c7:: with SMTP id b190mr10769723wmd.87.1631536082749;
        Mon, 13 Sep 2021 05:28:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm6839689wmp.1.2021.09.13.05.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:28:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 01/21] trace-cmd library: Read option id with correct endian
Date:   Mon, 13 Sep 2021 15:27:39 +0300
Message-Id: <20210913122759.3672494-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
References: <20210913122759.3672494-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The id of a trace option is 2 bytes short integer. When reading it from
the trace file, use the tep handler associated with the file, if
available, to convert the option with the correct endian order.
A new helper function is introduced to read and convert 2 byte integer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4f..0dbcdbdc 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -336,6 +336,18 @@ static char *read_string(struct tracecmd_input *handle)
 	return NULL;
 }
 
+static int read2(struct tracecmd_input *handle, unsigned short *size)
+{
+	struct tep_handle *pevent = handle->pevent;
+	unsigned short data;
+
+	if (do_read_check(handle, &data, 2))
+		return -1;
+
+	*size = tep_read_number(pevent, &data, 2);
+	return 0;
+}
+
 static int read4(struct tracecmd_input *handle, unsigned int *size)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -2660,16 +2672,15 @@ static int handle_options(struct tracecmd_input *handle)
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
-		if (do_read_check(handle, &option, 2))
+		if (read2(handle, &option))
 			return -1;
 
 		if (option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (do_read_check(handle, &size, 4))
+		if (read4(handle, &size))
 			return -1;
-		size = tep_read_number(handle->pevent, &size, 4);
 		buf = malloc(size);
 		if (!buf)
 			return -ENOMEM;
-- 
2.31.1

