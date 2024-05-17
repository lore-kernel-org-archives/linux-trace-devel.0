Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD9F13D8B7
	for <linux-trace-devel@vger.kernel.org>; Fri, 17 May 2024 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715972407; cv=none; b=EbPw/QwT+4v09JywLfM3BPHvWXZH14V3WbNRwwKgmRUCWaliIWZbsAOneHemHBa+JfS0KBQQnGY4d6FnOOK9nrPnHYjCimVPw8JJsq3uLoowOp1IHE9MYUjF2CnW2sqcGobLWGvEcxrXlLYkRW6YiG8+q/gmViBf+uBPiY2O/yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715972407; c=relaxed/simple;
	bh=QDGt7U5YDg5Z6bLQqDvvuwzYiWB02pRPb+sVViUdAYo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MS0Wj2DTAf08+D0nDVeqRH26bBpTTonylWSpWoXdkZjdYMuWXP+GlCcVupqXka36fL18D3G633IZHE2Mf50yy2c1luMqcPhs5cTwPwdDhjlj2jAAYbzCwgj2ea4fD2EO+GGxuWB3LD6KU3qwk3dX3vhhxhLVVfsgXqmSb3AuU6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022DEC2BD10;
	Fri, 17 May 2024 19:00:06 +0000 (UTC)
Date: Fri, 17 May 2024 15:00:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval
 option
Message-ID: <20240517150037.5db93c4d@gandalf.local.home>
In-Reply-To: <a40c7f16-d3fd-4a30-987c-7a7d418ea5f3@oracle.com>
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
	<20240415154921.4998-3-jianfeng.w.wang@oracle.com>
	<20240516205302.0cf9640d@rorschach.local.home>
	<a40c7f16-d3fd-4a30-987c-7a7d418ea5f3@oracle.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 May 2024 11:50:29 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> > Honestly, I don't think this should be an option. Or if it is, it
> > should be default on. If the retval exists in the trace, it should just
> > be printed. Why ask the user to show it when they spent the time to
> > enable it in the recording?
> > 

> 
> I make it a default-off option because the feature changes the output format of
> the 'trace-cmd report'. So to be on the safe side, keep the original format by
> default. Also, the kernel has options (i.e., options/funcgraph-retval and
> options/funcgraph-retval-hex) to enable printing functions' retval in trace.log
> 
> >From my point of view, I'd like to see the retval on by default. If you are  
> okay, I'd like to make it default on and add an option to display retval in hex.

Yeah, we can keep both as an option, but make the retval default on.

It will not change default behavior, as it should only be shown if retval
was recorded in the first place. If it wasn't recorded, the behavior should
be the same regardless of if the retval option is enabled or not in the
trace-cmd output.

-- Steve
