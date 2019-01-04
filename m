Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726021AbfADVbs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Jan 2019 16:31:48 -0500
Date: Fri, 4 Jan 2019 16:31:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/4] kernel-shark-qt: Cosmetic modifications in
 KsQuickContextMenu
Message-ID: <20190104163145.1cf4240f@gandalf.local.home>
In-Reply-To: <20190104195726.24264-2-ykaradzhov@vmware.com>
References: <20190104195726.24264-1-ykaradzhov@vmware.com>
        <20190104195726.24264-2-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 4 Jan 2019 19:57:52 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This patch does the following minor modifications in

FYI, it is looked down to say "This patch" or "This commit" as people
know what it is. I've seen maintainers get really annoyed by it. I
don't care as much, but I'd like to keep the same requirements as
upstream Linux kernel.


> KsQuickContextMenu:
> 1. Removes the "Apply to list/graph" check-boxes.
> 2. Swaps the position of the Show / Hide actions
> 3. Adds "clear all filters" action.

These should each be a separate patch (one patch that does one thing).

> 
> The code that adds the check-boxes is commented out, because we may
> change our opinion in the future.

Again, lets refrain from commenting out code, and just delete it. git
history will archive it for us ;-)

-- Steve

> 
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsQuickContextMenu.cpp | 94 ++++++++++++----------
>  kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
>  2 files changed, 54 insertions(+), 44 deletions(-)
> 
> diff --git a/kernel-shark-qt/src/KsQuickContextMenu.cpp b/kernel-shark-qt/src/KsQuickContextMenu.cpp
> index 6c9c9ef..3d190f3 100644
> --- a/kernel-shark-qt/src/KsQuickContextMenu.cpp
> +++ b/kernel-shark-qt/src/KsQuickContextMenu.cpp
> @@ -62,7 +62,7 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
>    _addTaskPlotAction(this),
>    _removeCPUPlotAction(this),
>    _removeTaskPlotAction(this),
> -  _deselectAction(this)
> +  _clearAllFilters(this)
>  {
>  	typedef void (KsQuickContextMenu::*mfp)();
>  	QString taskName, parentName, descr;
> @@ -87,37 +87,45 @@ KsQuickContextMenu::KsQuickContextMenu(KsDataStore *data, size_t row,
>  
>  	parentName = parent->metaObject()->className();
>  
