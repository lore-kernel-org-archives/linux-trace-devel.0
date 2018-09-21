Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbeIUTTK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:19:10 -0400
Date: Fri, 21 Sep 2018 09:30:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Remove unused <pthread.h> includes.
Message-ID: <20180921093016.7f662b38@gandalf.local.home>
In-Reply-To: <20180921123027.30405-1-kaslevs@vmware.com>
References: <20180921123027.30405-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 21 Sep 2018 15:30:27 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> There are several <pthread.h> includes lurking eventhough trace-cmd
> makes no use of threading. This patch gets rid of them.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>

Thanks Slavomir!

Those includes look to be a relic of a past design. I think I started
with threads, and then went to forking processes. That's how the
pthread header got there, and then cut & paste let it spread ;-)

-- Steve
