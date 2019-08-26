Return-Path: <SRS0=87e6=WW=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6F8C3A5A4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E652186A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Aug 2019 15:58:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BTI/i/EK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730995AbfHZP6l (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 11:58:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38459 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732358AbfHZP6k (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 11:58:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so15873888wrr.5
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Aug 2019 08:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pGk3Fkj/UCkcl42ANHWIn9jjl0OuWDZv0D2iqKfZYb4=;
        b=BTI/i/EK/QYItZ/yW9iOxbP2VYLfAC6xN80M4xfprI4p/fMVV0WY9eL/1iLAM0d9IT
         2VLnNRzgFFzsJWSOfvhjgvTyM3eB5r2/WGieV36LHM4SVtDtX+IXOFbmpaJip5PksZtK
         dUz9lom+CA197/ZAZXqEMa+wCmvURbh/UtijPSCs2b9D5XPPQ+KnYQ9UtKE6V/7iN71M
         w7nYuZVT6xAPyECxRozCkYzEZ0ogiTIVpQB5HBTy8hzJF+Qzv1EHYXMXWGhEotIJcaM3
         XUAVKoJjdg+BjAgDsb3ll3qy0I8axPmWQ7AgVMcIWOL904D/J1wleFPw4Jf6yj2XTvAO
         5WjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGk3Fkj/UCkcl42ANHWIn9jjl0OuWDZv0D2iqKfZYb4=;
        b=rRGe5vHgXtcxemxCqjAP+YtofaMegqu3ibC0eC86aifQG9+eVf7Ic/x8BWNqIonGzC
         OPEvJD1q2eQjJRwFQTr9Tp/ac+YubKKlYLBBr/F281ot0TVREgXuGuhdIE2bvks6isq5
         n6ClPorLe7g3Uk1ywIkbO9DXgne0PFmWe03hNIuo4E24AVdyHV7PSihQQfbKPiSOmXS+
         GSgMjYecIZPe5iGfIoZuI4U7d7qTXs6C5pZn/CdIX8Fl/QJamHYtM8T/ZIfKLGVXGUde
         ZSJDad95SjmlWK1zcYGCEvN8KEgtWm5wJo1EdZliCk0Bykcg6zfH3i11VLuPOAaKFnVu
         UR2A==
X-Gm-Message-State: APjAAAWZjjBGlSxqWY6kFIkciC7YVv4JV2wmKyo6SyIaR2E0PHtNkRbn
        R3J9xKCH44d6pWny4ach2pQ=
X-Google-Smtp-Source: APXvYqyzGGvgchQFfreBH3ccofl+vlG7rUy4KD/ke7Vk64uvoe+uD5UB9/ofWi/28Y/9Ysypfr07BA==
X-Received: by 2002:a5d:634c:: with SMTP id b12mr2209480wrw.127.1566835118614;
        Mon, 26 Aug 2019 08:58:38 -0700 (PDT)
Received: from localhost.localdomain ([84.40.85.140])
        by smtp.gmail.com with ESMTPSA id p13sm14447458wrw.90.2019.08.26.08.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 08:58:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/5] kernel-shark: Use standart error message in KsMainWindow::_record()
Date:   Mon, 26 Aug 2019 18:58:09 +0300
Message-Id: <20190826155811.32021-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190826155811.32021-1-y.karadz@gmail.com>
References: <20190826155811.32021-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The error message is printed using the method KsMainWindow::_error().
The message itself remains unchanged. If we want to change the message,
this can be done in another patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsMainWindow.cpp | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 7c18391..73d6877 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -890,7 +890,6 @@ void KsMainWindow::_record()
 #endif
 
 	if (geteuid() && !canDoAsRoot) {
-		QErrorMessage *em = new QErrorMessage(this);
 		QString message;
 
 		message = "Record is currently not supported.";
@@ -899,8 +898,7 @@ void KsMainWindow::_record()
 		message += " ./cmake_clean.sh <br> cmake .. <br> make <br>";
 		message += " sudo make install";
 
-		em->showMessage(message);
-		qCritical() << "ERROR: " << message;
+		_error(message, "recordCantStart", false, false);
 		return;
 	}
 
-- 
2.20.1

