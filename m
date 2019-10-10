Return-Path: <SRS0=o8EP=YD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220B9C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E20A9214E0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q6YGcS+o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfJJVZD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:25:03 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:41503 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVZD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 17:25:03 -0400
Received: by mail-lj1-f179.google.com with SMTP id f5so7699801ljg.8
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2019 14:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f90xKkaJL4etj1oD+PDWDp1y3j25xrlkUDtHcZWiu50=;
        b=Q6YGcS+o1oUfNZQugT8nmhkYYjfcT+Raz0LISv2cVHsbfAL/8tLZfwyJ/ms8R8ngnX
         fFc4IFB4QJrwyOFCiOz0yfy3nsqFH9T9DsREdkFXWpAeVayOsokyrQgnsIHA6XRE7mpw
         MkhTF9uo9jYIZdCOvxfFbA/lc2EjIgUZwICChW9X1mZX7gC4sOpOG4hHvxN6Gw6AlrIN
         h0I/nq7PMNNtYn5vobQ8oZsoW5xtEc1kxQpQsqecPKdqkaiXe/jiueH5MM/6aG8vMzv6
         HBsFTWmjrQKE4ntroGwO7mUiOI1bj2PsPZ1ujH69pW/D4kKqRYcUFOmsOWFSxan4yMQ8
         1YsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f90xKkaJL4etj1oD+PDWDp1y3j25xrlkUDtHcZWiu50=;
        b=o8wqhXa0ZA3l3yUkxjqd83ULRmKTrdvtrYxMLbpcTHt9C++WWnsfg1/KEqRdg4xR0u
         eUFBWSWtvAZliYHpAUR2CrbJYuapQ8nsq5xowd4MmsTnLZ5j6c+9mJIbjui5i8Vbtnha
         kr+17zLU2cmktRLAKPShofi0S1stdz7K0CtjigyNwIS3j7r2gsR6QQeElWppx7s8UsJv
         0uNZLLs8yFnAKR9fAajicrKaj39D4sNF9irgLTpOp4DMcqSneuwzZHT3IsrW9vymIt1j
         wiAe3fXewDfUYRoQ1LVRc9cBeg1dtO6LUaOI7aH6zASVoC1XbRIn3qjPfcnOoqM8DXa2
         Fl0w==
X-Gm-Message-State: APjAAAV/GRj8z8ZPmFvxyZodad6kB9IWvsrmaHMhhxbGVTDjto9v/ms+
        aEjN93rFEDQ80RCpGZEJBVaRrzx++T4=
X-Google-Smtp-Source: APXvYqyMtC6YariCxSN1RZormnVexElY+W2u3UmUKdx2ZH8kHXp5ZxcRPBSqoa6GOf0F6zOs536i5Q==
X-Received: by 2002:a2e:82cd:: with SMTP id n13mr7507423ljh.156.1570742701283;
        Thu, 10 Oct 2019 14:25:01 -0700 (PDT)
Received: from localhost (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id 6sm1587053lfa.24.2019.10.10.14.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:25:00 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Subject: [PATCH 4/4] kernel-shark: Change KsDualMarker's inactive button style to default
Date:   Fri, 11 Oct 2019 00:24:29 +0300
Message-Id: <20191010212429.469155-5-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010212429.469155-1-mike.rudenko@gmail.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

At present, the style of an "inactive" KsDualMarker toolbar button is
set to "system default background + rgb(70,70,70) text color". As a
result, on dark qt color schemes (e.g. Breeze Dark) inactive button
looks disabled ("gray on gray").

This patch addresses the issue by changing "inactive" button style to
system default. This makes the UI intuitive across different color
schemes.

QStateMachine::setGlobalRestorePolicy is used for reducing the
boilerplate of manually resetting button style when it becomes
"inactive".

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 kernel-shark/src/KsDualMarker.cpp | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
index 0070777..90c5373 100644
--- a/kernel-shark/src/KsDualMarker.cpp
+++ b/kernel-shark/src/KsDualMarker.cpp
@@ -171,20 +171,12 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 				"styleSheet",
 				styleSheetA);

-	_stateA->assignProperty(&_buttonB,
-				"styleSheet",
-				"color : rgb(70, 70, 70)");
-
 	styleSheetB = "background : " +
 		      _markB._color.name() +
 		      "; color : white";

 	_stateB = new QState;
 	_stateB->setObjectName("B");
-	_stateB->assignProperty(&_buttonA,
-				"styleSheet",
-				"color : rgb(70, 70, 70)");
-
 	_stateB->assignProperty(&_buttonB,
 				"styleSheet",
 				styleSheetB);
@@ -223,6 +215,7 @@ KsDualMarkerSM::KsDualMarkerSM(QWidget *parent)
 	connect(&_buttonA,	&KsMarkerButton::deselect,
 		this,		&KsDualMarkerSM::deselectA);

+	_machine.setGlobalRestorePolicy(QState::RestoreProperties);
 	_machine.addState(_stateA);
 	_machine.addState(_stateB);
 	_machine.setInitialState(_stateA);
--
2.23.0
