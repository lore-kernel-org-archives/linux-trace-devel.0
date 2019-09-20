Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB57C4CEC9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C02312086A
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:29:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfHMA4X5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405205AbfITK3T (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:29:19 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33590 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391072AbfITK3T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:29:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id r17so9211252wme.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 03:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5D3dIP6GrJGfWk884UHMADwhz3/aV9mrpLdCpzKtnpc=;
        b=bfHMA4X5rFPHeuOXA9pRkflTVxx7oDTl3BpcOtICq+Igincr/Ghs1v9svkeCLQkrQy
         ggR//LGBPskDIUaDWHPmsA3aM3qh5IkqHOJay/iI8FpQfdkN89c6Ui+bPCWf0OQGhvRq
         xt639Ub/84Rufg/wf+F1W5cY5HkBfTDBBziLi/Wftmlm1XBwWOYFDtbB2XC9jCduo1yD
         nrwB8Zzkc7exyXFYMk1qh+G8Y+4NslPYGzGMXZ74datP+uhqTREqEpFr3EkIIrNfQvz7
         J3D1LvKpPZY7Ehm3tKWLach+/SU+s9Jgw+M5Y63zQZiEEeCzSJKFSxyXctmEF1qwaV8A
         Ejag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5D3dIP6GrJGfWk884UHMADwhz3/aV9mrpLdCpzKtnpc=;
        b=aEfoiNlV5xO8lkjbf1Il0Y5GWZIo02dRUP76WtU9bqH5Nz9p0LCB/p1YT1aR1nxsf8
         qfT1DS9AIYs6QJ1s6LZjee+k/x5gKYV10v7TEpj+jdqEpTwkD5GeScQsCo619qcJ+qTG
         9OkOU1LbsoozgBBexC05F8bpyyS/b9i963UufDfeLc71vPBh6TG/BBD+vw79iuJAAosx
         c1NDZOpdrBIEMoL5zc0GGpNfjVS/bowZEwpe6vboNCaSLT3GVFWrKWU6xR/Z13wEsTs0
         T6qUhZ0C7g6AB9fxNm2rogtwtpD9pjMeSpjpUQR3sA9iCdkeGRV/33RtLdX1ZSgKH5yF
         GX1A==
X-Gm-Message-State: APjAAAUctVGfJZp+K0SNC+NcExyNUjL2Yr99fU8Yqws0YKh9iWaWbFF/
        UcDsAGIEssm06SMOvQXrXftQ9abq
X-Google-Smtp-Source: APXvYqxp+jWtZ+u1VHd8MyV0cfFgqZUdujRtoq1fmW8XJW92RiN+XlBogldihaoAaj1TlqEWq/pc9A==
X-Received: by 2002:a1c:9a46:: with SMTP id c67mr2866683wme.115.1568975357591;
        Fri, 20 Sep 2019 03:29:17 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id k26sm1480136wmj.33.2019.09.20.03.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Sep 2019 03:29:17 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v3 3/5] kernel-shark: Use standart error message in KsMainWindow::_record()
Date:   Fri, 20 Sep 2019 13:28:50 +0300
Message-Id: <20190920102852.22769-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190920102852.22769-1-y.karadz@gmail.com>
References: <20190920102852.22769-1-y.karadz@gmail.com>
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
index c220afb..e24b0f5 100644
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

