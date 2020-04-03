Return-Path: <SRS0=6Q4x=5T=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5936CC43331
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 16:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3035C2073B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Apr 2020 16:02:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMX6McIx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390756AbgDCQCs (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 12:02:48 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:34615 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390751AbgDCQCr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 12:02:47 -0400
Received: by mail-lj1-f194.google.com with SMTP id p10so7522009ljn.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 03 Apr 2020 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vah6znR3VQmy1jHG4xxhivXAN9nj3PDq5eosffFK3tY=;
        b=NMX6McIx1NtndzzR9cS3Qw6i70/FH6TBQ/D5oMFpfhqI//yehkMKnI9tnN2uF4t8OG
         1qyVLupWZBNz8YTvPfy+W4Z7ZPVqcRRs2esW7rvNZArnyz7b8bpDJkS+Ym9L/iAe/LKq
         a6vKy0Tr9FxO+J125WZu2eWCtkDCXSxaLTeYgCGYCtgUiDmit+ktrYEuSMKjdBP1u1sJ
         efXGaqKK37k7BRs1oHV3jrlH3VmwHZQDv4Nmu62gYD30/PCxp39RVjy4wXGgZhfAQsFq
         6S4qj3TddSekgrOCQm7Yoj6cCUTtE2VlkzUcTP6QQ5VJ0zrm+onOBbWq5pC4wx/5jL9m
         QFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vah6znR3VQmy1jHG4xxhivXAN9nj3PDq5eosffFK3tY=;
        b=AndsitbNx2e5OyIr9au5boAO0OESzvLe7VtZDjii1YGR4jn1HsLl8ISGeJlJsOrMR0
         zbrCnp/zP/YBhDa35BUTyGu3klHXhfd0coqjR/Uj/y6F/kE8HsA1Pg0jvjWhAv/VOf5I
         sAb4TtLHvRMD/9RBwIwN3jsbl5+A/Ht1cBTRvqgH20o0aMOob1uVanO4YmHYEDmIdp5r
         Ps2OFRhg78rqQowxp65bcoDoVXa851YC3rMbXuK6t7XA8CEnybd5sDP27CHD0vWC0Sen
         6AfS7Z1NO8+9WgzvSP3Om/0ajsQsQ5u6S3wc8eXMF9KpnE8DOK7HMcqu5AhtT+GjM52B
         gkKQ==
X-Gm-Message-State: AGi0PuaeUFNmxN/CD2zCSdA772Ssju4f0vyhTO04p4AF2p09ASPwR7OK
        uK0XmxK6OK71QTyhXUDzWpZn7epn
X-Google-Smtp-Source: APiQypK8bMuoy9JCHQ11He0ILiJnsNYSjLR+g9uaU+5iYlZzYHTblFeZSRVutAJiKRAh8EAdz6ashQ==
X-Received: by 2002:a2e:6e0f:: with SMTP id j15mr4928530ljc.230.1585929765319;
        Fri, 03 Apr 2020 09:02:45 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.10])
        by smtp.gmail.com with ESMTPSA id b16sm6252747lfq.34.2020.04.03.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 09:02:44 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] kernel-shark-2.alpha: Show the file name in the time offset dialog
Date:   Fri,  3 Apr 2020 19:02:30 +0300
Message-Id: <20200403160230.11185-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200403160230.11185-1-y.karadz@gmail.com>
References: <20200403160230.11185-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is useful when appending multiple files from the command line.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsMainWindow.cpp | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/KsMainWindow.cpp b/src/KsMainWindow.cpp
index af8afb3..80a6537 100644
--- a/src/KsMainWindow.cpp
+++ b/src/KsMainWindow.cpp
@@ -1255,8 +1255,10 @@ void KsMainWindow::_load(const QString& fileName, bool append)
 
 	if (append) {
 		bool ok;
+		QString description = fileName + "\n\nOffset [usec]:";
+
 		shift = QInputDialog::getDouble(this, tr("Append Trace file"),
-						      tr("Offset [usec]:"), 0,
+						      description, 0,
 						      INT_MIN, INT_MAX, 1, &ok);
 		if (ok)
 			shift *= 1000.;
-- 
2.20.1

