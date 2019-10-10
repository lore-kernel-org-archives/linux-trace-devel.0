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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C87C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E40CA206B6
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Oct 2019 21:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlatgFIy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfJJVY7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:24:59 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40391 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfJJVY7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 17:24:59 -0400
Received: by mail-lj1-f193.google.com with SMTP id 7so7693203ljw.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2019 14:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MI6RHmowPacvt03t8QqxKg+M8iDlREm88RIKrUuquZA=;
        b=UlatgFIyGW+buAl1N97s7g9IF2QQinqVCvPqXLD+f4hIlmanT/pUjZG152Y5S/9wXp
         TQLCQtBrjWNzF/yrxy4rw9KCsR+77LIgVIRlhVfZlJUJNSP0E01Rr30ReDkEbgLoXmCn
         ndN8Kj60QA6JL2XMLtDc7CJfgrD+oXrxcA9aj0PmUG4z6htC/E8MAXoNnCp6rFZoeu3G
         C8iYbTueFmyX+r6CkM50ExwqlAv7EsUtR39ALBpb6HLkvcomRUDhVnetiJ+PzOG3SDMf
         LLiK58DyutaGKubMbWYx0X1SxdzffS9fMtjcI/ujjY8mXvA2nA5uVZWwz2Kv6kHoKcyv
         5ETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MI6RHmowPacvt03t8QqxKg+M8iDlREm88RIKrUuquZA=;
        b=l5EUZMueC+7DxPsJnjHohpjwy8WJQ/NpAXEtGnYEJMUD7uipDg8DJ+YvluX1DCkYDJ
         K/Dd0iLXq2Bp0sf+nWrshLd/PFaueT22Z2l8KIxaX7ufD0Ln0ePY5c3WSE68JZ7bwHVB
         95LcVOrTQK03JMXQn5VXWBevg/xGF/ai5TGUYtWrigugKBI8VMhjFGUbyS2NuqeTthfn
         2uiJ37fI4QfXFmI6tgddqIn4wP+PWpyM6GQsv78ECE2ypsfdiOOZQMuAAwMpjfuh4a2a
         OmwkAogtQkNNh+mqzshQHp7J9dwxaGbxvdFdDSeYSx9W5LYCGG6ox6b4ouviW9QoAJC/
         R6xw==
X-Gm-Message-State: APjAAAXz+AOeUJre5BTaXsqawPhiKVTCc8aFwNIjDONnkI13XJFK4ClT
        aRP5OPsIw5FXF+KN1qLtZYLSS7ECqkE=
X-Google-Smtp-Source: APXvYqwj5KxtfKviUiU+bR6EBp5t/zK7maxoTzKnp1DW6xdezjIfhtzUp7mqie+owIM7Cykhc6pJqw==
X-Received: by 2002:a2e:88d0:: with SMTP id a16mr7514040ljk.39.1570742697683;
        Thu, 10 Oct 2019 14:24:57 -0700 (PDT)
Received: from localhost (128-72-185-159.broadband.corbina.ru. [128.72.185.159])
        by smtp.gmail.com with ESMTPSA id t22sm1588037lfg.91.2019.10.10.14.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 14:24:57 -0700 (PDT)
From:   Mikhail Rudenko <mike.rudenko@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <srostedt@redhat.com>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Mikhail Rudenko <mike.rudenko@gmail.com>
Subject: [PATCH 2/4] kernel-shark: Set text color to black in pointer position QLabel
Date:   Fri, 11 Oct 2019 00:24:27 +0300
Message-Id: <20191010212429.469155-3-mike.rudenko@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010212429.469155-1-mike.rudenko@gmail.com>
References: <20191010212429.469155-1-mike.rudenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

At present, the background color of the pointer position QLabel is
forced to white with a stylesheet, but the text color stays
unchanged. As a result, the text is barely visible when using dark
color schemes. This patch forces the text color to black for this
QLabel, making it readable on all color schemes.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
---
 kernel-shark/src/KsTraceGraph.cpp | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 2e48372..73e7577 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -62,7 +62,7 @@ KsTraceGraph::KsTraceGraph(QWidget *parent)

 	_pointerBar.addWidget(&_labelP1);
 	_labelP2.setFrameStyle(QFrame::Panel | QFrame::Sunken);
-	_labelP2.setStyleSheet("QLabel { background-color : white;}");
+	_labelP2.setStyleSheet("QLabel { background-color : white; color: black}");
 	_labelP2.setTextInteractionFlags(Qt::TextSelectableByMouse);
 	_labelP2.setFixedWidth(FONT_WIDTH * 16);
 	_pointerBar.addWidget(&_labelP2);
--
2.23.0
