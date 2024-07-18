Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C84197
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 00:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721262302; cv=none; b=oVxTBf6Kqd/pFX+ToO9htiN4qWtTN7DRSQ6b5gfqZ/XWh0o/7zZQwfsKkH2vEjMemMDUqkGCZv/06hJEX1N86lGhFiro7ir32CawcGqIaRXDb/yQGBuM2zj4uTs89d/6xYcW4N6gKOVPv9tPn5nNAKYfjvkocD9uhTO03hbB6RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721262302; c=relaxed/simple;
	bh=U5984YXImQsiyMVPKrJT8+zdcIS4ooGrSrQbHfQyHhE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2k959aHlAs/H4DMwOptIGLZ4GmWI+KF8oHkjjUCXjj8yWf0n0VFog0lW+OEJAlSVYX9r2E454TxQ74VxCsrWI/ApBL6lyWLsWYr9AXW04PwrSP7QWzkOmLwOlb3X4aBljGI2WLV4dGkadVpmjllGyM5P+/DmgXyyV1Tf81JKhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B84C2BD10;
	Thu, 18 Jul 2024 00:25:01 +0000 (UTC)
Date: Wed, 17 Jul 2024 20:25:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 29/38] trace-cmd record: prevent memory leak in
 setup_network()
Message-ID: <20240717202504.492440b4@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-30-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-30-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:44 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> Because of the again label, msg_handle can be already allocated if we
> exit after we got a negative socket file descriptor. Free it there.
> 
> Fixes a RESOURCE_LEAK error (CWE-772)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  tracecmd/trace-record.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index b4cbd438..770e775b 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3903,6 +3903,7 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
>  
>  	if (sfd < 0) {
>  		free(thost);
> +		free(msg_handle);

As msg_handle is created with:

	msg_handle = tracecmd_msg_handle_alloc(sfd, 0);

This should be:

	trace_msg_handle_close(msg_handle);

But may require:

			close(sfd);
+			msg_handle->fd = -1;
			free(host);
			host = NULL;
			goto again;

I'll skip this patch.

-- Steve


>  		return NULL;
>  	}
>  

