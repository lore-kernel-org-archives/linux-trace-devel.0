Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA4F3019AA;
	Fri, 21 Nov 2025 20:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763755462; cv=none; b=JnnOVRFduIwGJn6LIsPoRnHTseAr5Rhc1eX4DSsy+O0NoVLYumv6cELgmYTE//7KWnnebQJA+VXWhMGV//itY7/U5sr8n7gnJn/ajq7KrzDMu6cDjjdagLeij0994Tl+cDQVjUyouyQoytWvpfsQDdur/2NiS+KZ9jVlq9qINuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763755462; c=relaxed/simple;
	bh=3gK5p72Xd443dftUAFwP4Wjnrze/C8DyPe7Yar1xAcA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eg1eZERQwjUW6BjQ5jurnjfsXD7Y3iYOw3uuOZ7/kezxwWDDLXrDAOfXOqbJTVOwJ/Z2/6WGW1jJoAJFGjiUNiQ9U3iVx/XORhr6jx9G9ciOU7TprsJmYS1xVQS0rYz/37QDI2V11IZwGbuCTQRXAiZP/ze0NeT2H6basOvGF40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A9884F03D;
	Fri, 21 Nov 2025 20:04:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 88E0F17;
	Fri, 21 Nov 2025 20:04:11 +0000 (UTC)
Date: Fri, 21 Nov 2025 15:04:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Maurice Hieronymus <mhi@mailbox.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
 linux-trace-devel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH] tracing: Fix several comment spelling mistakes
Message-ID: <20251121150446.13d24840@gandalf.local.home>
In-Reply-To: <3716cf61-b1cc-43c6-84e3-cb4c62495549@mailbox.org>
References: <20251116210302.141405-1-mhi@mailbox.org>
	<3716cf61-b1cc-43c6-84e3-cb4c62495549@mailbox.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 88E0F17
X-Stat-Signature: 7dommmbs7kmdby4deub9f9zaqkgcd5qw
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/2hOsP5VSlkNabS6yn2GyYErsLrFih1+w=
X-HE-Tag: 1763755451-384444
X-HE-Meta: U2FsdGVkX1+34YNgq6sGY1mbmLSdzOOMpdnVJ8a56zI3zG+MLcm53LAEm76/Kczcst2qKy7RpPgxXZmFzY/EEfTN7DsVA3Ey8tZS0sDLmecIilvhtxzkeJ4FWt8iIDzm5IE+B1PvJb+omKu1uNSc+3+XTovdURciJzTsTSDIw/4m8KlecMKyZ17eg08Gq/i+dxUGPjGim5LbzHjbBC7qGNTDR0ascNhP+y+KY1vFFLmXgj73ZhVWII/Q4vLA5PJkY/nxQA7PqGbaz8lBOgn2C7iixLdW17dcPsBklg8ljN0HUer9jRtwLwWRrwpUXYzTsuhl2eN8D4FLAFNp+QEgt6bdS2+2T4L8WRZUeNedUknI5cFjs6yPv3ZfM6v8IL/a

On Fri, 21 Nov 2025 19:45:01 +0100
Maurice Hieronymus <mhi@mailbox.org> wrote:

> Hi Steven, hi Ingo,

Note, Ingo is no longer one of the tracing subsystem maintainers. That is
now Masami Hiramatsu. Please update your MAINTAINERS file.

> 
> I've just realized, that I send my patch against trace/master whereas
> the current development seems to happen on trace/for-next.
> 
> I'm new to the mailing list, so please bear with me. Two question arise
> for me:
> 
> Are you even interested in spelling fixes like I did below?

I'll take spelling fixes, but they are very low on the priority list. I'll
usually pull them in after all other patches have been processed in a
release cycle.

> 
> And if yes, does all the new development happens in general on
> trace/for-next?

The trace/for-next branch is for new development of the general tracing
code. But other code may go through other topic branches. There's a
latency/for-next branch that handles the runtime verifier.

Best to break up the patches per file, otherwise they may not apply
correctly.


> 
> Thanks a lot for a quick reply. If I get a positive answer from you I
> will resend my patch on the correct branch.
> 

> > diff --git a/kernel/trace/rv/Kconfig b/kernel/trace/rv/Kconfig
> > index 831779607e84..b76ba1aad0a0 100644
> > --- a/kernel/trace/rv/Kconfig
> > +++ b/kernel/trace/rv/Kconfig
> > @@ -45,7 +45,7 @@ config RV_MON_WWNR
> >  	help
> >  	  Enable wwnr (wakeup while not running) sample monitor, this is a
> >  	  sample monitor that illustrates the usage of per-task monitor.
> > -	  The model is borken on purpose: it serves to test reactors.
> > +	  The model is broken on purpose: it serves to test reactors.

This is not a spelling fix. "borken" is a common word used in the kernel
community.

-- Steve

> >  
> >  	  For further information, see:
> >  	    Documentation/trace/rv/monitor_wwnr.rst
