Return-Path: <SRS0=EnxC=OJ=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:40598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726609AbeLADIS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 30 Nov 2018 22:08:18 -0500
Date: Fri, 30 Nov 2018 10:58:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/2] kernel-shark-qt: Correct the coordinates of the
 Quick Context Menu
Message-ID: <20181130105829.6d77fa15@gandalf.local.home>
In-Reply-To: <20181130153749.4419-1-ykaradzhov@vmware.com>
References: <20181130153749.4419-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 30 Nov 2018 15:38:11 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The "Y" coordinate of the Quick Context Menu has to be corrected in
> the case when the menu gets opened from the Graph widget. This is
> needed because the Graph widget is nested inside a scroll area and
> we have to take into account the offset of the vertical scrollbar.
> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>

Thanks!

I applied both patches.

-- Steve

> ---
>  kernel-shark-qt/src/KsTraceGraph.cpp | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel-shark-qt/src/KsTraceGraph.cpp b/kernel-shark-qt/src/KsTraceGraph.cpp
> index 0b5a8b1..858930c 100644
> --- a/kernel-shark-qt/src/KsTraceGraph.cpp
> +++ b/kernel-shark-qt/src/KsTraceGraph.cpp
> @@ -782,6 +782,12 @@ void KsTraceGraph::_onCustomContextMenu(const QPoint &point)
>  		connect(menu,	&KsQuickMarkerMenu::deselect,
>  			this,	&KsTraceGraph::deselect);
>  
> -		menu->exec(mapToGlobal(point));
> +		QPoint global = mapToGlobal(point);
> +		/*
> +		 * The global coordinates have to be corrected for the offset
> +		 * of the vertical scrollbar.
> +		 */
> +		global.ry() -= _scrollArea.verticalScrollBar()->value();
> +		menu->exec(global);
>  	}
>  }
