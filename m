Return-Path: <SRS0=S9Jt=ON=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbeLDF4P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Dec 2018 00:56:15 -0500
Date: Tue, 4 Dec 2018 00:56:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com
Subject: Re: [PATCH] trace-cmd: Fix make clean error
Message-ID: <20181204005613.01f84f5d@vmware.local.home>
In-Reply-To: <20181203091936.2881-1-kaslevs@vmware.com>
References: <20181203091936.2881-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Mon,  3 Dec 2018 11:19:36 +0200
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Fix make clean failing when cmake hasn't generated Makefile for KernelShark:
> 
>     $ make clean
>     # ...
>     make -C /home/kaslevs/src/trace-cmd/kernel-shark-qt/build clean
>     make[1]: *** No rule to make target 'clean'.  Stop.
>     make: *** [Makefile:365: clean] Error 2
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>

Applied. Thanks Slavomir!

-- Steve
