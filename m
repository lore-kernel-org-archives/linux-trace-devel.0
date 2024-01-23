Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F313475F
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 00:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969337; cv=none; b=R/QT+PrZimWNM0HFP2YfYwYbFiEccGVaEgH0z9q7/ZMjVd9Xsb3qG+bl3E/9cN6KqEdIVnwYRPlUT9l44Nylm5DdZD1lpoC1dhwzwrKWG504JXeWMr6U1BoHdAdbsa54LdhCChmUQFb0QcAVjC4aBYfk8cPhZycNovKG78nnjLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969337; c=relaxed/simple;
	bh=mq+fJ/lavc4wTUhOGV/7arl8Mqj8wh1ojgg54fJy2MI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbo/1Dep/bIy0K9vS/jqgxs5u6SfeawYVm8sO2fNtNq2kCmW0kyJb5Kd3r9DkdWZaTNlYdq0dhdSTMNHLDYXt3dXWW5EEpwRRntjZzsDfWRL2g4D+OOxpSrz3wL/MZaF9amEZITMrqE7K8JxWruvU7a6ainctV5jWA9fWCSEksM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8078C43394;
	Tue, 23 Jan 2024 00:22:16 +0000 (UTC)
Date: Mon, 22 Jan 2024 19:23:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 5/7] trace-cmd split: Handle splitting files with
 multiple instances
Message-ID: <20240122192346.5a9035e2@gandalf.local.home>
In-Reply-To: <20240122164336.167256-6-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
	<20240122164336.167256-6-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jan 2024 17:43:34 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> trace-cmd can record events in multiple instances:
>   $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch
> 
> When trying to split a trace.dat file recorded with the above command,
> only the events located in the main buffer seems to be split. The
> events recorded in the test_instance buffer seem to be discarded:
>   $ trace-cmd split -i trace.dat -o trace_2.dat 284443 284444
>   $ trace-cmd report trace_2.dat
>     cpus=8
>            <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>            <...>-525991 [004] 284443.173879: sched_wakeup: [...]
>            <...>-525990 [007] 284443.173885: sched_wakeup: [...]
>            <...>-525990 [007] 284443.173885: sched_wakeup: [...]
> (no sign of sched_switch events)
> 
> Keep all instances/buffers of a trace when it is split.
> Also add a 'get_handle()' function.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>

I had two trace.dat files I was checking on. One that just had the top
level instance being traced, and the other that only had an instance.

Until now, my instance trace.dat file did not have any output when doing a
split. Now it does. BUT! I tried the command you had shown in a previous patch:

  ./tracecmd/trace-cmd split -i trace.dat -o /tmp/trace2.dat -r -m 100 3122478 3122479

and it it kept going!

That is, this change broke the fix of the previous change.

-- Steve
