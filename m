Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF843D0DC;
	Tue, 28 Nov 2023 20:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C357EC433C8;
	Tue, 28 Nov 2023 20:28:16 +0000 (UTC)
Date: Tue, 28 Nov 2023 15:28:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: David Vernet <void@manifault.com>, linux-trace-devel@vger.kernel.org,
 linux-trace-users@vger.kernel.org, kernel-team@meta.com,
 julia.lawall@inria.fr, himadrispandya@gmail.com
Subject: Re: [PATCH] trace-cmd record: Reset PATH variable after strtok
 search
Message-ID: <20231128152838.5a7ed1ff@gandalf.local.home>
In-Reply-To: <7be74990-505d-44c3-9d62-5c4147778877@efficios.com>
References: <20231128192435.36507-1-void@manifault.com>
	<20231128143044.72f0925e@gandalf.local.home>
	<20231128200856.GA431764@maniforge>
	<20231128201302.GB431764@maniforge>
	<20231128151823.185839b8@gandalf.local.home>
	<7be74990-505d-44c3-9d62-5c4147778877@efficios.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Nov 2023 15:22:19 -0500
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> On 2023-11-28 15:18, Steven Rostedt wrote:
> > On Tue, 28 Nov 2023 14:13:02 -0600
> > David Vernet <void@manifault.com> wrote:  
> 
> [...]
> 
> >>> That would work too, though I don't think strtok_r() is doing anything
> >>> useful at that point. IMO it's better to either do the setenv() with
> >>> saveptr, or change that strtok_r() to a regular strtok().  
> > 
> > I always use strtok_r() over strtok() just because it's "safer"!
> > 
> > I know it's not necessary, but the number of times I had to switch it to
> > make the code thread safe, I just decided to always use it. Just my personal
> > preference.  
> 
> And if you want to make your code thread-safe, you should favor working 
> on a strdup() copy rather than modifying the argv or env content.

Yes, the fix was to use strdup(). It wasn't even a thread issue, nor a
library issue, as the code in question is part of the trace-cmd executable
and not the libraries. The problem was that it modified the environment
variable and then reused that same environment variable in the exec()
operation :-p


> 
> Also, modifying global state prevents code from being eventually re-used 
> in libraries.

That's why I now always use strtok_r() by default. It is thread (and
library) safe. I avoid using strtok() even when it's perfectly fine to do
so.

-- Steve
