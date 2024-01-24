Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796DFC2C2
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 22:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706135748; cv=none; b=Pr/mhE4EbKY9DGMubEM4HBhnusfCI+azVZ7noqpLlU4yK/i8oR5XtkFnPEDka4kRiDsdGEo6JZ8EiOYOOm6PxvFYTxW01PME+0gBcNcY/4zsKzFvIZWMofzclPqyWkfbxst0ESFBJkj36kQfObeRWGzBUnJTOH6jbHrhCXP9Ld0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706135748; c=relaxed/simple;
	bh=FpdO1i72l7W4h4iv/+znGooHUO41umf4Yo5AjPinSc8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGqSudgdKnHJI1eYH2NurksXNOiHel8HPQSCagg8GVxEw/iNPxzvXdGx82MUCeTE9WrSGhayCT5rT/xGUUcO2dRht/sb9ryBfxXnep+lDE5Uc4fmNGgecuTty2WzICjm1PDX+cwCeaZpe9afHai0a5YyG7H/GtXYLYV5OlnNROE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D7BC433C7;
	Wed, 24 Jan 2024 22:35:47 +0000 (UTC)
Date: Wed, 24 Jan 2024 17:35:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 3/5] trace-cmd split: Handle splitting files with
 multiple instances
Message-ID: <20240124173545.31b00d58@gandalf.local.home>
In-Reply-To: <20240123134215.385415-4-pierre.gondois@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-4-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jan 2024 14:42:13 +0100
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

I applied up to this patch.

Thanks,

-- Steve
