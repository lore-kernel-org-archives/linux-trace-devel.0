Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:59362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbeLNOul (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 09:50:41 -0500
Date: Fri, 14 Dec 2018 09:50:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 1/8] kernel-shark-qt: Lock completely the searching
 panel when searching
Message-ID: <20181214095037.05d37f87@gandalf.local.home>
In-Reply-To: <20181214125212.9637-2-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
        <20181214125212.9637-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 12:52:34 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> So far, when searching we lock only the text field of the  searching
> panel. This may create a deadlock (as reported by Steven) in the case
> when the user presses "Next" or "Prev." button in the same time when
> a parallelized search is in progress. This patch aims to protect
> against such a deadlock by locking all components of the panel, except
> the "Stop search" button.
> The text panel gets locked only during the actual searching.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsTraceViewer.cpp | 27 +++++++++++++++++++--------
>  kernel-shark-qt/src/KsTraceViewer.hpp |  2 ++
>  2 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/KsTraceViewer.cpp b/kernel-shark-qt/src/KsTraceViewer.cpp
> index a308ea0..afb9892 100644
> --- a/kernel-shark-qt/src/KsTraceViewer.cpp
> +++ b/kernel-shark-qt/src/KsTraceViewer.cpp
> @@ -306,18 +306,29 @@ static bool matchCond(const QString &searchText, const QString &itemText)
>  	return (itemText.compare(searchText, Qt::CaseInsensitive) == 0);
>  }
>  
> +void KsTraceViewer::_lockSearchPanel(bool lock)
> +{
> +	_columnComboBox.setEnabled(!lock);
> +	_selectComboBox.setEnabled(!lock);
> +	_searchLineEdit.setReadOnly(lock);
> +	_prevButton.setEnabled(!lock);
> +	_nextButton.setEnabled(!lock);
> +	_graphFollowsCheckBox.setEnabled(!lock);
> +}

Can we add two helper functions and use that instead?

void KsTraceViewer::_searchPanelLock(void)
{
	_lockSearchPanel(true);
}

void KsTraceViewer::_searchPanelUnlock(void)
{
	_lockSearchPanel(false);
}

This its more in line with the lock / unlock paradigm than passing in
true and false.

Thanks!

-- Steve


> +
>  void KsTraceViewer::_search()
>  {
> -	/* Disable the user input until the search is done. */
> -	_searchLineEdit.setReadOnly(true);
>  	if (!_searchDone) {
> -		int xColumn, xSelect;
> -		QString xText;
> -
>  		/*
>  		 * The search is not done. This means that the search settings
>  		 * have been modified since the last time we searched.
>  		 */
> +		int xColumn, xSelect;
> +		QString xText;
> +
> +		/* Disable the user input until the search is done. */
> +		_lockSearchPanel(true);
> +
>  		_matchList.clear();
>  		xText = _searchLineEdit.text();
>  		xColumn = _columnComboBox.currentIndex();
> @@ -346,6 +357,9 @@ void KsTraceViewer::_search()
>  			if (_graphFollows)
>  				emit select(*_it); // Send a signal to the Graph widget.
>  		}
> +
> +		/* Enable the user input. */
> +		_lockSearchPanel(false);
>  	} else {
>  		/*
>  		 * If the search is done, pressing "Enter" is equivalent
> @@ -353,9 +367,6 @@ void KsTraceViewer::_search()
>  		 */
>  		this->_next();
>  	}
> -
> -	/* Enable the user input. */
> -	_searchLineEdit.setReadOnly(false);
>  }
>  
>  void KsTraceViewer::_next()
> diff --git a/kernel-shark-qt/src/KsTraceViewer.hpp b/kernel-shark-qt/src/KsTraceViewer.hpp
> index 4e35c17..a89fce1 100644
> --- a/kernel-shark-qt/src/KsTraceViewer.hpp
> +++ b/kernel-shark-qt/src/KsTraceViewer.hpp
> @@ -147,6 +147,8 @@ private:
>  
>  	void _graphFollowsChanged(int);
>  
> +	void _lockSearchPanel(bool lock);
> +
>  	void _search();
>  
>  	void _next();
