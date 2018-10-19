Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbeJSK2r (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 06:28:47 -0400
Date: Thu, 18 Oct 2018 22:24:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 04/23] kernel-shark-qt: Add Trace Viewer widget.
Message-ID: <20181018222448.40aedf51@vmware.local.home>
In-Reply-To: <20181016155232.5257-5-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
        <20181016155232.5257-5-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 15:53:01 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> +	if ((freeSpace = viewSize - tableSize) > 0) {
> +		_view.setColumnWidth(nColumns - 1, _view.columnWidth(nColumns - 1) +
> +						   freeSpace -
> +						   2); /* Just a little bit less space.
> +							* This will allow the scroll bar
> +							* to disappear when the widget
> +							* is extended to maximum. */

The above is rather ugly. Again, just have another patch on top that
converts this to:

	if ((freeSpace = viewSize - tableSize) > 0) {
		_view.setColumnWidth(nColumns - 1, _view.columnWidth(nColumns - 1) +
						   freeSpace - 2);
						       /* Just a little bit less space.
							* This will allow the scroll bar
							* to disappear when the widget
							* is extended to maximum. */
	}

-- Steve
