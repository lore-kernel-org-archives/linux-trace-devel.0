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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95649C43331
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5263F206CC
	for <linux-trace-devel@archiver.kernel.org>; Mon, 30 Mar 2020 16:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBHLAr+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgC3QSJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 12:18:09 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35480 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgC3QSI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 12:18:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id t16so13854081lfl.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 30 Mar 2020 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qNV5IddyYDeSGRfrW+oMYBgQYMam/okoJ0Mgvsz/dmA=;
        b=ZBHLAr+V73Wap5KWaap+kmWPx8rPEBrPaM7JRaSvgoIvqm3ciUNUPV8xah//NsC7kI
         dDQxeuKiGMV4qw9/rrpkrdxYimaF4lIHfowy/DBjG24EdS3G6QdVY67R/HyDDbkpoUD0
         +2OcL9nMFFcaH46gYv7v4ZzOKdseNsRmZ7R+6qHevsU3MTTsuGj72lHsyH+qQZJus7o+
         jBdfMmQ/V3j9gxCcNzJXyzBYGmkkBus7BLbPNuonCUsQ/lcSBem0Dpv4tFYbBRzzmmpy
         VWBrU37+q6xwvMtezw4euVr1wooZl9iOLtoChUmHwb9ONDENVGHO43L2oINg3czVOIIp
         oatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qNV5IddyYDeSGRfrW+oMYBgQYMam/okoJ0Mgvsz/dmA=;
        b=saghWOz8bTu3iNaQ8fYYREulXxHkOEmXeFq+PG36xKmVkp+LtEKIJYPLgfbtcCAUW7
         IRLtHNHPJR5f7XhQhF32U69KQZMpf+tgKaLBTrbaKLlcq1QmmYshDPA/FRWVk+jW2Tb3
         wYMgZEXAjUpeyjIE5+rBHvEY7A+WpPNZBWTPQrDtK3mFBPXvg9oTFejHfi0XsjFGMnEh
         4cg99QyMUGx7hic9j0stSj56NmJ5KvX+ORkVmAUh5UiAbd+hqSdmBsmU1EvPO9lGensD
         mS8ZfBJMy7c/D5r83V5ZwiCclSzO7PoZ90GDPNXe6yDwKI7MEsJ75ipJxqSpg7TRF+DZ
         f+3g==
X-Gm-Message-State: AGi0PubPiuFM9R4MpLBcz4GXlt5t6WCzaABufHQ84FjLJzXKSxscdHzr
        7sMmvwDUE6mTocEC9Rl8kJ4=
X-Google-Smtp-Source: APiQypI0ij9xlhrnv3wAnfyA/pjVnOYbiH2LDbcGkOKOY8TFPNgdPR/NBKng1DOkHhia2xikxrHw9A==
X-Received: by 2002:a19:84c7:: with SMTP id g190mr8654046lfd.204.1585585083687;
        Mon, 30 Mar 2020 09:18:03 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.182])
        by smtp.gmail.com with ESMTPSA id u7sm447957lfb.84.2020.03.30.09.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 09:18:03 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] kernel-shark: Change the mechanism of the multi-threaded search
Date:   Mon, 30 Mar 2020 19:17:22 +0300
Message-Id: <20200330161723.29816-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200330161723.29816-1-y.karadz@gmail.com>
References: <20200330161723.29816-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We switch from classical Map-Reduce approach in which the data is
divided in sub-sets and each thread searches into its own sub-set
to a solution in which all thread are progressing in the data in
parallel. Note that the Map-Reduce solution is more efficient
because at the end when we merge the searching results we simply
have to append the outputs of the threads, while in the case of
a parallel search we hare to also sort the merged outputs of the
threads. However, the parallel search allows the user to stop and
later restart the search at any time. The GUI buttons, needed to
stop and restart the multi-threaded search will be enabled in the
following patch.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 kernel-shark/src/KsModels.cpp      |  89 +++++++++++++------
 kernel-shark/src/KsModels.hpp      |  16 ++--
 kernel-shark/src/KsSearchFSM.hpp   |   5 +-
 kernel-shark/src/KsTraceViewer.cpp | 135 +++++++++++++++++++++++------
 4 files changed, 183 insertions(+), 62 deletions(-)

