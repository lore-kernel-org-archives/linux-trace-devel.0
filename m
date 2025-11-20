Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2069734B1A7
	for <linux-trace-devel@vger.kernel.org>; Thu, 20 Nov 2025 18:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763662101; cv=none; b=Ccyxc5kdJTFfNKj7XuX+/B8XMzqCEAHRvoRhxb2mTeEtcXlwOGVC2ok1wU2apEvDQDdIHPiniIGNdbkMuOmLvRIKsDpoVC2od2iTGLN3IYgbqlmmTQOu5Uj+w+Qrih+3P8DssJk/A6mgzn1NJY0H6yV8hA5JC8WpBM1bSGfDLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763662101; c=relaxed/simple;
	bh=zMiDEVkJ8zhy6XVMdz1mWcDXPgHMqUKS/UfWMLg6nbs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFWH4n2J8SxZ8TsaZNPuBw6ixH8Ox7tKD1cqH9wNbNZ0XPuVh2vauovzC3TWStCTrvLX7OvDGHV5+Hh211jLYAV+Jv7nT6a97fi5echJQ+wkrsysFWDq0Xs+jg2r5dmFvdac10TCRWlQsDu76b46T+W97fvqYBFlGt3cp3/YSPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40E22884DF;
	Thu, 20 Nov 2025 18:08:10 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id 9F93E17;
	Thu, 20 Nov 2025 18:08:08 +0000 (UTC)
Date: Thu, 20 Nov 2025 13:08:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>
Cc: "linux-trace-devel@vger.kernel.org" <linux-trace-devel@vger.kernel.org>,
 "Kiszka, Jan" <jan.kiszka@siemens.com>
Subject: Re: libtracecmd API extensions
Message-ID: <20251120130840.357cbca6@gandalf.local.home>
In-Reply-To: <ee6cc8b90fb0d71f412645d7671b7130d72fecc2.camel@siemens.com>
References: <ee6cc8b90fb0d71f412645d7671b7130d72fecc2.camel@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: er8w163zjzn5f18915zr3rcfciu1xzth
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 9F93E17
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18K8RZmUwithYl9maYzZyUGXH0W+yQZ5Ys=
X-HE-Tag: 1763662088-51970
X-HE-Meta: U2FsdGVkX1/IU/XMVkd2y0ncXeNTDrwKwThXYHyoNynEmFzfnCIoR/olmipGI2vYNQLyRNyqhg9bEML6kOua+6tiRVkz7MpFHXCCSirVu8vSZJYzvfOBjkGZDYWABiXpvOTHMWFFxCAEZy9tQU8A/fb1CuMvhLJWguuHZR/bKFhu0LWzl3a4GqKdneZWtQDMWqgcvUezickKsstcrcElXepZmvUoGhrIQsQW/uUWL45QwVK5hw5h7XG1lKDfrT3add3+SvpAZv65WJ7NAVLik02jIaV58lnQgyrOR238xywqyis6bCdfzZU7S0odnyG1L3feuMmriFsa/1Nx5E4O3K9TP1Rd9pr1

On Thu, 20 Nov 2025 12:24:18 +0000
"MOESSBAUER, Felix" <felix.moessbauer@siemens.com> wrote:

> Dear Tracers,

Hello!

> 
> while developing a kernel ftrace to Common Trace Format (CTF) converter
> [1], I noticed a couple of aspects of the libtracecmd API I would like
> to discuss. In general, I am VERY happy with the libtracefs,
> libtraceevent and libtracecmd API. These are great libraries which
> really helped to get this implemented easily.
> 
> Trace clocks:
> 
> - Information about the used trace clock is available in the trace.dat,
> however there is no public API to extract it
> - A trace clock (e.g. mono) to world-clock snapshot could be added to
> the trace.dat to more easily align the trace with other traces
> 
> Metadata:
> 
> - some metadata (like uname) is already included in the trace.dat,
> however the APIs to retrieve it are private: tracecmd_get_uname
> - further metadata like a full "uname -a" output and /proc/cmdline
> would be helpful

So, libtracecmd is still very much a work in progress, of something I never
seem to have the time to work on :-p  I don't want to make the mistake I
made with libtraceevent, and have APIs exposed before they are ready. I hate
most of the libtraceevent APIs, but that's because it was ported over to
perf before it was complete, and we got stuck with what we have.

libtracefs was much more planned, and has a better API because of that.

I have lots of ideas for libtracecmd. In fact, the goal is to make
trace-cmd a simple shell of the library, and have every feature of
trace-cmd exposed to other tools. Unfortunately, I just don't have the time
to work on it.

Hence, if you want to add these APIs, I'm more than happy to review any
patches you send my way!

> 
> Event time ranges:
> 
> - it would be good to have an API to get the first and last event
> timestamp per CPU (I'm currently fully walking the events to get that
> data)

Hmm, I could have sworn I implemented something like this in the past.
Perhaps I only did it to my local tree. I have lots of updates to trace-cmd
that haven't made it out to public (simply because they are still in debug
form).

There is a way to iterate backwards:

  tracecmd_iterate_events_reverse()

That would give you the last event without walking all events.

> 
> PS:
> We are also looking into writing a converter in the opposite direction
> (i.e. CTF -> ftrace binary format / trace.dat), but it looks like the
> libtraceevent is a pure parsing library and cannot be used for
> synthesizing. Is this true, or did I miss something?
> 

Yeah, libtraceevent was made to be purely parsing. In fact, there was an
effort to convert it over to flex/bison. But again, time ran out.

That said, if you want to add a feature to create formats, that could
definitely be added.

Cheers,

-- Steve

