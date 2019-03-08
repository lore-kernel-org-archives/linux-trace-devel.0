Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BFC5C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3E3220851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfCHROk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:14:40 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51844 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbfCHROk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:14:40 -0500
Received: by mail-wm1-f67.google.com with SMTP id n19so13207234wmi.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 08 Mar 2019 09:14:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FX6hXlBTlZ165tI/EewOYO80nEa1jieyDK8ocZCG1L8=;
        b=HnmjQhCF/tZaaYcHmeeYJtIqr2vTHTYojk6Kx9zM7S89KYD7ub4JHnVJhG4fqeTPc0
         w1fmY85twEkEKYhwatNI8vG1kmzM04L+UW346VxK8Zw81m97XGIC0GXnXqkf653LFrt/
         UAVl2oYIVdQzLEidWYOEpOw2rOKZHvoKwJvbUwwtwNjpQoeUjB1QLOSZoM85BgAc4QYW
         xNoCXsI8ZdCblQpoEPj72KkILPGQqdm4uL3Q9lbDa3WC7w4gb8tVPTLPz4qa1lfPxGEC
         cMAIr2saKLMOTV2ScuW1ypsAXZwBzQPNd7sKo2MFSFlt4DbJQNxvKrK/v7uu6sy+3iWK
         t+QQ==
X-Gm-Message-State: APjAAAVdnPY59JawGfu+KDSK8rASSeWPBNOx+j/8+uHT6g8TUwpE/Xqc
        cj3d+y505xmnfiQZcqN1Pe8=
X-Google-Smtp-Source: APXvYqxV71L+PZDQf/LXPQ717EYjLiAD4eBuGkfHcfktdTTVNBU2kbBNEF7NGlmO9VZlAD6skmpKGw==
X-Received: by 2002:a1c:9c12:: with SMTP id f18mr4188957wme.16.1552065278411;
        Fri, 08 Mar 2019 09:14:38 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id o5sm6126796wmh.12.2019.03.08.09.14.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:14:38 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/4] kernel-shark: Add icons for "Add plugin" and "Manage plugins"
Date:   Fri,  8 Mar 2019 19:14:05 +0200
Message-Id: <20190308171405.15266-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190308171405.15266-1-ykaradzhov@vmware.com>
References: <20190308171405.15266-1-ykaradzhov@vmware.com>
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
index f6889ca..782b230 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -229,11 +229,13 @@ void KsMainWindow::_createActions()
 
 	/* Tools menu */
 	_managePluginsAction.setShortcut(tr("Ctrl+P"));
+	_managePluginsAction.setIcon(QIcon::fromTheme("preferences-system"));
 	_managePluginsAction.setStatusTip("Manage plugins");
 
 	connect(&_managePluginsAction,	&QAction::triggered,
 		this,			&KsMainWindow::_pluginSelect);
 
+	_addPluginAction.setIcon(QIcon::fromTheme("applications-engineering"));
 	_addPluginAction.setStatusTip("Add plugin");
 
 	connect(&_addPluginAction,	&QAction::triggered,
-- 
2.19.1