diff --git a/kernel-shark/src/KsModels.cpp b/kernel-shark/src/KsModels.cpp
index b89fee8..ac58ca0 100644
--- a/kernel-shark/src/KsModels.cpp
+++ b/kernel-shark/src/KsModels.cpp
@@ -52,22 +52,25 @@ size_t KsFilterProxyModel::_search(int column,
 				   const QString &searchText,
 				   search_condition_func cond,
 				   QList<int> *matchList,
+				   int step,
 				   int first, int last,
 				   QProgressBar *pb,
 				   QLabel *l,
+				   int *lastRowSearched,
 				   bool notify)
 {
 	int index, row, nRows(last - first + 1);
-	int pbCount(1);
+	int milestone(1), pbCount(1);
 	QString item;
 
 	if (nRows > KS_PROGRESS_BAR_MAX)
-		pbCount = nRows / (KS_PROGRESS_BAR_MAX - _searchProgress);
+		milestone = pbCount = nRows / (KS_PROGRESS_BAR_MAX - step -
+					       _searchProgress);
 	else
 		_searchProgress = KS_PROGRESS_BAR_MAX - nRows;
 
 	/* Loop over the items of the proxy model. */
-	for (index = first; index <= last; ++index) {
+	for (index = first; index <= last; index += step) {
 		/*
 		 * Use the index of the proxy model to retrieve the value
 		 * of the row number in the base model.
@@ -78,17 +81,23 @@ size_t KsFilterProxyModel::_search(int column,
 			matchList->append(row);
 
 		if (_searchStop) {
-			if (notify) {
-				_searchProgress = KS_PROGRESS_BAR_MAX;
+			if (lastRowSearched)
+				*lastRowSearched = index;
+
+			if (notify)
 				_pbCond.notify_one();
-			}
 
 			break;
 		}
 
 		/* Deal with the Progress bar of the seatch. */
-		if ((index - first) % pbCount == 0) {
+		if ((index - first) > milestone) {
+			milestone += pbCount;
 			if (notify) {
+				/*
+				 * This is a multi-threaded search. Notify
+				 * the main thread to update the progress bar.
+				 */
 				std::lock_guard<std::mutex> lk(_mutex);
 				++_searchProgress;
 				_pbCond.notify_one();
@@ -100,6 +109,7 @@ size_t KsFilterProxyModel::_search(int column,
 
 				if (l)
 					l->setText(QString(" %1").arg(matchList->count()));
+
 				QApplication::processEvents();
 			}
 		}
@@ -130,8 +140,17 @@ size_t KsFilterProxyModel::search(int column,
 				  QLabel *l)
 {
 	int nRows = rowCount({});
-	_search(column, searchText, cond, matchList,
-		0, nRows - 1, pb, l, false);
+	_search(column,
+		searchText,
+		cond,
+		matchList,
+		1,		// step
+		0,		// first
+		nRows - 1,	// last
+		pb,
+		l,
+		nullptr,
+		false);
 
 	return matchList->count();
 }
@@ -148,16 +167,17 @@ size_t KsFilterProxyModel::search(KsSearchFSM *sm, QList<int> *matchList)
 {
 	int nRows = rowCount({});
 
-	sm->_lastRowSearched =
-		_search(sm->column(),
-			sm->searchText(),
-			sm->condition(),
-			matchList,
-			sm->_lastRowSearched + 1,
-			nRows - 1,
-			&sm->_searchProgBar,
-			&sm->_searchCountLabel,
-			false);
+	_search(sm->column(),
+		sm->searchText(),
+		sm->condition(),
+		matchList,
+		1,				// step
+		sm->_lastRowSearched + 1,	// first
+		nRows - 1,			// last
+		&sm->_searchProgBar,
+		&sm->_searchCountLabel,
+		&sm->_lastRowSearched,
+		false);
 
 	return matchList->count();
 }
@@ -168,26 +188,41 @@ size_t KsFilterProxyModel::search(KsSearchFSM *sm, QList<int> *matchList)
  * @param column: The number of the column to search in.
  * @param searchText: The text to search for.
  * @param cond: Matching condition function.
+ * @param step: The step used by the thread of the search when looping over
+ *		the data.
  * @param first: Row index specifying the position inside the table from
  *		 where the search starts.
  * @param last:  Row index specifying the position inside the table from
  *		 where the search ends.
+ * @param lastRowSearched: Output location for parameter showing the index of
+ *			   the last searched item (data row).
  * @param notify: Input location for flag specifying if the search has to
  *		  notify the main thread when to update the progress bar.
  *
  * @returns A list containing the row indexes of the cells satisfying matching
  *	    condition.
  */
-QList<int> KsFilterProxyModel::searchMap(int column,
-					 const QString &searchText,
-					 search_condition_func cond,
-					 int first,
-					 int last,
-					 bool notify)
+QList<int> KsFilterProxyModel::searchThread(int column,
+					    const QString &searchText,
+					    search_condition_func cond,
+					    int step,
+					    int first,
+					    int last,
+					    int *lastRowSearched,
+					    bool notify)
 {
 	QList<int> matchList;
-	_search(column, searchText, cond, &matchList, first, last,
-		nullptr, nullptr, notify);
+	_search(column,
+		searchText,
+		cond,
+		&matchList,
+		step,
+		first,
+		last,
+		nullptr,
+		nullptr,
+		lastRowSearched,
+		notify);
 
 	return matchList;
 }
diff --git a/kernel-shark/src/KsModels.hpp b/kernel-shark/src/KsModels.hpp
index 3faaf4a..d360ad6 100644
--- a/kernel-shark/src/KsModels.hpp
+++ b/kernel-shark/src/KsModels.hpp
@@ -170,12 +170,14 @@ public:
 
 	size_t search(KsSearchFSM *sm, QList<int> *matchList);
 
-	QList<int> searchMap(int column,
-			     const QString  &searchText,
-			     search_condition_func  cond,
-			     int first,
-			     int last,
-			     bool notify);
+	QList<int> searchThread(int column,
+				const QString &searchText,
+				search_condition_func cond,
+				int step,
+				int first,
+				int last,
+				int *lastRowSearched,
+				bool notify);
 
 	/** Get the progress of the search. */
 	int searchProgress() const {return _searchProgress;}
@@ -223,9 +225,11 @@ private:
 		       const QString &searchText,
 		       search_condition_func cond,
 		       QList<int> *matchList,
+		       int step,
 		       int first, int last,
 		       QProgressBar *pb,
 		       QLabel *l,
+		       int *lastRowSearched,
 		       bool notify);
 };
 
diff --git a/kernel-shark/src/KsSearchFSM.hpp b/kernel-shark/src/KsSearchFSM.hpp
index 2089912..6a01d61 100644
--- a/kernel-shark/src/KsSearchFSM.hpp
+++ b/kernel-shark/src/KsSearchFSM.hpp
@@ -168,9 +168,10 @@ public:
 
 	/**
 	 * Last row, tested for matching. To be used when restarting the
-	 * search.
+	 * search. Note that the field uses "int" as a type because this
+	 * is the type supported by the Qt widget (QTableView).
 	 */
-	ssize_t		_lastRowSearched;
+	int		_lastRowSearched;
 
 //! @cond Doxygen_Suppress
 
diff --git a/kernel-shark/src/KsTraceViewer.cpp b/kernel-shark/src/KsTraceViewer.cpp
index 0694532..12371ad 100644
--- a/kernel-shark/src/KsTraceViewer.cpp
+++ b/kernel-shark/src/KsTraceViewer.cpp
@@ -12,6 +12,7 @@
 // C++11
 #include <thread>
 #include <future>
+#include <queue>
 
 // KernelShark
 #include "KsQuickContextMenu.hpp"
@@ -676,49 +677,129 @@ void KsTraceViewer::_setSearchIterator(int row)
 void KsTraceViewer::_searchItemsMT()
 {
 	int nThreads = std::thread::hardware_concurrency();
+	int startFrom, nRows(_proxyModel.rowCount({}));
 	std::vector<QPair<int, int>> ranges(nThreads);
 	std::vector<std::future<QList<int>>> maps;
-	int i(0), nRows(_proxyModel.rowCount({}));
-	int delta(nRows / nThreads);
-
-	auto lamSearchMap = [&] (const QPair<int, int> &range,
-				 bool notify) {
-		return _proxyModel.searchMap(_searchFSM._columnComboBox.currentIndex(),
-					     _searchFSM._searchLineEdit.text(),
-					     _searchFSM.condition(),
-					     range.first, range.second,
-					     notify);
+	std::mutex lrs_mtx;
+
+	auto lamLRSUpdate = [&] (int lastRowSearched) {
+		std::lock_guard<std::mutex> lock(lrs_mtx);
+
+		if (_searchFSM._lastRowSearched > lastRowSearched ||
+		    _searchFSM._lastRowSearched < 0) {
+			/*
+			 * This thread has been slower and processed
+			 * less data. Take the place where it stopped
+			 * as a starting point of the next search.
+			 */
+			_searchFSM._lastRowSearched = lastRowSearched;
+		}
 	};
 
-	auto lamSearchReduce = [&] (QList<int> &resultList,
-				    const QList<int> &mapList) {
-		resultList << mapList;
-		_searchFSM.incrementProgress();
+	auto lamSearchMap = [&] (const int first, bool notify) {
+		int lastRowSearched;
+		QList<int> list;
+
+		list = _proxyModel.searchThread(_searchFSM._columnComboBox.currentIndex(),
+						_searchFSM._searchLineEdit.text(),
+						_searchFSM.condition(),
+						nThreads,
+						first, nRows - 1,
+						&lastRowSearched,
+						notify);
+
+		lamLRSUpdate(lastRowSearched);
+
+		return list;
 	};
 
-	for (auto &r: ranges) {
-		r.first = (i++) * delta;
-		r.second = r.first + delta - 1;
-	}
+	using merge_pair_t = std::pair<int, int>;
+	using merge_container_t = std::vector<merge_pair_t>;
 
-	/*
-	 * If the range is not multiple of the number of threads, adjust
-	 * the last range interval.
-	 */
-	ranges.back().second = nRows - 1;
-	maps.push_back(std::async(lamSearchMap, ranges[0], true));
+	auto lamComp = [] (const merge_pair_t& itemA, const merge_pair_t& itemB) {
+		return itemA.second > itemB.second;
+	};
+
+	using merge_queue_t = std::priority_queue<merge_pair_t,
+						  merge_container_t,
+						  decltype(lamComp)>;
+
+	auto lamSearchMerge = [&] (QList<int> &resultList,
+				   QVector< QList<int> >&mapList) {
+		merge_queue_t queue(lamComp);
+		int id, stop(-1);
+
+		auto pop = [&] () {
+			if (queue.size() == 0)
+				return stop;
+
+			auto item = queue.top();
+			queue.pop();
+
+			if (!mapList[item.first].empty()) {
+				/*
+				 * Replace the popped item with the next
+				 * matching item fron the same search thread.
+				 */
+				queue.push(std::make_pair(item.first,
+							  mapList[item.first].front()));
+				mapList[item.first].pop_front();
+			}
+
+			if (_searchFSM.getState() == search_state_t::Paused_s &&
+			    item.second > _searchFSM._lastRowSearched) {
+				/*
+				 * The search has been paused and we already
+				 * passed the last row searched by the slowest
+				 * search thread. Stop here and ignore all
+				 * following matches found by faster threads.
+				 */
+				return stop;
+			}
+
+			return item.second;
+		};
+
+		for (int i = 0; i < mapList.size(); ++i)
+			if ( mapList[i].count()) {
+				queue.push(std::make_pair(i, mapList[i].front()));
+				mapList[i].pop_front();
+			}
+
+		id = pop();
+		while (id >= 0) {
+			resultList.append(id);
+			id = pop();
+		}
+	};
+
+	startFrom = _searchFSM._lastRowSearched + 1;
+	_searchFSM._lastRowSearched = -1;
+
+	/* Start the thread that will update the progress bar. */
+	maps.push_back(std::async(lamSearchMap,
+				  startFrom,
+				  true)); // notify = true
+
+	/* Start all other threads. */
 	for (int r = 1; r < nThreads; ++r)
-		maps.push_back(std::async(lamSearchMap, ranges[r], false));
+		maps.push_back(std::async(lamSearchMap,
+					  startFrom + r,
+					  false)); // notify = false
 
-	while (_proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
+	while (_searchFSM.getState() == search_state_t::InProgress_s &&
+	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
 		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
 		_proxyModel._pbCond.wait(lk);
 		_searchFSM.setProgress(_proxyModel.searchProgress());
 		QApplication::processEvents();
 	}
 
+	QVector<QList<int>> res;
 	for (auto &m: maps)
-		lamSearchReduce(_matchList, m.get());
+		res.append(std::move(m.get()));
+
+	lamSearchMerge(_matchList, res);
 }
 
 /**
-- 
2.20.1

