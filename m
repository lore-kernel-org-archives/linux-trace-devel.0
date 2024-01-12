Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06706745C1
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 16:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C0DC433F1;
	Fri, 12 Jan 2024 16:17:11 +0000 (UTC)
Date: Fri, 12 Jan 2024 11:18:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] trace-cmd: split: Handle splitting files with
 multiple instances
Message-ID: <20240112111816.26f2cd6b@gandalf.local.home>
In-Reply-To: <20240112083945.1361293-6-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
	<20240112083945.1361293-6-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 09:39:45 +0100
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


> Make use of the previous patches to split all the instances of
> a trace.

This shouldn't be in the change log. As the change log is for history.
Think about reading this 5 years from now. Would it make sense about
"previous patches"?

Thanks for doing this, I'll try to set some time next week to review them.
I want to release 3.3 soon.

Would you be able to add a way to split out an instance into its own
trace.dat file?  Or to choose what you want.

 $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch

 $ trace-cmd split -B test_instance -o test.dat

Would make test_instance the main buffer in test.dat.

If you add more than one instance:

 $ trace-cmd record -e sched_wakeup -B test_instance -e sched_switch -B timer_instance -e timer

 $ trace-cmd split -B test_instance -o test.dat -B timer_instance

This would make "test_instance" the main buffer, and keep "timer_instance"
as an instance.

The "-o file" placement is important. It will make whatever came before it
the main buffer. And perhaps even split out more than one!

 $ trace-cmd split -B test_instance -o test.dat -B timer_instance -o timer.dat

Would place the "test_instance" as the main instance in test.dat, and the
"timer_instance" as the main instance in timer.dat.

Thoughts?

-- Steve



> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>
