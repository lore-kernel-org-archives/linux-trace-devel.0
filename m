Return-Path: <SRS0=h6jj=SV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D654C282DA
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:15:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CACEB222E9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 19 Apr 2019 18:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725280AbfDSSPm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 19 Apr 2019 14:15:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45531 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfDSSPj (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Apr 2019 14:15:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so7774611wra.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 19 Apr 2019 11:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xwR7bQog9GKuWlI9nXN+mzLfy78RsHPv56l1jmn9Kbg=;
        b=KqlFTdwtI1LoNON3Jro/QP8pj3baGUYMCJeRq9HeIeTUunyVp8smWeEINhLhjqC+nU
         iLyxC/qNZidT/1gm1YwkBBsOg59jcsfq4jVy9MddSmC5bHAtdFsN8son5SDh4wkzbPRk
         4Lk4vDoTvSsvW9UgBnSacZTdrCIvYs/omnetXcnhqetc3LS3NA4/BT4TIkfyp4Y1FUWF
         DF0K+WIz3+sI1QcFCgC2XjTo3Xfk9KWNoHbhbNsCitLoHfNwqkL9gHsF7tE1cHnlO8CZ
         RV5ywmWFbQresWMDxx1FyyG9Zvu9xFZPRJoh9G//S+348D+NSSclig4z7H23TENuR6K2
         Mq7Q==
X-Gm-Message-State: APjAAAUPTugLk3Ufp5ZHMF8DIrwM40WAc5vBmNAgMCcfJgwGShqPQdgn
        Nrk1AvGs7dEb2QINFC4+WAuXKd6J
X-Google-Smtp-Source: APXvYqxvWiWzi6FCOXoZaaqKuw+z4h3Ng6I53UDD0XhN5usXzoe5DKlfvS8+mkrqi28y6c5Hfa6lkw==
X-Received: by 2002:adf:f88c:: with SMTP id u12mr3245088wrp.235.1555681864429;
        Fri, 19 Apr 2019 06:51:04 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id g132sm4120496wme.3.2019.04.19.06.51.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Apr 2019 06:51:04 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Slavomir Kaslev <kaslevs@vmware.com>
Subject: [PATCH v3 7/8] kernel-shark: Use proper searching condition when the dataset is small
Date:   Fri, 19 Apr 2019 16:50:35 +0300
Message-Id: <20190419135036.19340-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190419135036.19340-1-ykaradzhov@vmware.com>
References: <20190419135036.19340-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

If the data-set is small we do not want to have the overhead added by
the update of the progress bar. Because of this we bypass the state
switching of the FSM. However, in this case the the search condition
has to be updated by hand.

Reported-by: Slavomir Kaslev <kaslevs@vmware.com>
Fixes: 1615b02b (kernel-shark-qt: Optimize the search in a case of a small data-set)
Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 4e2c93e..04a38b8 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -596,8 +596,11 @@ size_t KsTraceViewer::_searchItems()
 	if (_proxyModel.rowCount({}) < KS_SEARCH_SHOW_PROGRESS_MIN) {
 		/*
 		 * This is a small data-set. Do a single-threaded search
-		 * without showing the progress.
+		 * without showing the progress. We will bypass the state
+		 * switching, hence the search condition has to be updated
+		 * by hand.
 		 */
+		_searchFSM.updateCondition();
 		_proxyModel.search(column, searchText, _searchFSM.condition(), &_matchList,
 				   nullptr, nullptr);
 	} else {
-- 
2.20.1

