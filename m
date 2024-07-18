Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1B15C3
	for <linux-trace-devel@vger.kernel.org>; Thu, 18 Jul 2024 01:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721267607; cv=none; b=mcZL1NuF4yl4XPPa7Z65FxVAm5LH2ODhv5p3q8xCtUTVrTkek8bsj+mjwYVMWZ66vC1fnYoeLPBMjzudwQ0x44yjp0+y3ktJ5UYTbGCcQkVzPkdYvO1KJrhz5171I6Vz71QI5C61idjoVtLito4beZbzkCYGtf37VXU+z6KCCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721267607; c=relaxed/simple;
	bh=6HMXe2MIxxGhbd+M95m0ZoZkeWLDqorDSZQT6T5rYXc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4uvS65O8fTeYcqbOdTnBxWy0cy8tsEzhHRIO5EPlUYFYrbCA7w2Lj2o6unLJ+QYGVdsuxDz/nlPOO3OgaGCejrAZ6LRuL67piw0LfBfHxeCI/wbxtH9HM7dp0n/GctWHJoY5qbP7VGcFYKCki/Or2A0hvN1pQhkLx03bg7LgW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4220C4AF09;
	Thu, 18 Jul 2024 01:53:26 +0000 (UTC)
Date: Wed, 17 Jul 2024 21:53:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 34/38] trace-cmd mem: prevent a memory leak in
 trace_mem()
Message-ID: <20240717215329.0f9d2f02@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-35-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
	<20240605134054.2626953-35-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:49 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> --- a/tracecmd/trace-mem.c
> +++ b/tracecmd/trace-mem.c
> @@ -555,9 +555,10 @@ void trace_mem(int argc, char **argv)
>  
>  	ret = tracecmd_read_headers(handle, 0);
>  	if (ret)
> -		return;
> +		goto out;
>  
>  	do_trace_mem(handle);
>  
> +out:
>  	tracecmd_close(handle);
>  }
> -- 

Would be nicer to have:

	ret = tracecmd_read_headers(handle, 0);
	if (!ret)
		do_trace_mem(handle);

	tracecmd_close(handle);

-- Steve

