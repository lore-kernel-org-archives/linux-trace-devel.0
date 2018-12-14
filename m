Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:39310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729660AbeLNRKF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 12:10:05 -0500
Date: Fri, 14 Dec 2018 12:10:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] More modifications toward KS 1.0
Message-ID: <20181214121002.4524dab3@gandalf.local.home>
In-Reply-To: <20181214125212.9637-1-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 12:52:33 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This series of patches contains the last (hopefully) modifications
> needed before releasing KernelShark 1.0.
> 
> This is the version 2 of this series of patches. The major changes
> from v1 are in patches 1-3 (new patches). These patches aim to address
> the deadlock problem reported by Steven.
> 
> Yordan Karadzhov (8):
>   kernel-shark-qt: Lock completely the searching panel when searching
>   kernel-shark-qt: Fix a simple bug in KsTraceViewer::_searchReset()
>   kernel-shark-qt: Make the parallelized search stoppable
>   kernel-shark-qt: Avoid spurious searches
>   kernel-shark-qt: Create "Apply filter XX" checkboxes in KsUtils
>   kernel-shark-qt: Improve the KsQuickContextMenu
>   kernel-shark-qt: Update the documentation link
>   kernel-shark-qt: Version 1.0.0
> 

One thing I found annoying, and I'm not sure how to stop this, but the
menu can be awfully touchy. When I'm on the table, and right click
(not hold, just click), it will open up the menu and then select
whatever menu item that the mouse was on, usually hiding the row I'm on.

One solution is to have the mouse be on something that it can not
select immediately. Like "Pointer menu".

Speaking of which, when selecting on the graph, not on an event, where
the menu is:

"Plots 
  Remove [CPU 0]"

the menu is way above the mouse. We probably want the menu to pop up
where the mouse is over "Plots".

-- Steve
  
