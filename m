Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FC52940F
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 02:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721268689; cv=none; b=G5cqC3yNhDKe4HMsmzONj9zc//mrbC7123RiwEM1feAc4r4xHdylaN8jOCh3s+Ideomd1I8btCazRShCv45KpE2rzd/oK1IF5/IAuhCUuW37RF4Se4VaGBbrPTik7EteIPkmUGHu3PCbVRFq6YW0qtnZGBm91AKQ5LFzBijXOjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721268689; c=relaxed/simple;
	bh=ORvceoYn3MRDeRrVNfO3Yzc5/Q2+2Qj77CX60D2i00E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kc4osffjFXKV5xKDVKX79AiPcP+H6bnxNZT+s1gtRW+nYDedbeUdelKQMafnN/5f8kY+ABCT7uK5XwB9rMsfZe449pyADumZLZJ0gpTySP4OG06pHYTsCQKEXlZSE7xwF5rXpI6508E1mrr7jNGZruGuVqe0YeM7qRPmphKtsKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650A6C4AF10;
	Thu, 18 Jul 2024 02:11:29 +0000 (UTC)
Date: Wed, 17 Jul 2024 22:11:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 36/38] trace-cmd record: check the length of the
 protocol version received
Message-ID: <20240717221132.25ab21da@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-37-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-37-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:51 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> In check_protocol_version we compare the protocol version string with
> the expected one ("V3") with memcmp(). The received string could be
> longer than the constant string used for the comparison. That could
> lead to out of range access.
> 
> Check that the received protocol version is not too long.
> 
> Fixes a OVERRUN error (CWE-119)
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> ---
>  tracecmd/trace-record.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index dc3e5285..c3118546 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3810,7 +3810,7 @@ static void check_protocol_version(struct tracecmd_msg_handle *msg_handle)
>  		msg_handle->version = V1_PROTOCOL;
>  		tracecmd_plog("Use the v1 protocol\n");
>  	} else {
> -		if (memcmp(buf, "V3", n) != 0)
> +		if (n > 3 || memcmp(buf, "V3", n) != 0)
>  			die("Cannot handle the protocol %s", buf);

Actually, we may add more to it, so this should be:

		if (n < 3 || memcmp(buf, "V3", 3) != 0)

-- Steve

>  		/* OK, let's use v3 protocol */
>  		write(fd, V3_MAGIC, sizeof(V3_MAGIC));

