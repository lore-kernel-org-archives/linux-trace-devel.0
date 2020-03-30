Return-Path: <SRS0=swVm=5P=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67A5C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88612206CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzxfA66M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729004AbgC3QSE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:18:04 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43606 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QSE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:18:04 -0400
Received: by mail-lf1-f67.google.com with SMTP id n20so14664557lfl.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5U7V11sF6B4edbELusw9zRX3HMyHnqKm/W8MFjoIFAo=;
        b=lzxfA66Mw3uLIXj8tPpEKVy0HFHHc25Fo24EI92ldXKRrCfgI4IoNpigQ/g0b0AQOR
         sEni9U3YYGxrdEVpBnCF9Dm4wdKbyxUArzWI0sPWU7TudI2x1ErZDE2L2nY48xbrW9i2
         GAi2TcMXuH5TZKhQnw+Y1Hv/1ciAbbLWpeoZJ35yN+XT+bAIkP6mDyuAqqEbt6AcItFs
         UDrv9Op2SE3aw9uMvMLuL6gWSbZ2PEw7f0+lPTqIxwNN50ZYm7yls9nY2zzs38mZrGf7
         3qo1qd6FfdEroDivraYwJBkMtq1MRyBzyfqVxu3OnCzWLFvu+8NW6ZXxaPAmYS6oTIBq
         cYvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5U7V11sF6B4edbELusw9zRX3HMyHnqKm/W8MFjoIFAo=;
        b=blhNkWO/V0TaMY3mrE0OsYYVU3pVeS9xm+86OC78TYEDAFQ0leNysqt6y2xFnk+n4g
         4lq5Byr3QusExy5L45t66Hkei6jaUUarB2cR5HISyvvP55+YB+oWo6Z65zzwB67ukEtt
         B+qv8QMC7hL2sJKr+oQYC8PEMCoQE2+JYnv5Rq6uXdGTH58I2sv5XK6L4YZqmzgXOtbD
         0zL5aguZRqB8cExykHiY7DfdCnmhJKokC87JFKE8/8/m8tjDl/To9+HXd4RTpabhQLgx
         ErYXBJ02+ZA0wBFYHjKDY8DClQLeQ5qMBuaNg2HzZv+BCH8qx9eDlg3PlrJwc7Ns2iHl
         zCOw==
X-Gm-Message-State: AGi0PuY8wbbFrrBEOWoHu+cERVM8eBYqLWz/2hdykXt7fy/79ILLdfE9
        ZrFeLdFZaq3Kp5mX2I3U0A4=
X-Google-Smtp-Source: APiQypIaaCptitQEcdW+Paq2l85zUngxlj+n+jsghzMlPXjSBswCagO91cZYguXAhyQmgyhSIvNvdw==
X-Received: by 2002:a19:c781:: with SMTP id x123mr8389082lff.140.1585585081158;
        Mon, 30 Mar 2020 09:18:01 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id u7sm447957lfb.84.2020.03.30.09.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:18:00 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/3] kernel-shark: Simplify the search methods in class KsTraceViewer
Date:   Mon, 30 Mar 2020 19:17:21 +0300
Message-Id: <20200330161723.29816-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330161723.29816-1-y.karadz@gmail.com>
References: <20200330161723.29816-1-y.karadz@gmail.com>
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

