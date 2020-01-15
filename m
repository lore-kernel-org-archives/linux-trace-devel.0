Return-Path: <SRS0=5FGG=3E=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B1CC32771
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE9324679
	for <linux-trace-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oa2434Im"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgAOUFS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:05:18 -0500
Received: from mail-qv1-f73.google.com ([209.85.219.73]:43149 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgAOUFR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:05:17 -0500
Received: by mail-qv1-f73.google.com with SMTP id z9so11747338qvo.10
        for <linux-trace-devel@vger.kernel.org>; Wed, 15 Jan 2020 12:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=85Y3kT7DUcW78Vgz7+hc4B74xBpVQhVQsdhAEkeO9Lk=;
        b=Oa2434ImQh3lOHFDGbj0HguXHQEDFexT4V4cIO2Ct50P3ZCO9vE4TbAlTATDzaxwfr
         wwZF1MIK4O2Ru0H5OVrsbLFql14Z0/SwTZ7J518gVLi2zGjWcbkkb2PkITIs52D2TX+r
         5OV+0LT4JkLpemyUdlWDkJ7M3V9JO+OA76IiFDbR3c7PxwQfgvZIItoGXx4OIT0W1Ie+
         umgNnOU0bb2fNxvwrlu3njxirmAQqvLWcGlTRPMxTEs/n8Y7VJ17yW4rqlk5PHdiDp0k
         SXoqxJpY3WfqOWddFwAXR+4cyGCYuKG5/31CPct3lnEsQmTX6vQgOdutEC4HYkT742q3
         tUdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=85Y3kT7DUcW78Vgz7+hc4B74xBpVQhVQsdhAEkeO9Lk=;
        b=Z44VRZjkiKc6OnScsXCa4HbZ4/9nSe0qB5AdF3/9BJS7UuQ/ZgzS0FwzpIUFZ78Dcq
         H36vV03ysTBKyP0hRvdICr99O7F6AZSWmIsVNHvpUqCijxZRe9+i90duTiwmZnWaXBgH
         wcR2ShsyvIVdxxM8TkuH6r69/jYU3An1k57TuN0NFKekDaQZcz3z6DSqFjfumoA5TPAx
         J6QMowxq63kzn4IByOKmgAdRLnWxBx3pceAI1zaSkQ9R9y5tVHgd86Lt21MEMrCqlKR5
         OW3jhcQDuEKe0Q0SEUjrd9oCCGmHvjTEA8A1caMsxIDexTJvy8mpjrfmM0aIH0UO1HfK
         vi5A==
X-Gm-Message-State: APjAAAUX7Cys0+uZ0O3Rsc8kyIh4KGLZeF7PwYg+4NWFQcHJZ+HF9Ckn
        WsE7ryenkR/A7kE+8hj2Sv5wT7Azg+Wp8aMgYT0=
X-Google-Smtp-Source: APXvYqzF8ByhLvgIj0bfnxQ0A6uhm9kINtpVWGz0gQUPEulNkF0VkyNXzPuXPBSPsMfJObA+IgLum1JXzILMGQ4Fc2Y=
X-Received: by 2002:ac8:3631:: with SMTP id m46mr345400qtb.226.1579118716743;
 Wed, 15 Jan 2020 12:05:16 -0800 (PST)
Date:   Wed, 15 Jan 2020 15:05:15 -0500
Message-Id: <20200115200515.207711-1-marcgonzalez@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH] trace-cmd: free kbuf on malloc err in tracecmd_read_page_record()
From:   Marcelo Diop-Gonzalez <marcgonzalez@google.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This fixes an unlikely but possible leak

Signed-off-by: Marcelo Diop-Gonzalez <marcgonzalez@google.com>
---
 lib/trace-cmd/trace-input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac30a60..68da3a7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -1746,7 +1746,7 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
 
 	record = malloc(sizeof(*record));
 	if (!record)
-		return NULL;
+		goto out_free;
 	memset(record, 0, sizeof(*record));
 
 	record->ts = ts;
-- 
2.25.0.rc1.283.g88dfdc4193-goog

