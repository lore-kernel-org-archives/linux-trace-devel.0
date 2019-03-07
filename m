Return-Path: <SRS0=dlhe=RK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B589FC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 852FC20449
	for <linux-trace-devel@archiver.kernel.org>; Thu,  7 Mar 2019 15:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfCGPFo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 10:05:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46124 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfCGPFo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 10:05:44 -0500
Received: by mail-wr1-f66.google.com with SMTP id i16so17798894wrs.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Mar 2019 07:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NdMzN8MIJtdVLbpS/kta7Rs50VSBU0N/4h520Ka2nEs=;
        b=dFoeTI6jRpQuv6R8xPl/rvsV1ZdGo+FY2/s3xusAyyEQUE3MRnGtnVEAqpzz6jrHw4
         gL9VwKCnfTkfhvMfwpUMD10iSt3aXP+clEnp7dfRZ1Bx7vnfAFOx8qubW3468l2yzQIM
         mUazyTu6llf6HwqnS2P+MmxAYaJFafL+Gq7Lr8yY/t0iLu2oe1xxdHztMkbTfqB4x+Yu
         s8HIpMcm8mtG91wqCzi5rQTru8Ib3kmu/qULO7I7IyN3emhcyG6G21MA2tZLwQ6q6t6N
         aTaTeR6r6FIPH0/DFg0X0ULvwwpcR1CX+NzSQHvWvi/8Me1btcTv9Ap0S6NFiZH2Enmz
         lhTA==
X-Gm-Message-State: APjAAAUkuADuKc+WCP/yWbo4WHDeUfui7XzfXW3yebxJ2mXkUmhnt7wx
        LBx97K2qlrAF4ipQ+ckpXkEF4cB0dYA=
X-Google-Smtp-Source: APXvYqw7w74Q2E0RB8xz8SJ+/qy6tLtB7NiGArjPocqfXyM68cetHXdskwM22gxx2EWNyAMOu+DUzQ==
X-Received: by 2002:adf:cd0b:: with SMTP id w11mr2340615wrm.95.1551971142436;
        Thu, 07 Mar 2019 07:05:42 -0800 (PST)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id d15sm10281274wrw.36.2019.03.07.07.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Mar 2019 07:05:42 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 4/4] kernel-shark: Fix a bug in KsPluginManager
Date:   Thu,  7 Mar 2019 17:05:11 +0200
Message-Id: <20190307150511.17246-5-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190307150511.17246-1-ykaradzhov@vmware.com>
References: <20190307150511.17246-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

const char *lib = plugin.toStdString().c_str();

This line is a bad idea because the returned array may (will) be
invalidated when the destructor of std::string is called.

Fixes: 18cf94f485("kernel-shark-qt: Add KernalShark Utils")
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsUtils.cpp | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel-shark/src/KsUtils.cpp b/kernel-shark/src/KsUtils.cpp
index 34b2e2d..d7b1753 100644
--- a/kernel-shark/src/KsUtils.cpp
+++ b/kernel-shark/src/KsUtils.cpp
@@ -439,7 +439,7 @@ void KsPluginManager::registerFromList(kshark_context *kshark_ctx)
 
 	auto lamRegUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
+		const char *lib = plugin.toLocal8Bit().data();
 		kshark_register_plugin(kshark_ctx, lib);
 	};
 
@@ -474,7 +474,7 @@ void KsPluginManager::unregisterFromList(kshark_context *kshark_ctx)
 
 	auto lamUregUser = [&kshark_ctx](const QString &plugin)
 	{
-		const char *lib = plugin.toStdString().c_str();
+		const char *lib = plugin.toLocal8Bit().data();
 		kshark_unregister_plugin(kshark_ctx, lib);
 	};
 
-- 
2.19.1

