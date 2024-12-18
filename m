Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8D35948
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Dec 2024 22:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734561765; cv=none; b=e8I/aIB9gwKC0vXdlivNhwpl7gTyj6fQJDNVxqC5FVwS9pGs9Z6dsB9r7qr7GsU2wvKYsAy0rYxc3S39jC/7wTNQmWi70l84aEYFepVdA4Nb4PNxEPp9eu4JsuNkag7eFNgF7Z1KWrrTq98bYc5buRKg3l+UmR98X9XdYB/CSUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734561765; c=relaxed/simple;
	bh=+Y1gGp20H6Vgn0sqZ9XG9songe/Nkx+nSuYqzZEkt7I=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2wvWp/p4Tu/tfrOOFN19GA/+2hispbM9TBt7uqw6NmrhyLCpHxLV7US/NZQfmBaXdNC4NlMwiK2S8XCFk/F0PcNJHZGyYpA/obIFW4bO8CJGPYYCRCmT6AKCUFh5EjSf3aHMy+T+qWG7x20AM1lxRuGEVVuT5DYVVunn1WQlsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC70FC4CECD;
	Wed, 18 Dec 2024 22:42:44 +0000 (UTC)
Date: Wed, 18 Dec 2024 17:43:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 1/7] trace-cmd lib: Close FDs in
 create_buffer_recorder_fd2 it allocation fails
Message-ID: <20241218174323.6e043e05@gandalf.local.home>
In-Reply-To: <20241218173731.67e8e865@gandalf.local.home>
References: <20241205144439.127564-1-jmarchan@redhat.com>
	<20241205144439.127564-2-jmarchan@redhat.com>
	<20241218173731.67e8e865@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 18 Dec 2024 17:37:31 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> No. If a function does not open a file descriptor, it should not close it.
> It's bad programming style if a called function closes a file descriptor on
> error that was passed to it. That can easily introduce new bugs.
> 
> The fix is to not have it close a file descriptor at all!

And this means all the callers should close their fd if the recorder fails.
It should have never done that in the first place. :-/

Oh well, that was written over 10 years ago ;-)

-- Steve
