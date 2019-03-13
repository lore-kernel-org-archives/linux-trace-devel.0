Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87CD4C4360F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57EA4214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbfCMPHx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:07:53 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55719 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbfCMPHx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:07:53 -0400
Received: by mail-wm1-f67.google.com with SMTP id 4so2421890wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zM4/cniex0RPub+n6nwDE8Ty05i3cXHEeJjGDBMBfRw=;
        b=CuxXH8smCWA+WTHsj5nYMazRqdN6R6K93tDbVbPLZGxkHXZgJC6Sam3+CJ7zhuCdde
         Ka5ndSDgNEYwVJdkUkXWUXq8/aH13n54MlEp4RTttwXpnI15YuZVHofhPUfe2kUubA9k
         ac9XpiGAzXbLdRoOhBhQ2edVGSxcIUyxpVKxOXHXDOE42F2NIyR5Sr0FIVFU4B+6zbI8
         vfJXgk0ebXTSLKaIZwnviZPn4eAnlpPJglWbEbG8cPMw5UD3/ztPd+ufVQcToIsP5bZ7
         8iL4PGFXdmaFh1Rg3nk0xAJIZkRG0V7MkFDHNTM1gU+N0QfcEW+qv59MW0Ha6J22gY2i
         0YxQ==
X-Gm-Message-State: APjAAAVdBUu1G4tSoxdz0mf1Ex8/YVBcybYSZQPM5HoaaRkET9AHunSG
        6DCnSDz/YccuOPMpsg6et6Y=
X-Google-Smtp-Source: APXvYqxCunxlufyu1lVshWy0bz7siukYUAf6xUZLmIJsMpqP3D37/YQiqK0P1BViDvId8hqVg8DYcg==
X-Received: by 2002:a7b:cbd1:: with SMTP id n17mr2558290wmi.21.1552489671614;
        Wed, 13 Mar 2019 08:07:51 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id f6sm22515103wrs.45.2019.03.13.08.07.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:07:51 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 4/4] kernel-shark: Add icons for "Add plugins" and "Manage plugins"
Date:   Wed, 13 Mar 2019 17:07:17 +0200
Message-Id: <20190313150717.21345-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190313150717.21345-1-ykaradzhov@vmware.com>
References: <20190313150717.21345-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Just a small cosmetic improvement.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsMainWindow.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index f165797..8ac19a7 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -229,11 +229,13 @@ void KsMainWindow::_createActions()
 
 	/* Tools menu */
 	_managePluginsAction.setShortcut(tr("Ctrl+P"));
+	_managePluginsAction.setIcon(QIcon::fromTheme("preferences-system"));
 	_managePluginsAction.setStatusTip("Manage plugins");
 
 	connect(&_managePluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
 
+	_addPluginsAction.setIcon(QIcon::fromTheme("applications-engineering"));
 	_addPluginsAction.setStatusTip("Add plugins");
 
 	connect(&_addPluginsAction,	&QAction::triggered,
-- 
2.19.1

