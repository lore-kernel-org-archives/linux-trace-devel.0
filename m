Return-Path: <linux-trace-devel-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726318AbfAIQdU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Jan 2019 11:33:20 -0500
Date: Wed, 9 Jan 2019 11:33:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/6] kernel-shark-qt: Cosmetic modifications in
 KsQuickContextMenu
Message-ID: <20190109113317.751b3561@gandalf.local.home>
In-Reply-To: <20190109130945.28519-3-ykaradzhov@vmware.com>
References: <20190109130945.28519-1-ykaradzhov@vmware.com>
        <20190109130945.28519-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed,  9 Jan 2019 15:09:41 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The following minor modifications in KsQuickContextMenu are introduced:
> 
> 1. Removes the "Apply to list/graph" check-boxes.
> 2. Swaps the position of the Show / Hide actions
> 3. Adds "clear all filters" action.
> 
This should actually be three separate patches. Even if they are minor,
each patch should only do one thing, with the exception of formatting
clean ups. Formatting clean ups can be done when the code that's being
cleaned up is being changed.

But the above are three distinct changes, and should be three distinct
patches. I know it's a little tedious to do it this way, but it's the
cleaner approach.

Can you resend with them separate?

-- Steve


> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark-qt/src/KsQuickContextMenu.cpp | 63 +++++++---------------
>  kernel-shark-qt/src/KsQuickContextMenu.hpp |  4 +-
>  2 files changed, 23 insertions(+), 44 deletions(-)
> 
>
