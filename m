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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB26C4360C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA6CA206B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iwd4JqLw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfJJVZB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:25:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39118 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVZB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 17:25:01 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so7699751ljj.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2019 14:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIdqMlrZyLl4YR13KZU/L3Tp7uwHPIXvCOdR8E72pqo=;
        b=Iwd4JqLwYHfdYRzZ4UG79uX+CHV3QW2KsNTWs1iVIsHBf+3Gr3i3TyQti9wZD0+bHF
         l0zKJXTx+G/tN/WlcA2EMxhxOf/zCh3rz9oUy4goAzp6AxnpzOQa10Vhx6xi+5arh7B8
         rMFUe5kOSq1OqxMcli+aLF5sb3fenTB2/+cmWuLD0zh3S5kbYgXeaYQ15w1jIHQJ1K9Y
         PCXBXAtntngNtiMJSQ7Gs3WXPLEv0n7Ox3L0EPaPJGP1lipmSw1AXg79p0fxi2f2f8Cg
         fJtbNzDgQlCzYDKh4EzCg8EyaWbk+yLreCAuPB4VNC+4/r4hn/EEzx3uoy8emPEV3RKS
         KCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIdqMlrZyLl4YR13KZU/L3Tp7uwHPIXvCOdR8E72pqo=;
        b=hPLM6t6+qZ+vB2dIwskViU6vSsUO+FZxm55Gbf8eY8sQqt9eevyeVPXVmTmX+f6V0u
         sTpv4B2N2OWZwPwMtCg+eR/n6QvU9QKnMCTnY5E1pybGvDeycWp2csMSfJvFskpgkudO
         JZnmb5kdKWo+ws5dGdlyjyqCkWpVHOyFB1nYio3YWwGrilmxlL2ns7o4BNldLEXIO1I4
         BZO7/yAnOL8+HVqclAAk7Kr6Q2i5X/6ncQalzXlGtMQO221rR1ny09LbL5u5pRuviiy9
         lAwGaUmcBv1/KJjsTc8P7zBiTNv3R3qRg0bt9Lg8b7/9FaSAPhQ2Z6kV6+V43xEXueFS
         CK/Q==
X-Gm-Message-State: APjAAAVdjnp3cJFehOL/PLRK3kU5X/1lwdpMMZZQFR7t/sP9OPjtac42
        XIXjuTQU48l1o9Ahz7nDmvbv4KATX5E=
X-Google-Smtp-Source: APXvYqy9a2tAuBYRzf32SBQvp5bekkvVBUIYEz8qMh4U7c8nB1oGKkHje6BfH3v879QqaAmYKh+W3w==
X-Received: by 2002:a2e:2901:: with SMTP id u1mr7521804lje.78.1570742699325;
        Thu, 10 Oct 2019 14:24:59 -0700 (PDT)
Received: from localhost (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id g10sm1576074lfb.76.2019.10.10.14.24.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:24:58 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Subject: [PATCH 3/4] kernel-shark: Set text color to black in KsTraceGraph's axes labels
Date:   Fri, 11 Oct 2019 00:24:28 +0300
Message-Id: <20191010212429.469155-4-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010212429.469155-1-mike.rudenko@gmail.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

At present, background color of axes labels of the plot is forced to
white with a stylesheet, but the text color stays unchanged. As a
result, text is barely visible when using dark color schemes. This
patch forces the text color to black for these labels, making them
readable on all color schemes.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 kernel-shark/src/KsTraceGraph.cpp | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 73e7577..90f83f3 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -96,6 +96,8 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)
 	_legendAxisX.layout()->addWidget(&_labelXMin);
 	_legendAxisX.layout()->addWidget(&_labelXMid);
 	_legendAxisX.layout()->addWidget(&_labelXMax);
+	_legendAxisX.setStyleSheet("QLabel { background-color : white; color: black}");
+
 	_drawWindow.setMinimumSize(100, 100);
 	_drawWindow.setStyleSheet("QWidget {background-color : white;}");

@@ -580,7 +582,7 @@ void KsTraceGraph::_updateGraphLegends()
 			width = STRING_WIDTH(graphName);

 		name->setAlignment(Qt::AlignBottom);
-		name->setStyleSheet("QLabel {background-color : white;}");
+		name->setStyleSheet("QLabel {background-color : white; color : black}");
 		name->setFixedHeight(KS_GRAPH_HEIGHT);
 		layout->addWidget(name);
 	};
--
2.23.0
