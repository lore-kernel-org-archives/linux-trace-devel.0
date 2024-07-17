Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A1B171D8
	for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2024 19:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721243385; cv=none; b=hiPhmNEwak0sR0kMBZwUNytmTW5ezNpNdIpvohRnYkzw/496vy+64cpehPN0g8UPm6cw6Ap2JVQke1HelMYHr27tOJyL0njmPgf5hftryP3E5lFPSs+w1pzowHVzw19GE5/WdXC4c7uqmQ6tKM9d4qtsiTqeR4t3wAdhYeXEsuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721243385; c=relaxed/simple;
	bh=ADE9mj71tY5AzReVA+MU3LkOjiRmUbJkn5aduunDzdY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9Sy/aog/+B36oPBf/qIxwOU67zIJRI8iWI/q6BrkrhPT3jjeVCEQCfZElJfgAxeiqJVG/kHpGwjWO4KQntQMIih574TruP8CWc4tumYalyw4CfzpsiYTheWz86ldTus+dkQ8cCEyaqtpCoGt05Q1A8EJmh5jyeVVPUOA+/Dc3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF652C2BD10;
	Wed, 17 Jul 2024 19:09:44 +0000 (UTC)
Date: Wed, 17 Jul 2024 15:09:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: avidanborisov@gmail.com
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: ptp-timesync: Turn off Nagle for TCP sockets
Message-ID: <20240717150943.458d3560@rorschach.local.home>
In-Reply-To: <20240614132020.1797502-1-avidanborisov@gmail.com>
References: <20240614132020.1797502-1-avidanborisov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Jun 2024 13:20:20 +0000
avidanborisov@gmail.com wrote:

> From: Avidan Borisov <avidanborisov@gmail.com>
> 
> Currently, to establish a tracing session using PTP as a timestamp sync
> protocol, trace-cmd sends overall PTP_SYNC_LOOP*NR_CPUS small messages
> serially one after another. Due to the effects of the Nagle algorithm [1],
> this will in effect send a message every ~200ms, resulting in
> PTP_SYNC_LOOP(340)*200ms = ~68 seconds to process a single traced core.
> 
> Fix this by setting TCP_NODELAY on any TCP socket created by trace-cmd.
> 
> Example on a 32-core machine (host and agent on the same machine for
> simplicity):
> 
> before:
> $ sudo trace-cmd agent -N localhost -p 12345 -D
> $ sudo time -p trace-cmd record -p nop -A 127.0.0.1:12345 --name
> localhost -p nop -- sleep 0
> Negotiated ptp time sync protocol with guest localhost
> CPU31 data recorded at offset=0x245000
>     0 bytes in size (0 uncompressed)
> real 1968.48
> user 19.15
> sys 73.58
> 
> after:
> $ sudo trace-cmd agent -N localhost -p 12345 -D
> $ sudo time -p trace-cmd record -p nop -A 127.0.0.1:12345 --name
> localhost -p nop -- sleep 0
> Negotiated ptp time sync protocol with guest localhost
> CPU31 data recorded at offset=0x245000
>     0 bytes in size (0 uncompressed)
> real 16.52
> user 1.33
> sys 1.52
> 
> This patch reduced the tracing time from 32 minutes to 16 seconds.

Ouch!

Thanks, I'll go ahead and apply this.

-- Steve


> 
> [1]: https://brooker.co.za/blog/2024/05/09/nagle.html
> 
> Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
> ---
>  tracecmd/include/trace-local.h | 10 ++++++++++
>  tracecmd/trace-listen.c        |  2 ++
>  tracecmd/trace-record.c        |  2 ++
>  3 files changed, 14 insertions(+)
> 
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
> index 55934f98..1515fbbe 100644
> --- a/tracecmd/include/trace-local.h
> +++ b/tracecmd/include/trace-local.h
> @@ -11,6 +11,8 @@
>  #include <ctype.h>	/* for isdigit() */
>  #include <errno.h>
>  #include <limits.h>
> +#include <netinet/tcp.h>
> +#include <netinet/in.h>
>  
>  #include "trace-cmd-private.h"
>  #include "event-utils.h"
> @@ -470,4 +472,12 @@ void make_pid_name(char *buf, const char *pidfile_basename);
>  void remove_pid_file(const char *pidfile_basename);
>  void make_pid_file(const char *pidfile_basename);
>  
> +static inline void set_tcp_no_delay(int sockfd, int socktype)
> +{
> +	int flag = 1;
> +
> +	if (socktype == SOCK_STREAM)
> +		setsockopt(sockfd, IPPROTO_TCP, TCP_NODELAY, &flag, sizeof(flag));
> +}
> +
>  #endif /* __TRACE_LOCAL_H */
> diff --git a/tracecmd/trace-listen.c b/tracecmd/trace-listen.c
> index 5894a92d..308c1d9d 100644
> --- a/tracecmd/trace-listen.c
> +++ b/tracecmd/trace-listen.c
> @@ -268,6 +268,7 @@ int trace_net_make(int port, enum port_type type)
>  		if (sd < 0)
>  			continue;
>  
> +		set_tcp_no_delay(sd, rp->ai_socktype);
>  		if (bind(sd, rp->ai_addr, rp->ai_addrlen) == 0)
>  			break;
>  
> @@ -1048,6 +1049,7 @@ static int get_network(char *port)
>  		if (sfd < 0)
>  			continue;
>  
> +		set_tcp_no_delay(sfd, rp->ai_socktype);
>  		if (bind(sfd, rp->ai_addr, rp->ai_addrlen) == 0)
>  			break;
>  
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 91cc90d4..7d03f9d7 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3415,6 +3415,8 @@ static int connect_addr(struct addrinfo *results)
>  			     rp->ai_protocol);
>  		if (sfd == -1)
>  			continue;
> +
> +		set_tcp_no_delay(sfd, rp->ai_socktype);
>  		if (connect(sfd, rp->ai_addr, rp->ai_addrlen) != -1)
>  			break;
>  		close(sfd);

