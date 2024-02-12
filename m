Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FC21DDC5
	for <linux-trace-devel@vger.kernel.org>; Mon, 12 Feb 2024 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707773238; cv=none; b=lJrJ1E6EK/DaPgF3WTxY8Xs/kTDXHE68SYbQs+bOap7BmeGDNa9Yi2510xiG62ac49Rl2vc2PEC0aOnO3Z/cHorfaD3mWcGa9eSCLqfjrR9y805JZpq6UJP89X+K5+7NpdhoseYfnuJLWjimCb7IxXWTcLfvAtHPVWTFrDEWOAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707773238; c=relaxed/simple;
	bh=QAGCd8t02EDpNxOmqVC8dxFQw4GvdywFuq8LK9Yn5WU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/Y7aUaD2Ycyz55g6NsCaGkKlf9FeOaaR0da3JLPWMx3zxP+8EdPuO63I3VM2Dh8yKPkh1v6QQNkiMW5t590b/lIKt1FLC/lEDZ0Qpz0PgNfrr5+UnjT64a/VSRzlaD510+ajhQ+7oeEyKD8QsmY3szNfkE9V8jYqYhOYKOXO8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46B4C43390;
	Mon, 12 Feb 2024 21:27:17 +0000 (UTC)
Date: Mon, 12 Feb 2024 16:28:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240212162800.3fe15000@gandalf.local.home>
In-Reply-To: <5f983dc2-2aa2-4f4e-a1c4-ce72007e4f52@arm.com>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
	<20240125112834.2de4eedb@gandalf.local.home>
	<20240125115147.51bcce2a@gandalf.local.home>
	<20240125121025.208a7012@gandalf.local.home>
	<eb976812-06e9-4a0a-93d1-1868ee9d19e1@arm.com>
	<20240201211740.33b43bcd@gandalf.local.home>
	<13355fbc-7592-4a54-8e92-e3d78afa83ae@arm.com>
	<20240211183553.6976670f@rorschach.local.home>
	<5f983dc2-2aa2-4f4e-a1c4-ce72007e4f52@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 12 Feb 2024 10:11:52 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> Ok right. I think I got confused due to the possibility to have multiple
> output files when expanding 'trace-cmd split <TOP_COMMANDS> <INSTANCE_COMMANDS>'

Yeah, I think we got on the tangent of having split become too powerful for
one line. Having it only have one output name probably is the least
confusing. It can be called multiple times if someone wants more complex
parsing.

> 
> I think the description should match this then:
>    trace-cmd split [OTHER_OPTIONS] [--top [-b name]] [-o output_file] [-B instance_name [-t]]*
>      [start-time [end-time]]
> # The '-t' option can only be used once per command line
> 
> or:
>    trace-cmd split <TOP_COMMANDS> <OUTPUT_COMMAND> <INSTANCE_COMMANDS>
> 
>    TOP_COMMANDS :: nil | --top TOP_PARAMS
>    TOP_PARAMS :: nil | -b name
> 
>    OUTPUT_COMMAND :: nil | -o output_file
> 
>    INSTANCE_COMMANDS :: nil | -B name INSTANCE_PARAMS INSTANCE_COMMANDS
>    INSTANCE_PARAMS :: nil | -t
> # INSTANCE_PARAMS can only expand to '-t' once.
> 
> I'm also not sure it is necessary to have a specific order for the
> --top/-o/-B parameters. I should also work when they are unordered
> if we limit the command to one output file:
> - trace-cmd split -B foo -t --top -b old_top -o output.dat
> - trace-cmd split -o output.dat -B foo -t --top -b old_top
> - trace-cmd split -o output.dat --top -b old_top -B foo -t
> should all be equivalent.

Yeah, that's fine. Let's go with that.

-- Steve

