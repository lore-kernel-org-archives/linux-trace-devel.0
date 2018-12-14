Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbeLNDrm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 13 Dec 2018 22:47:42 -0500
Date: Thu, 13 Dec 2018 22:47:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/5] kernel-shark-qt: Avoid spurious searches
Message-ID: <20181213224739.0510e951@vmware.local.home>
In-Reply-To: <20181212165826.8218-2-ykaradzhov@vmware.com>
References: <20181212165826.8218-1-ykaradzhov@vmware.com>
        <20181212165826.8218-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 12 Dec 2018 16:58:44 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Do not search if the text field of search panel is empty.
> Most probably this is an accidental key press or mouse click.
> 
> The text field gets locked only during the actual searching.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsTraceViewer.cpp | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/KsTraceViewer.cpp
> index a308ea0..599b687 100644
> --- a/kernel-shark-qt/src/KsTraceViewer.cpp
> +++ b/kernel-shark-qt/src/KsTraceViewer.cpp
> @@ -308,8 +308,6 @@ static bool matchCond(const QString &searchText, const QString &itemText)
>  
>  void KsTraceViewer::_search()
>  {
> -	/* Disable the user input until the search is done. */
> -	_searchLineEdit.setReadOnly(true);

Hmm, can any races happen by setting the search line read only after
the empty checks?

Also, I found a bug. Try this on a large data file. It doesn't matter
what data file it is.

With the Search: at its start up defaults (with Column = "#"), type
"aaa" in the search window and then hit enter. While the search is
going on, hit the "Next" button. See what happens.

-- Steve


>  	if (!_searchDone) {
>  		int xColumn, xSelect;
>  		QString xText;
> @@ -319,7 +317,19 @@ void KsTraceViewer::_search()
>  		 * have been modified since the last time we searched.
>  		 */
>  		_matchList.clear();
> +
>  		xText = _searchLineEdit.text();
> +		if (xText.isEmpty()) {
> +			/*
> +			 * No text is provided by the user. Most probably this
> +			 * is an accidental key press.
> +			 */
> +			return;
> +		}
> +
> +		/* Disable the user input until the search is done. */
> +		_searchLineEdit.setReadOnly(true);
> +
>  		xColumn = _columnComboBox.currentIndex();
>  		xSelect = _selectComboBox.currentIndex();
>  
> @@ -346,6 +356,9 @@ void KsTraceViewer::_search()
>  			if (_graphFollows)
>  				emit select(*_it); // Send a signal to the Graph widget.
>  		}
> +
> +		/* Enable the user input. */
> +		_searchLineEdit.setReadOnly(false);
>  	} else {
>  		/*
>  		 * If the search is done, pressing "Enter" is equivalent
> @@ -353,9 +366,6 @@ void KsTraceViewer::_search()
>  		 */
>  		this->_next();
>  	}
> -
> -	/* Enable the user input. */
> -	_searchLineEdit.setReadOnly(false);
>  }
>  
>  void KsTraceViewer::_next()
