Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794091232;
	b=bNgJDUwtv9enkuw9pDOrKG8qZ31Mafdj5/k130mlx4fp1dDR2L2fpea764CQtme013Ii
	 T0HMg9ddKrOcyRmrzoV9ZqrLXdwN02YUxdk1Z+SO5UZtPBHGYNhzuSD0CTO2FkvOqiyeH
	 3EKTkhXvMJ/J0WDJQfL7TrdkmAn2LtCQiSp3lJOxskRByVReXtbFtW32rUtvB4K+Klb8O
	 8kN83JL3NHCPL1sCoEIkw52VGwpB9I08WjygDxkGUB20UJe7GknimMtX3obCu1oHjswTn
	 Uq4YkhIPUa0HooKzeRGYjuj7EJHnYOH6obltANpAq0Ass5iougLHb3kHLtU7C/wkmaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794091232;
	h=DMARC-Filter:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Stat-Signature:X-Rspamd-Server:
	 X-Rspamd-Queue-Id:X-Spam-Status:X-Session-Marker:X-Session-ID:
	 DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=yKlny8yLwm3sbkQHf1okpdMOK0R9ixV3h/+nYNK0Sh4=;
	b=Lz3WG5hD8RlMFjxp9Op3MvCBG12nixVx+znmIksmCpo2C1UsEr15Kj9YBNXhC+o0Ferv
	 SI7JFxp8lyRwFJm9ZRc7QVM4UPZ1/oxw/RcJ94R3yAUkSUOL0h/0ym9/WHdeNYapNKDSG
	 NQVGErKzrd5YWUy+GK0fEtUcphzgrR+RtkmbTLZCKczRVi4w8FQcuPD2WCHm/U0bDjQ5m
	 atw+xH6LvCRDwKfNb1laMtaO+RvlRvX5cRQYcHLvEO1fkwvSPA/lsRIzxPHtBTczsfPIF
	 Iae5shS/Y2OWYgIgdHHLu8sIoaXsh59KzAJYtQPibBnwYUxBuiN0nPaim7ih1BmUn2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=pkSuthHB;
	arc=none smtp.remote-ip=216.40.44.17
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC73606A326
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 22:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CC73606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=pkSuthHB
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A86F9A7FF7;
	Sat,  7 Nov 2026 22:40:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 8538720025;
	Sat,  7 Nov 2026 22:40:24 +0000 (UTC)
Date: Sat, 7 Nov 2026 17:40:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Pengfei <ljdlns1987@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Pass the pipe size by value to F_SETPIPE_SZ
Message-ID: <20261107174011.7d86b1de@fedora>
In-Reply-To: <20261107140755.2983258-1-lipengfei28@xiaomi.com>
References: <20261107140755.2983258-1-lipengfei28@xiaomi.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gsde4dyuwm4dsc57nd59zohkfsxudkuq
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 8538720025
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+AU22YfQ7Spmt8J2ZAORycfwmwMX4tMRY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=yKlny8yLwm3sbkQHf1okpdMOK0R9ixV3h/+nYNK0Sh4=; b=pkSuthHBpy3w8WMaX9KZJoARgo23mmrVmF6LaNFPCZdq7J29kjK0v2UtK5ejW8LLau6z7hxk2YPcpHnvfLVbrbcAgAsm/u9hU9LMUdDWJu4ZQuONi74lCVSVuWT9MSVfg1CV99dvlD/4GcB7UKit+sgiGZOCOY55YGAcHJ2eF60=
X-HE-Tag: 1794091224-317279
X-HE-Meta: U2FsdGVkX19wIedA1siaMgdz1mcwiXcyZ+Qi0BwKnMqozw5QAdrbC1WWMbZgT7CRcmSG9PRuR0DXiAcyxUvQdKoc9N1RrHvqr9DheV2ovP9UBSYBoWpGv1HPHYO9diumu+L+cYiyqpIR7813v0bph0OC9bWjKdEcQrshQUI//NIPns16NyI9Qc3bLbJVLfA/FdaeadaxUzxY+bSzu8GP3UrMsHccsFXiJkF8bU7ulrZgiZS46MRvtqGW8ZBXdLyXEFHKiXbS+ic4bzIAUtrdJXeg12gzOZThWFqWIU7zDsXUdA/fTxPzNIzcm+EbSVy7hxWSHkzq4uRdnqOAnel3SqcW1SnMLPGmSF+VM5PrgbJuo0UIdMBoi7d4ZcphakpORhNNrAi6bm0=

On Sat,  7 Nov 2026 22:07:55 +0800
Li Pengfei <ljdlns1987@gmail.com> wrote:

> F_SETPIPE_SZ takes the new size as the argument itself, but init_splice()
> passes a pointer to it.  The kernel takes that argument as an unsigned int,
> so the pointer is truncated to its low 32 bits and used as the size.  That
> usually fails, leaving the pipe at the default 64K, so a sub buffer larger
> than that no longer fits in one splice() and the recorders lose data.  It
> can also succeed at an unrelated size with no error to notice.
> 
> Failing here stays non fatal, as an unprivileged caller cannot raise a pipe
> above /proc/sys/fs/pipe-max-size and the default size still records.

Good catch!

> 
> While here, drop the third argument from the F_GETPIPE_SZ call next to it.
> That command takes no argument and returns the size, so the pointer was
> never read and the return value was already being used.  The branch it fed
> was unreachable: F_GETPIPE_SZ never returns zero on success.
> 
> Signed-off-by: Li Pengfei <lipengfei28@xiaomi.com>
> ---
>  src/tracefs-record.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/src/tracefs-record.c b/src/tracefs-record.c
> index 21a2f6b..9ef13e0 100644
> --- a/src/tracefs-record.c
> +++ b/src/tracefs-record.c
> @@ -554,20 +554,22 @@ static int init_splice(struct tracefs_cpu *tcpu)
>  
>  	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false) > 0) {
>  		int size = atoi(buf);
> -		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
> +
> +		/* F_SETPIPE_SZ takes the size itself, not a pointer to it */

Nit. You don't need to add comments to bug fixes. That is, the above
comment is useless.

Thanks,

-- Steve



> +		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, size);
>  		free(buf);
>  	}
>  
> -	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ, &tcpu->pipe_size);
> +	/* F_GETPIPE_SZ returns the size, it takes no third argument */
> +	ret = fcntl(tcpu->splice_pipe[0], F_GETPIPE_SZ);
>  	/*
>  	 * F_GETPIPE_SZ was introduced in 2.6.35, ftrace was introduced
>  	 * in 2.6.31. If we are running on an older kernel, just fall
> -	 * back to using subbuf_size for splice(). It could also return
> -	 * the size of the pipe and not set pipe_size.
> +	 * back to using subbuf_size for splice().
>  	 */
> -	if (ret > 0 && !tcpu->pipe_size)
> +	if (ret > 0)
>  		tcpu->pipe_size = ret;
> -	else if (ret < 0)
> +	else
>  		tcpu->pipe_size = tcpu->subbuf_size;
>  
>  	tcpu->splice_read_flags = SPLICE_F_MOVE;

