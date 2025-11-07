Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331C313DDAE;
	Fri,  7 Nov 2025 01:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762477248; cv=none; b=ByL8YePUWeNxpGhKyYxK6TDE2sI3/EBFc0T6QXm9eleHSa0dwqc1EBUAzecCdDKRKLJ69odjmUvgONF/H1PePI21mHna87fODh0ON2xBwH8C2vgx6cv9SoOh/DYhIwr0Z4vleyJGYBpyrJnM3OJoCnucUHeoU5QQeVPhqSyVbQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762477248; c=relaxed/simple;
	bh=sh7WBtru3Ve4ZXDu5KJHFHzU7u/zFBNHXk6GubNn0cM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sLHk+nmPazB7LQgSxn4Xb7EeUgglL/j1IJyRVEPogjSkjS8K51BlgaiS8qdmHWu9Owg9Sg9bKS6QtornRGJD/KtxFgcf2HNuArah8/KBmvUccUmDVp+/XrNo9L/H3WzigvF53TPxG06ugDkWidovDPA9GoFmC2mYvk9A+ujZu3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03A48B8103;
	Fri,  7 Nov 2025 01:00:43 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id 523E560010;
	Fri,  7 Nov 2025 01:00:42 +0000 (UTC)
Date: Thu, 6 Nov 2025 20:00:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Cc: linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: fix incorrcet short option in usage text for
 --threads
Message-ID: <20251106200041.6f21af65@batman.local.home>
In-Reply-To: <20251106031040.1869-1-zhangchujun@cmss.chinamobile.com>
References: <20251106031040.1869-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fkwyknonz573muhmqpiy81nr7nkjffoh
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 523E560010
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/jEbCTWv8sOAs3tljn2A8eHKTvwyf3lN4=
X-HE-Tag: 1762477242-133882
X-HE-Meta: U2FsdGVkX18++BX9ei/tNc2mAiu3nJAyP/S4+Eiwr08YNaBV07EJf3X2Jg3AxucuBvoUvUSzaiBNxbw8UR/CGOwwieegyNT7tbvCIuysFMQ0leUJ641Jf0ZrN576kJomVXVxDbfu4RqAgFy/OOiaddaNRCI7As0Fpk1NBF1os4FADo+3RHAWMvnBP7OE2epeaxYxJPH5HMec+Es5mdakWbLr8NiNKdbgyyqQSEXXBJvJ/9g8bv4EuJS4IuprXS/+kfOYicJlf2zMsbCH/JBK9VfVBx3F55sYtdnrtbm8Onte4G9ALmCO35hnufAqsC5SAdbOeR0Kycmj4ydYpJmDpDfggTn4GyDJ2Btx6jDBhf+kkwNlhO27JA==

On Thu,  6 Nov 2025 11:10:40 +0800
Zhang Chujun <zhangchujun@cmss.chinamobile.com> wrote:

> The help message incorrectly listed '-t' as the short option for
> --threads, but the actual getopt_long configuration uses '-e'.
> This mismatch can confuse users and lead to incorrect command-line
> usage. This patch updates the usage string to correctly show:
> 	"-e, --threads NRTHR"
> to match the implementation.
> 
> Note: checkpatch.pl reports a false-positive spelling warning on
> 'Run', which is intentional.

I'll pull this manually, but you sent to the wrong mailing list. It
should go to linux-trace-kernel@vger.kernel.org and not
linux-trace-devel. That's for user space tools that do not live in the
kernel proper.

-- Steve


> 
> Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
> 
> diff --git a/tools/tracing/latency/latency-collector.c b/tools/tracing/latency/latency-collector.c
> index cf263fe9deaf..ef97916e3873 100644
> --- a/tools/tracing/latency/latency-collector.c
> +++ b/tools/tracing/latency/latency-collector.c
> @@ -1725,7 +1725,7 @@ static void show_usage(void)
>  "-n, --notrace\t\tIf latency is detected, do not print out the content of\n"
>  "\t\t\tthe trace file to standard output\n\n"
>  
> -"-t, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
> +"-e, --threads NRTHR\tRun NRTHR threads for printing. Default is %d.\n\n"
>  
>  "-r, --random\t\tArbitrarily sleep a certain amount of time, default\n"
>  "\t\t\t%ld ms, before reading the trace file. The\n"

