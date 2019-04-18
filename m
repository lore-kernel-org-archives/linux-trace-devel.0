Return-Path: <SRS0=Pjg+=SU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E52C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8464220821
	for <linux-trace-devel@archiver.kernel.org>; Thu, 18 Apr 2019 15:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbfDRPWy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 18 Apr 2019 11:22:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33759 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388806AbfDRPWy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 18 Apr 2019 11:22:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id z6so7173672wmi.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 18 Apr 2019 08:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=218rISj39UVBKKglmwsvVZ22bsnn02SzEAgU9Z++Ucc=;
        b=c9duULaD2abmsr5YGN06Vq0iCZgrSqd25M5VnjI2Cv+R26P2ETxHfEbuGJ1c7QwBOX
         PiOY/PCWrUO5P6N4TLTJxHn03Zp/g/lLnWxrfj2AEVZu06JXDjmznI2mLKD3lhiZN7dU
         +o7ohPgInqwrf7qJcxWlHVvSz9sHRHJccvcr+H2LaPDPO8z0GxzzogL7AIUnqIB3Fjt3
         YQgzar8Dy1nNq49ZqcJPD2HeJvZ0e2Gkb8tJbMMMQ9DlzqGcL1JgaBWibfkXx/n0U/4o
         nd2slH6Im2u5V0CwAe/uLHzJXgFwCeJi+QK6DzYarb+q52Z7R9YnsekqJpvnVyTDrVE7
         el9Q==
X-Gm-Message-State: APjAAAXbJZHwRzCXyjVbg+OqxdakH1MCg5zw1zY3JBA+Mp24GURaN33r
        xK7hRTQOMWjTqQZf5L91iNQ=
X-Google-Smtp-Source: APXvYqzk9ZyINxyWGXcNJi1p0cKGQ1ju1A85rHf6VXDJ5kvIkWbAKXqTABs0GHpaxjtIC9QKF+mESQ==
X-Received: by 2002:a7b:c14c:: with SMTP id z12mr3547230wmi.138.1555600972696;
        Thu, 18 Apr 2019 08:22:52 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l12sm2543698wrt.31.2019.04.18.08.22.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 08:22:52 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 7/8] kernel-shark: Use proper searching condition when the dataset is small
Date:   Thu, 18 Apr 2019 18:21:45 +0300
Message-Id: <20190418152146.27232-8-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190418152146.27232-1-ykaradzhov@vmware.com>
References: <20190418152146.27232-1-ykaradzhov@vmware.com>
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
2.19.1

