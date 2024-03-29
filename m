Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D1CC120
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 Mar 2024 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711731328; cv=none; b=S/XXoeHR6MbbjkoaP1pYNOZhZLUQNMNbQETclx8WUblNyFCqHfXllfygdm4sexZi/ZFhRPEyiPdlOOb41bRhWMfT/5KICx1N4YOn0hFhb+eZIo+/xYA0XEkfsKisapFtagpgSmsTuDufs+4J0njV5q68xE7fCKxvalD6EQiSDlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711731328; c=relaxed/simple;
	bh=YwBBSe+f4rAPNK6hrVtBQKYagQdfWE88sVDkWBRkXlU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YpHiAEnNKB7lTHMGAfONu8AZc+kzPRK50sXzUdCKLgTekM3MS5AUpzZ3/UmgOAbQbKcmGnjI1mm91zqzUtRJdhbZQnU9mGB7qjBOKOg+qThYA2aNewMebR0Gw4fVzMn6CPwi+VlBB0IvJeSJUpgd6shbYQfeula0YP3dcjRxp9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546FBC433F1;
	Fri, 29 Mar 2024 16:55:27 +0000 (UTC)
Date: Fri, 29 Mar 2024 12:58:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Mars <paul.mars@canonical.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix tests running on big endian arch
Message-ID: <20240329125811.07648f7d@gandalf.local.home>
In-Reply-To: <20240329142544.845408-1-paul.mars@canonical.com>
References: <20240329142544.845408-1-paul.mars@canonical.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 Mar 2024 15:25:45 +0100
Paul Mars <paul.mars@canonical.com> wrote:

> Tests running on big endian arch (tested on s390x) where failing due to:

Nice, all my big endian machines have died, so I can no longer test on them.

> 
> - a typo in CPUMASK_BYTEPN.
> - a missing call to tep_set_file_bigendian when initializing the test
>   suite.
> 
> Thanks to Mate Kukri <mate.kukri@canonical.com>.

Can you add a signed-off-by please.

And for a change log, do you want:

 Suggested-by: Mate Kukri <mate.kukri@canonical.com>

?

Thanks,

-- Steve



> 
> ---
>  utest/traceevent-utest.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/utest/traceevent-utest.c b/utest/traceevent-utest.c
> index 041843e..b95e478 100644
> --- a/utest/traceevent-utest.c
> +++ b/utest/traceevent-utest.c
> @@ -216,7 +216,7 @@ DECL_CPUMASK_EVENT_DATA(bytep2, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x01);
>  #define CPUMASK_BYTEP2_FMT "cpumask=0,23"
>  
>  DECL_CPUMASK_EVENT_DATA(bytepn, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01);
> -#define CPUMASK_BYTEPN     "ARRAY[80, 00, 00, 00, 00, 00, 80, 01]"
> +#define CPUMASK_BYTEPN     "ARRAY[80, 00, 00, 00, 00, 00, 00, 01]"
>  #define CPUMASK_BYTEPN_FMT "cpumask=0,63"
>  #endif
>  
> @@ -392,6 +392,9 @@ static int test_suite_init(void)
>  	test_tep = tep_alloc();
>  	if (!test_tep)
>  		return 1;
> +#if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
> +	tep_set_file_bigendian(test_tep, TEP_BIG_ENDIAN);
> +#endif
>  	return 0;
>  }
>  

