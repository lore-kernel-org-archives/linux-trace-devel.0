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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC38C4332F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10F6160FC0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhIMMng (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239992AbhIMMng (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:43:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CB6C061760
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:20 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d21so6780729wra.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WSh20c6YzUYMR96Re8GlZB2NA1Vr5MUK5hyf06tEWoQ=;
        b=ZkaKXAX3eySQPletyY8SKHyfahtk9c05TWU9CQlPlMSi9fLwjJErTK5pGy++48vLOl
         mhPaVEYkgywPxwXJFTIASUvosQkNcCmRGDbJtBQ7gcII8HxKtinoa7qBrt72Ud5QsJeD
         jsHKacWBzYLVeX4tT3lNwfG/Kk7OVZGDztEUIhMpgLW2NWTbWAvnTq9h8CPEZwNYbvq/
         RCBl1yHs6hFtdNpS4wGt2KVenTKjxIOstaaiBE8XkSx6WJVcBuQ0dUGv7iXey6KBRsEG
         10r1s+VW0/TdHlPUaFkaQ6UK+uBrhjqB6YeCBorsOX+9A72Ab9/4Nj9CAlNGtc7rvihA
         9+Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WSh20c6YzUYMR96Re8GlZB2NA1Vr5MUK5hyf06tEWoQ=;
        b=0GLvfG7z7itj0kHxPC1EqHUljq2pxL49Ps1e/G9j6MPUsPIA9h2dynjjT32TqA4VZF
         Ki+MmwgmgKp4q/2XPaX5ArlgrLWFzRJlBhdIfq4LXKrEjTu8W743b9QNS168QQXEKKeM
         ZPKVYkOYg3KMyLPke1xqhyBzrPLAlmKUr18kcK/0Ke6jDUlr21XFxXycnq1znPrWYk5u
         UJuQfJyKi3IXkMxsNv7MlMW81H7N8ldh7Bw6eJP4hCixS9v+PUyJW3avviyK9hKq1V6r
         OGMMMILWV3yF+rNT7XfKlW6Kzql4bpNZMsDdxpwtcc2BhGGGPLVTdWPvSSL/Yquv+1HC
         2rYQ==
X-Gm-Message-State: AOAM532rUAS4/P9dsqTXc5pTW7z12zBuj+xr7n8KpcJcmBUgv6eYA9QQ
        mmHdzMtqnTedHA9tN2nbSe/XhW+5pe8=
X-Google-Smtp-Source: ABdhPJyw1wb7H1UxyL4LjxkvKWdJtGo8zBvBAGFLJuP32/MIOTCUpajfrHX1Ev21yWmHeG0dS4q0dg==
X-Received: by 2002:adf:d209:: with SMTP id j9mr11490090wrh.97.1631536939238;
        Mon, 13 Sep 2021 05:42:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u13sm7244290wrt.41.2021.09.13.05.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:42:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 16/20] trace-cmd library: Decompress file sections on reading
Date:   Mon, 13 Sep 2021 15:41:59 +0300
Message-Id: <20210913124203.3677760-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
References: <20210913124203.3677760-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When reading sections from trace file v7 - check section flags to find
out if the section is compressed and decompress  it.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index c901be0e..6ed5edf9 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -480,12 +480,15 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
 	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
 		return NULL;
+	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return NULL;
 	return sec;
 }
 
 static void section_close(struct tracecmd_input *handle, struct file_section *sec)
 {
-	/* To Do */
+	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
 }
 
 static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
@@ -1116,6 +1119,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1141,6 +1146,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
-- 
2.31.1

