Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9731B44470
	for <linux-trace-devel@vger.kernel.org>; Tue, 17 Oct 2023 14:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797FAC433C9;
	Tue, 17 Oct 2023 14:34:13 +0000 (UTC)
Date: Tue, 17 Oct 2023 10:35:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Yordan Karadzhov
 <y.karadz@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Ross Zwisler
 <zwisler@google.com>
Subject: Re: [PATCH] libtracecmd: Use an rbtree for mapping of cache pages
Message-ID: <20231017103548.5b2f7af7@gandalf.local.home>
In-Reply-To: <d482ec-641e-f2a5-42d6-fbfdadaa4d2f@inria.fr>
References: <20231016230058.2f0e95b1@gandalf.local.home>
	<d482ec-641e-f2a5-42d6-fbfdadaa4d2f@inria.fr>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Oct 2023 09:34:30 +0200 (CEST)
Julia Lawall <julia.lawall@inria.fr> wrote:

> > And exited out when it finished loading and the result was:
> >
> > real    6m14.772s
> > user    6m0.649s
> > sys     0m12.718s
> >
> > That's over 6 minutes to load the trace.dat file!!!
> >
> > I ran perf record on it and it showed 77% of the time was in free_zpage().
> >
> > I pulled out my old algorithms book and wrote up a rbtree for internal use
> > of libtracecmd. Then I switched the cache into a binary rbtree to do the
> > look ups. As the lookups used both where the memory of the compressed page
> > is mapped as well as the offset depending on how the search was done, I
> > found that it only used the memory allocation address in one location.
> > Luckily, the memory allocation mapping lookup also had access to the
> > offset of the file the memory represented. That allowed me to make all
> > lookups use the file offset (Thanks to Masami Hiramatsu for helping me
> > realize that).
> >
> > After converting the cache to an rbtree lookup, I ran kernelshark again on
> > opening that file and exited out as soon as it finished loading and the
> > timings was:
> >
> > real    1m22.356s
> > user    1m10.532s
> > sys     0m10.901s
> >
> > Still a bit long, but it dropped from over 6 minutes to under 1 1/2
> > minutes. Also, free_zpages() was no longer in the perf record output.  
> 
> Does it impact trace-cmd report?

Not as drastically as the above, but running this on the same trace.dat
file without the patch:

  $ time trace-cmd report trace.dat > /dev/null
 real    9m20.390s
 user    9m16.391s
 sys     0m3.529s

With the patch:

  $ time trace-cmd report trace.dat > /dev/null
 real    6m22.935s
 user    6m19.537s
 sys     0m3.139s

So it does bring it down by a third.

I need to send a v2 as I found I left some debugging code in, as well as I
found a small bug in the update of the color of the deleted node if it
wasn't the node to be deleted.

-- Steve
