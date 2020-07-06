Return-Path: <SRS0=/o8m=AR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E77FC433DF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79E9A20720
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jul 2020 15:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Sx8JsAk4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgGFPrS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729372AbgGFPrS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jul 2020 11:47:18 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FE7C061794
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jul 2020 08:47:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id f18so42783739wml.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jul 2020 08:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZGA+BJt07LJzII0rPVumQ7zBXEEpMg/lQptLMLnM3FU=;
        b=Sx8JsAk43u6QXQF4y1hRo1xj8lhSw7IyCos6jN/1x5TRCohk2/P8zn1MitEu24pHbn
         GtIseruPn+WTDN5jOl5/A/uZGGhZIZywi6FAm5BnCCtmfxkNt56FaLGEgQQYCYzU9hlb
         cPNqeOpZ3eaNAMzKqIjfVS0yFkFxCPHzz2Z5B0xJXi2SbXSXctBzwFq3eFGJeb/e1ER2
         k3eG76Sy6tUpUE9uvEM8+yuufWRGR92xn9qyYKaIusvr8L/U3TX1LH5IQkSDmNJirssd
         9uwdKGzsfeUDoDlwQjIg1KojCZM644YrUGy2yZVfn4N3d5AVBTBFpGNph1qzjeGhmX+1
         ukdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZGA+BJt07LJzII0rPVumQ7zBXEEpMg/lQptLMLnM3FU=;
        b=H/Gocbomzp4jrGirigAecwcgVjlQmx7qUGDpXATa/ovQtqmz/3jAjqkL9xhoC0Ej00
         Cp/M3DeKuxN+u+KJG4XhW68uUKawxY5EmzFLWgR+n36Ey52AGSPoUFFL7eZEvRyf6toG
         q+Tl7RDYqV78EexdxeebUgrlQJBFQWv+zFCRuioiFWZSY/j+xUhT+5xwXn/nc7ydLLMR
         1vYqqCy3ozxoJB0lo8YLRUHqtv+9DC45WNGn8fPVFX0lA4fDt2RDzq2/CTpEISIPFqaL
         i0PaO9qviOGP7JdQPr3+FHJE4MWIXGFMfTlrcHtB1RIrUNZsFhbUylvKY7jvIDEO9a2F
         WgIw==
X-Gm-Message-State: AOAM531FcNHgZblmzShIVPPnKKyhM5MxG0kG70jdy2IeQZkMUtgX/t4K
        KgKQhSSpNp8txo8LB5O+JB8NpQRveZY=
X-Google-Smtp-Source: ABdhPJzkfkWJRTqvMyS5fkvQfaetenaPq5TUu/azDoZoyF96Ppdr+Xk7nNkDbng5pGpykofuxQ39qQ==
X-Received: by 2002:a1c:964d:: with SMTP id y74mr45921512wmd.80.1594050436452;
        Mon, 06 Jul 2020 08:47:16 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id d2sm25136813wrs.95.2020.07.06.08.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 08:47:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: Fix kbuffer_start_of_data() to return the first record
Date:   Mon,  6 Jul 2020 18:47:14 +0300
Message-Id: <20200706154714.27566-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The first record in a ring buffer page may not allways be at the
beginning of the page. There could be time-extends injected before it.
In this case kbuffer_start_of_data() will not return the first record,
as expected. Additional filed "start" is added in kbuffer struct, to hold
the offset of the first record from the page and kbuffer_start_of_data()
is modified to use it.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/traceevent/kbuffer-parse.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/lib/traceevent/kbuffer-parse.c b/lib/traceevent/kbuffer-parse.c
index 2c5f00a9..844db976 100644
--- a/lib/traceevent/kbuffer-parse.c
+++ b/lib/traceevent/kbuffer-parse.c
@@ -35,6 +35,7 @@ enum {
  * @next		- offset from @data to the start of next event
  * @size		- The size of data on @data
  * @start		- The offset from @subbuffer where @data lives
+ * @first		- The offset from @subbuffer where the first non time stamp event lives
  *
  * @read_4		- Function to read 4 raw bytes (may swap)
  * @read_8		- Function to read 8 raw bytes (may swap)
@@ -51,6 +52,7 @@ struct kbuffer {
 	unsigned int		next;
 	unsigned int		size;
 	unsigned int		start;
+	unsigned int		first;
 
 	unsigned int (*read_4)(void *ptr);
 	unsigned long long (*read_8)(void *ptr);
@@ -546,6 +548,9 @@ int kbuffer_load_subbuffer(struct kbuffer *kbuf, void *subbuffer)
 
 	next_event(kbuf);
 
+	/* save the first record from the page */
+	kbuf->first = kbuf->curr;
+
 	return 0;
 }
 
@@ -755,7 +760,7 @@ void kbuffer_set_old_format(struct kbuffer *kbuf)
  */
 int kbuffer_start_of_data(struct kbuffer *kbuf)
 {
-	return kbuf->start;
+	return kbuf->first + kbuf->start;
 }
 
 /**
-- 
2.26.2

