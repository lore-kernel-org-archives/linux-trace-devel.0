Return-Path: <SRS0=47nt=6S=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4175C4724C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4584206A4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 May 2020 17:44:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pdtjXBE3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgEDRoD (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 May 2020 13:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgEDRoD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 May 2020 13:44:03 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D836AC061A0E
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 May 2020 10:44:02 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id w20so10615320ljj.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 May 2020 10:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5U7V11sF6B4edbELusw9zRX3HMyHnqKm/W8MFjoIFAo=;
        b=pdtjXBE3J3RCWyuUZzPDm0KVywuOGTrKuX4DkPbrC6ndZcQ53QbI23lhx+Mr3YEirR
         9FHOfF/HCrwIkg8+Dwkh62zNtlQaCmIfDNurEfUAK0zrmEfitK/GuLveIlO4BH0J/JZ9
         x9TbSWuYrT0i4Nu2VwqA75AyguCJrlVFOjE5fmI2YBd75GsEnyHqyAYTutTB9EgRYnKG
         PQaxDjumpTfZIdm+Tr7XG7cr2z8VwrtxVKatfbepQGMoG5Wj38Qsl/v2fvFfNfuQgFie
         gVVHWQGi/3E6dENgDSgZ/jJhOiIl8FH9amgLg5ovElIs+0Wxg7Iw9V46igo5k3pOddLg
         9gjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5U7V11sF6B4edbELusw9zRX3HMyHnqKm/W8MFjoIFAo=;
        b=BZM6WZusJR86XJ6kFNipwJ2Av/N/5Q5VHwJnwkVDaB1PY3vdVskiDTHJZMQBc/9oCz
         VbQoN2rqMfFdu1i2nAAfTXm4XrHCej4DbANwcNVCX8H6QTM4QtF8tsfJUOOs8mV5yMAW
         /Z6XKOkLDdLEiF2jnwSk7rgr+iSHyb3sHWDTTQ9Wd5627boFJAzcOppEUZlf/pC8qjtc
         7G82hyXInBiy8qHtybTawHN4sIGUrMVJNJeo7Eyny3x40zIkFOtBPYTykyONHbojmNUP
         Zlqrs0i/94jageZHS/R4MjJktnUGmzAzoRAKxFcZK+/eMDOETP/quvMfoUztJfRW10RT
         wi6g==
X-Gm-Message-State: AGi0PuYEiJ67E2RtKj4oewArG7H4jrBr4k7CNLljTQVUgpMKi7xjlUN0
        +1kH6JUS9V0MUAi7yKgiKc0=
X-Google-Smtp-Source: APiQypKkVz0Hfrz64Jn0ARktbWVo302UCnidDR8NjTIqfNBb2Yi+LY2jcJw+R32t5rg045YYU2uCjQ==
X-Received: by 2002:a2e:d1a:: with SMTP id 26mr11270940ljn.160.1588614241307;
        Mon, 04 May 2020 10:44:01 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.119])
        by smtp.gmail.com with ESMTPSA id g10sm10260845lfc.95.2020.05.04.10.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 10:44:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 1/3] kernel-shark: Simplify the search methods in class KsTraceViewer
Date:   Mon,  4 May 2020 20:43:40 +0300
Message-Id: <20200504174342.24615-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504174342.24615-1-y.karadz@gmail.com>
References: <20200504174342.24615-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch defines two identical private methods for single-threaded
and multi-threaded search inside the data table. This is done as a
preparation for the following patch that will change the mechanism
of the multi-threaded search.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsTraceViewer.cpp | 12 ++++++------
 kernel-shark/src/KsTraceViewer.hpp |  5 +++--
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index c176cef..0694532 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -621,9 +621,9 @@ size_t KsTraceViewer::_searchItems()
 
 		if (column == KsViewModel::TRACE_VIEW_COL_INFO ||
 		    column == KsViewModel::TRACE_VIEW_COL_LAT)
-			_proxyModel.search(&_searchFSM, &_matchList);
+			_searchItemsST();
 		else
-			_searchItemsMapReduce(column, searchText, _searchFSM.condition());
+			_searchItemsMT();
 	}
 
 	count = _matchList.count();
@@ -673,9 +673,7 @@ void KsTraceViewer::_setSearchIterator(int row)
 	}
 }
 
-void KsTraceViewer::_searchItemsMapReduce(int column,
-					  const QString &searchText,
-					  search_condition_func cond)
+void KsTraceViewer::_searchItemsMT()
 {
 	int nThreads = std::thread::hardware_concurrency();
 	std::vector<QPair<int, int>> ranges(nThreads);
@@ -685,7 +683,9 @@ void KsTraceViewer::_searchItemsMapReduce(int column,
 
 	auto lamSearchMap = [&] (const QPair<int, int> &range,
 				 bool notify) {
-		return _proxyModel.searchMap(column, searchText, cond,
+		return _proxyModel.searchMap(_searchFSM._columnComboBox.currentIndex(),
+					     _searchFSM._searchLineEdit.text(),
+					     _searchFSM.condition(),
 					     range.first, range.second,
 					     notify);
 	};
diff --git a/kernel-shark/src/KsTraceViewer.hpp b/kernel-shark/src/KsTraceViewer.hpp
index cf529ba..6080d0d 100644
--- a/kernel-shark/src/KsTraceViewer.hpp
+++ b/kernel-shark/src/KsTraceViewer.hpp
@@ -132,8 +132,9 @@ private:
 
 	size_t _searchItems();
 
-	void _searchItemsMapReduce(int column, const QString &searchText,
-				   search_condition_func cond);
+	void _searchItemsST() {_proxyModel.search(&_searchFSM, &_matchList);}
+
+	void _searchItemsMT();
 
 	void _searchEditText(const QString &);
 
-- 
2.20.1

