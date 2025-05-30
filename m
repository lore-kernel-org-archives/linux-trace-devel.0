Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEE622B5A8
	for <linux-trace-devel@vger.kernel.org>; Fri, 30 May 2025 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748614170; cv=none; b=bhiCVFdIRURQFXnECd42l3OMSbs2cqiwpTE6v0oJ6iCW1/w9B9D66Cxy4Vy0CtoQyB4ZkEiILQPQHLAJvn38ZUzI8Z29c8aBnFApWCBuY2inmVrh/Q2HgS3BRkGkmlNqNZ7k7BVwxGW0Rfx26AViyq4A0ptoosSRv5gIF2AiE4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748614170; c=relaxed/simple;
	bh=ftEjXERtk3BuhLUTEUDm4LYR+mCeVdFrH/yg8GHpjjU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVSoJWXFYIqjUXqN4H9/nCwcb8qU82a9NySkOOXYmXUSVO7Pp5cEdxp/B9wyTY9d7jsMxggVVF+6sjHLP1O1fy3lLcOuKW0X4ichZ6QIJywoqlO3ZSS2XXRgzAxrnZMw7lCyf9sixA4CuPmV9X637vHvGVceSJrM2bTK6SrvPko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04B8C4CEEB;
	Fri, 30 May 2025 14:09:29 +0000 (UTC)
Date: Fri, 30 May 2025 10:10:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: libtracecmd: tracecmd_filter_add filters unrelated events
Message-ID: <20250530101033.1dcf6f95@gandalf.local.home>
In-Reply-To: <CANMuvJnWm0RpUCw+hMeqzGCig8hydUGYBZWKaNM44zGOM8jFqg@mail.gmail.com>
References: <CANMuvJnWm0RpUCw+hMeqzGCig8hydUGYBZWKaNM44zGOM8jFqg@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 May 2025 09:22:01 -0500
Petr Malat <oss@malat.biz> wrote:

> Hi,
> when I attach a filter "subsys/event:field==val" using
> tracecmd_filter_add(), it filters out all other events as well and
> not just the event, for which the filter is relevant. I want to ask if
> this is intentional or a bug. I expected the function to mirror filter
> feature of ftrace, where setting a filter in events/subsys/event/filter
> has no effect on other events than subsys/event.
> 
> Per event filtering is done using tracecmd_follow_event(), so the
> current behavior of tracecmd_filter_add() is redundant to it and
> prevents creating per event filters without using custom callbacks.
> 
> If this behavior is not intentional, I can prepare a patch to not filter
> out events where none of the fillers is applicable to.

Hmm, I think it was intentional because it's used to do filtering for
trace-cmd report. Changing it will break behavior.

It is supposed to follow what's in the man page: trace-cmd report
under the -F option. If it doesn't follow that, then it is a bug.

-- Steve
