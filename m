Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E7CC43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B30C320811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfCNPKg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:36 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36093 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbfCNPKg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:36 -0400
Received: by mail-pg1-f194.google.com with SMTP id r124so4193483pgr.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qEaEjF5+SG8MasfO2pX6RdIriVLh4CMuBQKPK+CjZAw=;
        b=pIpw72TD4iGyQ7Sq+cqMZ/H/msafLt3XQENzE77wEwiwV71uldfGF/atL7APzWtASa
         a4ee79pBTxHXPHZWhMqIrKDw0Hr2bw5k6EE/lEFzQQQwkGPhg+uCs8Pe/680MOdrYJHR
         uckw5STO3heFL8BaUtBHwPumdO9qCCroWM3gZhMKXS9vVxS7Jl1ZToCiGT6SlRpdpn+P
         R76p6Y+Ma6n3kI0E8+KqZvf4n7FpDYfNB2LBSgQNFrUSvgnit5ji9nQbGKDMDOpVDfiO
         EYVA/+8qoqQfiPWaKU3EsJlJrn0YOcI1Y7jV9iwP7KYB+U4d0z7s7Gsku7GHFpqfgu0r
         Nm2A==
X-Gm-Message-State: APjAAAXVv6hcBOXwgl6JoQUTimGNzsFX05RYxwyYikXX6PT86d0NQGS7
        8JAvgzFFrTYAECR2gT4+Ii8Sb1iZ
X-Google-Smtp-Source: APXvYqwJNzFB9Mh6kERUeAgKBjip8U/s1Q9P7Yt2cVpgcjXxE5McSZYrKmSzA3d6Jx0lKF5iUrEnew==
X-Received: by 2002:a17:902:87:: with SMTP id a7mr51747348pla.295.1552576235761;
        Thu, 14 Mar 2019 08:10:35 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:35 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/12] kernel-shark: Make KsSession::importFromFile return status flag
Date:   Thu, 14 Mar 2019 17:10:03 +0200
Message-Id: <20190314151012.905-4-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The function has a better handling of the case when the session
description file cannot be loaded. It returns true on success,
otherwise false. We need this return flag in order to provide
adequate error message in the case when this operation fails.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsSession.cpp | 14 ++++++++++----
 kernel-shark/src/KsSession.hpp |  2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel-shark/src/KsSession.cpp b/kernel-shark/src/KsSession.cpp
index 2242a12..b151818 100644
--- a/kernel-shark/src/KsSession.cpp
+++ b/kernel-shark/src/KsSession.cpp
@@ -28,13 +28,19 @@ KsSession::~KsSession()
 }
 
 /** Import a user session from a Json file. */
-void KsSession::importFromFile(QString jfileName)
+bool KsSession::importFromFile(QString jfileName)
 {
-	if (_config)
+	kshark_config_doc *configTmp =
+		kshark_open_config_file(jfileName.toStdString().c_str(),
+					"kshark.config.session");
+
+	if (configTmp) {
 		kshark_free_config_doc(_config);
+		_config = configTmp;
+		return true;
+	}
 
-	_config = kshark_open_config_file(jfileName.toStdString().c_str(),
-					  "kshark.config.session");
+	return false;
 }
 
 /** Export the current user session from a Json file. */
diff --git a/kernel-shark/src/KsSession.hpp b/kernel-shark/src/KsSession.hpp
index f5ed5a1..b07c810 100644
--- a/kernel-shark/src/KsSession.hpp
+++ b/kernel-shark/src/KsSession.hpp
@@ -37,7 +37,7 @@ public:
 	/** Get the configuration document object. */
 	kshark_config_doc *getConfDocPtr() const {return _config;}
 
-	void importFromFile(QString jfileName);
+	bool importFromFile(QString jfileName);
 
 	void exportToFile(QString jfileName);
 
-- 
2.19.1

