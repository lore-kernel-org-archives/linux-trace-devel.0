Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727554AbeIUTVD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:21:03 -0400
Date: Fri, 21 Sep 2018 09:32:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Slavomir Kaslev <kaslevs@vmware.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] [virt-server] trace-cmd: Fix a minor bug in `trace-cmd
 listen`
Message-ID: <20180921093208.7e66545c@gandalf.local.home>
In-Reply-To: <20180921124617.31327-1-kaslevs@vmware.com>
References: <20180921124617.31327-1-kaslevs@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 21 Sep 2018 15:46:17 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> There is a potential bug caused by C's operator precedence when checking
> the flags set by `poll` in `trace-cmd listen`:
> 
> 			if (!fds[i].revents & POLLIN)
> 				continue;
> 
> vs
> 
> 			if (!(fds[i].revents & POLLIN))
> 				continue;
> 

Nice catch!

> Curiously enough, the bug doesn't manifest itself since POLLIN is equal
> to 1 and `trace-cmd listen` waits only for read events so no other flags
> will be set by `poll`.

Funny how it worked out that way. Probably why it wasn't caught before,
because if it didn't work out that way, it would have shown up quickly
and have been fixed!

-- Steve

> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  tracecmd/trace-listen.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 7bc723e..c05c2d8 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -2020,7 +2020,7 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
>  				continue;
>  			}
>  
> -			if (!fds[i].revents & POLLIN)
> +			if (!(fds[i].revents & POLLIN))
>  				continue;
>  
>  			if (i < FD_CONNECTED) {
