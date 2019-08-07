Return-Path: <SRS0=VASF=WD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C895C433FF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Aug 2019 12:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B56C21BF2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Aug 2019 12:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Go/bTbFL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfHGMOw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Aug 2019 08:14:52 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51865 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfHGMOv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Aug 2019 08:14:51 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so81605249wma.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Aug 2019 05:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlXoPubFdxpMU8uPmJoRRDkP4eFWiFs3MGsD9dAop7U=;
        b=Go/bTbFLpETQE+UZ3uiubIX/dyfNLvOgCRIsKshHxbgtyYZQ2oYTl3aoYktRbQB6+s
         sSouu2/0rw0VvWv2Lrfj5tcx/fsKZVF49AmC+xE96yoAPwwqg8eHngzgSKQqekBfFH+l
         3SS3wHhGq7QS+4xbjjACLK4Tl5HvU82AF73SInnjtkqHGZqGKSHs6z4DrxO3Hy7fgp+R
         2P96G6LAfJtrbYanlVNyrzbgYUKP57fjCOxBTpnlhqSJPt0SSM0so3Zu/6ANpyHQptn+
         xKCweN8qvvcL98KO9H0j+fT0eW9qrnskpxKOj6os+pUXVoBiYh0tth3Zt4g0X5+f8g/y
         2FgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nlXoPubFdxpMU8uPmJoRRDkP4eFWiFs3MGsD9dAop7U=;
        b=qV8X5KpA/sx7Dss+nrhKLLY+rjSZv5RrtqC97WymCHmIY2dR3EzWagwgRrpLA4UKzE
         AvfoEEnitrHs1uokArjlR90DTFVeGAL9pWQdXlJR3TTUP3s6apCsqG49yrAM94c6CJMW
         ojrYajKA5QsKl8zvuqWe115vGwJwXyimToxcJeXhl4/kwEmF7S+BAXHl3GpuEAxrIFUf
         njDQ2wluozU4QFWCrKT/EV58DfXxg4nSRzX6lgVBuqUxpMm/n2kCYqhqS5vjmyr0Nh9K
         UD164EXLvxmemjuOGJBZpEUuhGKDpfkuk7Ne/uNHFnow+9Kz8kRT1Lcl9IdnkImgIj0q
         E5BQ==
X-Gm-Message-State: APjAAAWkLs188wqW/NXq9iEFN8kbtWLxncs4YU9XMYJNIFYWlNyn5TbD
        KN16n4ZehXRP6mqXrKRblheOn4mBUpo=
X-Google-Smtp-Source: APXvYqzWWSX7h6aUzwtS0iYISeppyh+zzGjerDwfTQwz6yJ+mnHSJhMseBGv5+PlmS/wLuM+4sOmVw==
X-Received: by 2002:a1c:6406:: with SMTP id y6mr4099557wmb.146.1565180089505;
        Wed, 07 Aug 2019 05:14:49 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q124sm5855068wma.33.2019.08.07.05.14.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 05:14:47 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] tools lib traceevent: Fix buffer overflow in arg_eval
Date:   Wed,  7 Aug 2019 15:14:46 +0300
Message-Id: <20190807121446.1833-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Fix buffer overflow observed when running perf test.

The overflow is when trying to evaluate "1ULL << (64 - 1)" which is
resulting in -9223372036854775808 which overflows the 20 character
buffer.

If is possible this bug has been reported before but I still don't see
any fix checked in:

See: https://www.spinics.net/lists/linux-perf-users/msg07714.html

Reported-by: Michael Sartain <mikesart@fastmail.com>
Reported-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Tony Jones <tonyj@suse.de>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Fixes: f7d82350e597 ("tools/events: Add files to create libtraceevent.a")
Link: http://lkml.kernel.org/r/20190228015532.8941-1-tonyj@suse.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
[
  Backport from kernel into the trace-cmd repo.
]

 lib/traceevent/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/traceevent/event-parse.c b/lib/traceevent/event-parse.c
index 7cb2ae4..b36b536 100644
--- a/lib/traceevent/event-parse.c
+++ b/lib/traceevent/event-parse.c
@@ -2456,7 +2456,7 @@ static int arg_num_eval(struct tep_print_arg *arg, long long *val)
 static char *arg_eval (struct tep_print_arg *arg)
 {
 	long long val;
-	static char buf[20];
+	static char buf[24];
 
 	switch (arg->type) {
 	case TEP_PRINT_ATOM:
-- 
2.21.0

