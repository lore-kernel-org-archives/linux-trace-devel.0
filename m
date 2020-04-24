Return-Path: <SRS0=pvIb=6I=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF106C54FD0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 20:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F6DD20857
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Apr 2020 20:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgDXUMt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Apr 2020 16:12:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbgDXUMt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Apr 2020 16:12:49 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C3DA20857;
        Fri, 24 Apr 2020 20:12:48 +0000 (UTC)
Date:   Fri, 24 Apr 2020 16:12:46 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel-shark: Change the mechanism of the
 multi-threaded search
Message-ID: <20200424161246.4d9f22b8@gandalf.local.home>
In-Reply-To: <20200330161723.29816-3-y.karadz@gmail.com>
References: <20200330161723.29816-1-y.karadz@gmail.com>
        <20200330161723.29816-3-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


After applying this patch, I was hitting a lockup with this file:

http://rostedt.org/private/trace-all.dat.xz

By selecting "Event" and searching for "sched" it would hang at %87

I found the bug below.

On Mon, 30 Mar 2020 19:17:22 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> --- a/kernel-shark/src/KsModels.cpp
> +++ b/kernel-shark/src/KsModels.cpp
> @@ -52,22 +52,25 @@ size_t KsFilterProxyModel::_search(int column,
>  				   const QString &searchText,
>  				   search_condition_func cond,
>  				   QList<int> *matchList,
> +				   int step,
>  				   int first, int last,
>  				   QProgressBar *pb,
>  				   QLabel *l,
> +				   int *lastRowSearched,
>  				   bool notify)
>  {
>  	int index, row, nRows(last - first + 1);
> -	int pbCount(1);
> +	int milestone(1), pbCount(1);
>  	QString item;
>  
>  	if (nRows > KS_PROGRESS_BAR_MAX)
> -		pbCount = nRows / (KS_PROGRESS_BAR_MAX - _searchProgress);
> +		milestone = pbCount = nRows / (KS_PROGRESS_BAR_MAX - step -
> +					       _searchProgress);
>  	else
>  		_searchProgress = KS_PROGRESS_BAR_MAX - nRows;
>  
>  	/* Loop over the items of the proxy model. */
> -	for (index = first; index <= last; ++index) {
> +	for (index = first; index <= last; index += step) {
>  		/*
>  		 * Use the index of the proxy model to retrieve the value
>  		 * of the row number in the base model.
> @@ -78,17 +81,23 @@ size_t KsFilterProxyModel::_search(int column,
>  			matchList->append(row);
>  
>  		if (_searchStop) {
> -			if (notify) {
> -				_searchProgress = KS_PROGRESS_BAR_MAX;
> +			if (lastRowSearched)
> +				*lastRowSearched = index;
> +
> +			if (notify)
>  				_pbCond.notify_one();
> -			}
>  
>  			break;
>  		}
>  
>  		/* Deal with the Progress bar of the seatch. */
> -		if ((index - first) % pbCount == 0) {
> +		if ((index - first) > milestone) {

Changing the above to:

		if ((index - first) >= milestone) {

fixes it.

> +			milestone += pbCount;
>  			if (notify) {
> +				/*
> +				 * This is a multi-threaded search. Notify
> +				 * the main thread to update the progress bar.
> +				 */
>  				std::lock_guard<std::mutex> lk(_mutex);
>  				++_searchProgress;
>  				_pbCond.notify_one();
> @@ -100,6 +109,7 @@ size_t KsFilterProxyModel::_search(int column,
>  
>  				if (l)
>  					l->setText(QString(" %1").arg(matchList->count()));
> +
>  				QApplication::processEvents();
>  			}
>  		}


 Otherwise it looks like it leaves out the final update and the
code hangs here:

	/* Start all other threads. */
	for (int r = 1; r < nThreads; ++r)
		maps.push_back(std::async(lamSearchMap,
					  startFrom + r,
					  false)); // notify = false

	while (_searchFSM.getState() == search_state_t::InProgress_s &&
	       _proxyModel.searchProgress() < KS_PROGRESS_BAR_MAX - nThreads) {
		std::unique_lock<std::mutex> lk(_proxyModel._mutex);
		_proxyModel._pbCond.wait(lk);

< It's stuck above >

		_searchFSM.setProgress(_proxyModel.searchProgress());
		QApplication::processEvents();
	}


-- Steve

