Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9F1CA9C
	for <linux-trace-devel@vger.kernel.org>; Fri, 22 Nov 2024 21:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732312114; cv=none; b=jmq+J8u0BUvxl7jJmbO6P+wsJ8y7BM1shFVoemMO5GQLSx+zjGgL15iElZH9hvg3kPABTzhRvlXuk2I5qUzjlPsBLhiKLZPXoi9c5N7NZ+r+fys2BjYNhwX7ZgUz6ynnz+5DqnkapP2PouEa8a1F3Nkvwba6LKebw2THM7hf8AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732312114; c=relaxed/simple;
	bh=FGTCbPBRCXaV4DZCoWjPDLcrBJeN8RNcU7N5Ms1/aSc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZO5TTrIO/2M2tB3o3E6s5QlhOKt58W+3RVrJXXeityvf5ueb3cUvJy77KSvgCDPKSfXXEyoHdrKeXAzNVZKcIN3lAfeGpeE3lj3b1sG/ZZymK/T9+K4eF1e2aNHjDRhHBDljwItrWBL+8IMzYPzE8JKALr6dcuGyP0tsZQ/BmaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6EABC4CECE;
	Fri, 22 Nov 2024 21:48:33 +0000 (UTC)
Date: Fri, 22 Nov 2024 16:49:14 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [PATCH v2] trace-cmd: libtracecmd: Rename private functions to
 fix static building
Message-ID: <20241122164914.1ffdd809@gandalf.local.home>
In-Reply-To: <20241119153300.1668429-1-metin.kaya@arm.com>
References: <20241119153300.1668429-1-metin.kaya@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Nov 2024 15:33:00 +0000
Metin Kaya <metin.kaya@arm.com> wrote:

> diff --git a/tracecmd/trace-agent.c b/tracecmd/trace-agent.c
> index b6b44f58..6b8e40f4 100644
> --- a/tracecmd/trace-agent.c
> +++ b/tracecmd/trace-agent.c
> @@ -32,11 +32,11 @@ static void make_vsocks(int nr, int *fds, unsigned int *ports)
>  	int i, fd, ret;
>  
>  	for (i = 0; i < nr; i++) {
> -		fd = trace_vsock_make_any();
> +		fd = tcmd_vsock_make_any();
>  		if (fd < 0)
>  			die("Failed to open vsocket");
>  
> -		ret = trace_vsock_get_port(fd, &port);
> +		ret = tcmd_vsock_get_port(fd, &port);
>  		if (ret < 0)
>  			die("Failed to get vsocket address");
>  
> @@ -199,8 +199,8 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
>  	if (ret < 0)
>  		die("Failed to receive trace request");
>  

> -	tsync_proto = tracecmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
> -					       tsync_role);
> +	tsync_proto = tcmd_tsync_get_proto(tsync_protos, get_clock(argc, argv),
> +					   tsync_role);

I'm fine with this change in general, except for converting any function
name that starts with "tracecmd_" that is in the tracecmd/ directory. Yes
it's marked as hidden, but these are functions that are not quite ready to
become API, but are planned to.

I used this as a general notation. If it starts with "tracecmd_" and marked
as __hidden, it means that it is still a WIP API. If it is marked with
"trace_" it is just a direct hook between trace-cmd and the libraries.

Care to send a v3?

Thanks,

-- Steve


>  
>  	if (use_fifos && open_agent_fifos(nr_cpus, fds))
>  		use_fifos = false;
> @@ -223,9 +223,9 @@ static void agent_handle(int sd, int nr_cpus, int page_size,
>  				remote_id = -1;
>  				local_id = -2;
>  			}
> -			fd = trace_vsock_make_any();
> +			fd = tcmd_vsock_make_any();
>  			if (fd >= 0 &&
> -			    trace_vsock_get_port(fd, &tsync_port) < 0) {
> +			    tcmd_vsock_get_port(fd, &tsync_port) < 0) {
>  				close(fd);
>  				fd = -1;
>  			}
> @@ -327,13 +327,13 @@ static void agent_serve(unsigned int port, bool do_daemon, int proxy_id,
>  		if (listen(sd, 5) < 0)
>  			die("Failed to listen on %d\n", port);
>  	} else
> -		sd = trace_vsock_make(port);
> +		sd = tcmd_vsock_make(port);
>  	if (sd < 0)
>  		die("Failed to open socket");
>  	tracecmd_tsync_init();
>  
>  	if (!network) {
> -		cid = trace_vsock_local_cid();
> +		cid = tcmd_vsock_local_cid();
>  		if (cid >= 0)
>  			printf("listening on @%u:%u\n", cid, port);
>  	}
