Return-Path: <SRS0=Xrzw=WF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B9EC31E40
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A93E20B7C
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Aug 2019 08:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XgPctS15"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405690AbfHIIGt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Aug 2019 04:06:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38914 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405567AbfHIIGt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Aug 2019 04:06:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so4756711wmc.4
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Aug 2019 01:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VqMOUTuD2s5Dbp59FMHyRSWw9hchSLCbb+LBTKkCOv0=;
        b=XgPctS15VmVBrbuFUKDCuAqYuD+EsUdOptQ4SSfBKPVIf33XaqS89XChWgoNPpXE/i
         Pw2TYdtUOJHiUe9lQjapIKAlVAFRUS+Y8q/IZXSVd9G5tXaGuXG4A3uLlWcFK/bAIMnk
         zMs53olaf9LoQn0yElTC1/s8LgZRuDSiGAsIGvAyacj0lOPAB8vzRw3rgJut1LjRMcT0
         enaryLh1fdZJzoJk7ShUiTdUajvNDci74S4+uYBEn6Iuo/qjB2EaHe9+Minksylzldql
         xqRXlmB7cLC9216Uaq3AUehJujZ9+0RWHPT0pnNSOTR8hFHs0Cguxmg0vMDwXUdq/y0G
         IYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VqMOUTuD2s5Dbp59FMHyRSWw9hchSLCbb+LBTKkCOv0=;
        b=LDE5BWeC1RO1gLRLvxBF069/3LokuxG+6luJR6Nh8U6FNZOio/np5In+5ZxXY3PhSj
         0ciK5TKirg7lNiNsqZ9VDK64cuv8LmUbsBw5JLLKnprkkRNobJw4rLrbXCHxIRiVuVpd
         eaH/dZUHuCkU0IyM20bI/aUuUeKDpTgFmrG1cpYVSA5+ylQR/slclV5D1+9IOsrRGLDS
         /FdEyDpDDn2OuaXA0CV/vQsu01Tt3ppLnShKSytfmDfDCV+++WA++wNbEkUCxSzgGFPD
         wgBVWTPmXMZ2NmXLdqz/YS4IlMTILuynolysiV69dyVXgGHclH8/PDC/M7l7hTaYh9zi
         Fkpg==
X-Gm-Message-State: APjAAAWbXYYFBYzhV8y9ReyeD3O4ScIh8smNH0kHpqoWaKHOMRqVz/sJ
        JYGMmXL6AqlwtdR4yFXuhB0=
X-Google-Smtp-Source: APXvYqzGf5d21BPmT9EXM2MCivDs0G0cfbobE7RQjvcRa0EQg8THhO74BZRt6ZcT6DfLOSZmr3qg1Q==
X-Received: by 2002:a7b:c149:: with SMTP id z9mr9570761wmi.0.1565338007162;
        Fri, 09 Aug 2019 01:06:47 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q124sm6964302wma.33.2019.08.09.01.06.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 01:06:46 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, mike.auty@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/3] kernel-shark: Use standart error message in KsMainWindow::_record()
Date:   Fri,  9 Aug 2019 11:06:23 +0300
Message-Id: <20190809080623.7548-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809080623.7548-1-y.karadz@gmail.com>
References: <20190809080623.7548-1-y.karadz@gmail.com>
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
index e9c6d54..b462ded 100644
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

