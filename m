Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FC017E9
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Apr 2024 00:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712881978; cv=none; b=qx/j/ZwjymwU3MQgIqSpJhMXiQxc8vDgLpQl/N3Ms8hVKD8Fa5ks6khgf0y95s4DYaAfxS8O9Ds5a+oUs3KghVQ1caC1HMN/QNz2cKIU0eoTWaFonrwgew8WN19y/9L0WJhEEU7clxz1jDAa3ViEHPThzJn8SBM+LYdZZlfhJZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712881978; c=relaxed/simple;
	bh=un2cceu/BYr+d1Jt3lHnxZRim1K9ufaxd9Dt3r7TKs8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnPMphCV7IxRCOppy4fkRs+9YFWrMyq2ZC+eI+XQyWnGtwq8TX60/5WKE+s1gpyilj0OOf+lna56lQusrVpnaGjx5Y2HfONVymzPlPnv7fmJ0N3LTef0wHvwE7bU6Rmn2BBePjvRAL3vEWWG82jA3t1NbNFsYnT/kqUYHVDIVIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E7DC072AA;
	Fri, 12 Apr 2024 00:32:57 +0000 (UTC)
Date: Thu, 11 Apr 2024 20:35:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Paul Mars <paul.mars@canonical.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Make sure unit test binary fails when
 tests fail
Message-ID: <20240411203537.59790b73@gandalf.local.home>
In-Reply-To: <20240329135331.784707-1-paul.mars@canonical.com>
References: <20240329135331.784707-1-paul.mars@canonical.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 29 Mar 2024 14:53:32 +0100
Paul Mars <paul.mars@canonical.com> wrote:

> If tests in the trace-utest binary fails, it returns 0 anyway.
> 
> So now make sure failing tests will be easily detected by returning 1.

Can you resend with your Signed-off-by?

Thanks,

-- Steve

> ---
>  utest/trace-utest.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/utest/trace-utest.c b/utest/trace-utest.c
> index a26e42e..a0a45db 100644
> --- a/utest/trace-utest.c
> +++ b/utest/trace-utest.c
> @@ -82,6 +82,10 @@ int main(int argc, char **argv)
>  
>  	CU_basic_set_mode(verbose);
>  	CU_basic_run_tests();
> +	int failed_tests = CU_get_number_of_tests_failed();
>  	CU_cleanup_registry();
> +	if (failed_tests != 0){
> +		return 1;
> +	}
>  	return 0;
>  }

