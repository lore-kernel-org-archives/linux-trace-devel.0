Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84082C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Dec 2021 12:25:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhLBM2t (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Dec 2021 07:28:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235548AbhLBM2s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Dec 2021 07:28:48 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98877C061758
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Dec 2021 04:25:25 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e3so115373499edu.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Dec 2021 04:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V4T/nqu5BcdfnctLll0nHcIWzjBkei1sx3rSAABEUjE=;
        b=BjJufgRM1oCZsvqkkc6IXj3wEDkVarjut71gwkKReo6fEaQeH/WiTGXfF4ISLUQN2h
         IDE04AtIXAcP/18HIkcVtlv6MVPR0szbJ9A4Mv/pkCAX4Vqd+Kzs1yDRogONd61NKPAH
         +rA8fsKm2MoHkdQzGWDYbQdgzCwiY0HdZaJh2gh0WPquaKB6XSrE+HmPHZvlNrD2hKlX
         tF6vl7UWB/9OxvAxl6tJ6TtNq1/lkOJdBZypMvTW27O05dY6nBv7TuaGPwUkQsD0MJsf
         gVSc5Un1ABmI4nF97PE4XlOakY8AoEKHZe5YdH+QwImt+n+2JYzPjJQELU31Q40i11ON
         up3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V4T/nqu5BcdfnctLll0nHcIWzjBkei1sx3rSAABEUjE=;
        b=imYR4SE5LjNdmkP6MRCei95JU5htYMmj6UinwIMd3l0v8RGBzsk0dm9M9VbAcOabIZ
         pIX0ZjiIuIASoZeHLecyz+PVysEa7ZX2zQEh7TjLkJBpTnvcT/vAhqYGarMsMQGQGuDe
         +hXV3V19W/CqVbPk4CZVrs6iSc9YTz3VSpjOJiVZYz2RCGPcVzPpBCb1xZS3EGNR9isU
         i+B2Ov5xFeTJGxu7O1Eswe/yLPR/9ElqSNsGK0TWJu0TKXc7uihrVMfMALM0TTntkWAu
         Wn5mjtQouuWcQi2IeYzrLugSDw4IJH0rGL0WIT+2T+sG8dIXFVk9X2IQYvyfnxGYVcdw
         ex/w==
X-Gm-Message-State: AOAM533J56WS6YWsWPGSUNxz3QwMc8ROvX1P9ex8ezDzv7Mmvxl+MX6i
        Tl5KnFLst4s0bRQ59rfXurm3+26UABaw2A==
X-Google-Smtp-Source: ABdhPJwRtKvwT1vWR2TJE39NW5Bk4nvU0GHRE/vEnDlzZ6WABO2D6wOJ1ezCZImGK800saA2fCiE1g==
X-Received: by 2002:a05:6402:350b:: with SMTP id b11mr17545878edd.212.1638447924184;
        Thu, 02 Dec 2021 04:25:24 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id eg8sm1998507edb.75.2021.12.02.04.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 04:25:23 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 16/20] trace-cmd library: Decompress file sections on reading
Date:   Thu,  2 Dec 2021 14:25:03 +0200
Message-Id: <20211202122507.43572-17-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211202122507.43572-1-tz.stoyanov@gmail.com>
References: <20211202122507.43572-1-tz.stoyanov@gmail.com>
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
index 9bf5cf7a..69c7c55d 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -481,12 +481,15 @@ static struct file_section *section_open(struct tracecmd_input *handle, int id)
 
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
@@ -1109,6 +1112,8 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		return -1;
 
 	section->data_offset = lseek64(handle->fd, 0, SEEK_CUR);
+	if ((section->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
+		return -1;
 
 	switch (section->id) {
 	case TRACECMD_OPTION_HEADER_INFO:
@@ -1134,6 +1139,9 @@ static int handle_section(struct tracecmd_input *handle, struct file_section *se
 		break;
 	}
 
+	if (section->flags & TRACECMD_SEC_FL_COMPRESS)
+		in_uncompress_reset(handle);
+
 	return ret;
 }
 
-- 
2.33.1

