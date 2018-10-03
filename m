Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbeJCUmC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 16:42:02 -0400
Date: Wed, 3 Oct 2018 09:53:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: slavomir.kaslev@gmail.com
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] [virt-server] trace-cmd listen: Use sockaddr_storage
 for client addresses
Message-ID: <20181003095330.6f483e92@gandalf.local.home>
In-Reply-To: <20181003082743.12526-1-slavomir.kaslev@gmail.com>
References: <20181003082743.12526-1-slavomir.kaslev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed,  3 Oct 2018 11:27:43 +0300
slavomir.kaslev@gmail.com wrote:

> From: Slavomir Kaslev <kaslevs@vmware.com>
> 
> `trace-cmd listen` is passing a pointer to `struct sockaddr` to `accept`
> with `addrlen` larger than its size which may corrupt the stack.
> 
> Switching it to `struct sockaddr_storage` provides enough space to store
> both TCP and UNIX sockets address.
> 
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  tracecmd/trace-listen.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index c05c2d8..2f2cecc 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -1956,7 +1956,7 @@ static void release_fds(struct client_list *manager)
>  static void do_accept_loop(int nfd, int vfd, int mfd)
>  {
>  	struct client_list *client;
> -	struct sockaddr addr;
> +	struct sockaddr_storage addr;

Bah, nice catch.

-- Steve


>  	socklen_t addrlen;
>  	char *domain = NULL;
>  	int timeout = -1;
> @@ -2024,12 +2024,8 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
>  				continue;
>  
>  			if (i < FD_CONNECTED) {
> -				if (i == FD_NET)
> -					addrlen = sizeof(struct sockaddr_storage);
> -				else
> -					addrlen = sizeof(struct sockaddr_un);
> -
> -				cfd = accept(fds[i].fd, &addr, &addrlen);
> +				addrlen = sizeof(addr);
> +				cfd = accept(fds[i].fd, (struct sockaddr *)&addr, &addrlen);
>  				printf("connected!\n");
>  				if (cfd < 0 && errno == EINTR)
>  					continue;
> @@ -2106,7 +2102,9 @@ static void do_accept_loop(int nfd, int vfd, int mfd)
>  			}
>  
>  			if (i == FD_NET)
> -				pid = do_connection(cfd, &addr, addrlen, NULL, 0, NET,
> +				pid = do_connection(cfd,
> +						    (struct sockaddr *)&addr,
> +						    addrlen, NULL, 0, NET,
>  						    NULL);
>  			else {
>  				pid = do_connection(cfd, NULL, 0,
