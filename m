Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77953C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A8E82083E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 14:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qT3Ckf4a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgDIOZV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:25:21 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46891 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727481AbgDIOZV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 10:25:21 -0400
Received: by mail-lj1-f193.google.com with SMTP id r7so11612427ljg.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 07:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IPXo3ipOrTAxwuxGgnbl68DXPV7UOhDaywBUH+jWTU0=;
        b=qT3Ckf4a3YcbAePjLONmxgy6Vh9jyQRe+SdeNdXbUjaoXkbvbv0nvbqdYB9vm1ORcU
         ZQpa971LRvdhHwV6Ytxj7bTu4AbuP8iP775ZDW/inpvHJYtPcYcP4al5WdQeIP8lM1JB
         0GfGX8ABgYmyY72bknu1WiM7GBr0H1Ypjd4fDI9pQqP217AEMZ2quD4jD32u6xCLo9L9
         3Uae2wce7zMflVUzJgGIthQnVjJEBpmza3Ex/C5eix+gDepo9uf3MONa+r6txLvzZlbW
         hQ3IQ0RYrWcoieVpyLXNKHeQwEjc1qqVD7W/m+PgwY8mvejty4tCYibQ0yqsbYivT3Wt
         xPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IPXo3ipOrTAxwuxGgnbl68DXPV7UOhDaywBUH+jWTU0=;
        b=sats+eXwVXovSBQPEyYyu8qmUZlmcl7dd4nry52V20QeJbpjtoEh5nMaInkFZHcKTo
         EJuMsER5iNiSgrQpLQe/eVUBsF0Ra3v3Zs6OiebiKi6HToDmF1FhLGmdGZOoc44JNEXz
         SHwE+k2QGEf31fHNHgWWQ3ECu3nMWTIEPAt9QX25tpKGuInlTSh45n5PghUTpleZ9DwU
         zixuRxZ/qy866ehp/mKcWdBhQAjVhmzGNtNAwzG/ba45RgpRVV5RRtL4H/n1c+e2gh0d
         OdkaAaivr9NCkA7pVRD4raw422rXKhB77iw2F0hCPybauOvkdChOyHjdy87SBgGFU9jr
         I79A==
X-Gm-Message-State: AGi0PuZnyrF5tRwWiSjw9yit3Q1h2eCOQyZspWc8QCcWSvmAKCWObUNL
        0/3m0o3vCq76p0pGvsL2+3iQ/bGp2aU=
X-Google-Smtp-Source: APiQypIZJfUYdujYhXf9Yq1rlp8PLEwjD0mJd4u+/XXjmNr8Wcf3k+U1EX1rYD5Y7vbFEZr5M3G43Q==
X-Received: by 2002:a2e:8e36:: with SMTP id r22mr41334ljk.98.1586442318280;
        Thu, 09 Apr 2020 07:25:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id e7sm181230lfc.72.2020.04.09.07.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:25:17 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] KernelShark: Adjust the width of marker buttons
Date:   Thu,  9 Apr 2020 17:25:10 +0300
Message-Id: <20200409142511.82228-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200409142511.82228-1-tz.stoyanov@gmail.com>
References: <20200409142511.82228-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>

Both "Marker A" and "Marker B" buttons were too tight to fit the button's label on them.
Add some extra space.

Signed-off-by: Tzvetomir (VMware)  Stoyanov <tz.stoyanov@gmail.com>
---
 src/KsDualMarker.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/KsDualMarker.cpp b/src/KsDualMarker.cpp
index 3e0b462..e2b8ac1 100644
--- a/src/KsDualMarker.cpp
+++ b/src/KsDualMarker.cpp
@@ -145,8 +145,8 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 {
 	QString styleSheetA, styleSheetB;
 
-	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A "));
-	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B "));
+	_buttonA.setFixedWidth(STRING_WIDTH(" Marker A ") + FONT_WIDTH);
+	_buttonB.setFixedWidth(STRING_WIDTH(" Marker B ") + FONT_WIDTH);
 
 	for (auto const &l: {&_labelMA, &_labelMB, &_labelDelta}) {
 		l->setFrameStyle(QFrame::Panel | QFrame::Sunken);
-- 
2.21.0

