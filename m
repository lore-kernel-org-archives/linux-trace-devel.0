Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A9B9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16639610CE
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237272AbhJHEYb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237548AbhJHEY3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:24:29 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E941BC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:22:34 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id t16so9453914eds.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NhNKCt42LjGqWZzqsilFGm9PzXjpdDKYXJwMnrgf8S8=;
        b=US58dpwVeRd5nREiQ3CLIPT6aRbv9bEExI9R4qrp7pQStfU0QqTdsHVVAlS4NQQgK7
         fPCMErm/AzneHwRk+ZgbTb6FV/iSblOdvTs1D+hqtG9k6ViTnXJRZvhyBt5SSakoDops
         ksqGY0ueJgjGZ1V/9eZAUnS49DaxMMHZ4dlsxrJFaW/e260xljemkNjboRAfItl0XF0P
         dOUbkkEQhzwBzwR9FUy/aljMoy7o4obVVC462sCG5vyu7fA1r56WWgcTbNz0Egwhb2v5
         y9NURQlDjG2eEc+DhwQ1+h6pIbehXrcL0qJkDchyUn19GAmHgClUugMdZ9ORDM377UkB
         6R1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NhNKCt42LjGqWZzqsilFGm9PzXjpdDKYXJwMnrgf8S8=;
        b=V0sssCQxFw5bcd/q4gcdIN6Lm5tUuGGmsuP+eM6qhU48go1SdUTvqV8ILqY08YqrcH
         2600vViaAltR//vDiR4U8ufh8aq1DTVru5dUU1kU/fu/JYRzo+Sl6WQWnoqX3c/rA3X5
         7LfIoeE90lG1xIjwQ+i3hrd5RHmSHlZV4aD5Q8FzL/+hr7K4abIb/gCTL8mIaoWhYFfN
         ZMTWiiEMCkXsuUVHnV/5m8iQWNSdjjrl2r5EW7rmycxvXzbYUgdz9rpvKC4L15npXl3f
         BxaRiQKKGQpaz6KLmR4muRZgXi8zGxn4rEDtXhpVbZbyOwI+JueC6YMomO2uSBFShBl/
         0abg==
X-Gm-Message-State: AOAM531tO3yCOML5P0FWV/jeU9723UrUXGm5TCYd748qtH/+zHsjS8IX
        R5ALwmM7taoM+KI8dVEN+8q7XH02+ZDvDQ==
X-Google-Smtp-Source: ABdhPJzOhASNr9zU5cIwtRGSrX9TtbC28G5nOrjFqlRqZxG+wt/XVziHZ49WyyeabD5R0kMCT3vmPw==
X-Received: by 2002:a50:d9c9:: with SMTP id x9mr11879458edj.179.1633666953612;
        Thu, 07 Oct 2021 21:22:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id g23sm517429edt.1.2021.10.07.21.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:22:32 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 16/20] trace-cmd library: Decompress file sections on reading
Date:   Fri,  8 Oct 2021 07:22:10 +0300
Message-Id: <20211008042214.977193-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008042214.977193-1-tz.stoyanov@gmail.com>
References: <20211008042214.977193-1-tz.stoyanov@gmail.com>
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
index fac19bc3..a70bb0e6 100644
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
@@ -1108,6 +1111,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1133,6 +1138,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
-- 
2.31.1

