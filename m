Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA261BDC3
	for <linux-trace-devel@vger.kernel.org>; Wed, 18 Dec 2024 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734562386; cv=none; b=PaBawgrjeVHhYOO/wQJODUHwjWvr3aZJ+wW/t6qS5ukIYyUKh6VwK85uPFf1UD9EiLTV1BwGfUz61bkRhfVjgmNCbwWbnKEaX3/iYnRkrb/FxWur03KugtFxJFmWytUI6dJay71WDFToYRwODG5rdQiFkhJY7ZTcQUd6nZDWs2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734562386; c=relaxed/simple;
	bh=PI44BSs+GSo4pCZ8qMIWbB3fIX4dcxCy3GgoMtjAFaA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MMN33YaGAXpVHIrj3FqNmEOQM1gq75Q8j7qpBzLVueNUWC9hKr38AgBMoSJvo8qHmS3k6Hi8dIJUtPgC/njGatBY8g21NhqUlNFyYv0nE//qO2CdaThm0A8ACqq3zIXMv7HAGrHoD5Ndxavp29wQDHvXXu5P9VLV25si4Os7eA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546DCC4CECD;
	Wed, 18 Dec 2024 22:53:05 +0000 (UTC)
Date: Wed, 18 Dec 2024 17:53:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/7] trace-cmd: Fix misc issues uncoverd by static
 analysis
Message-ID: <20241218175343.6207107f@gandalf.local.home>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Dec 2024 15:44:32 +0100
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> More issues were found by running static analysers on the code
> of trace-cmd with openscanhub[1].
> 
> [1] https://fedoraproject.org/wiki/OpenScanHub
> 
> Jerome Marchand (7):
>   trace-cmd lib: Close FDs in create_buffer_recorder_fd2 it allocation
>     fails
>   trace-cmd lib: Prevent a memory leak in tracecmd_tsync_with_guest()
>   trace-cmd lib: Prevent a leaked FD in
>     __tracecmd_create_buffer_recorder()
>   trace-cmd lib: Prevent memory leak in tracecmd_msg_wait_for_cmd()
>   trace-cmd sqlhist: Initialize name in trace_sqlhist()
>   trace-cmd: Fix memory leak in stop_mapping_vcpus()
>   trace-cmd record: Fix stdin redirection to /dev/null
> 

I'm going to apply all your patches except the two that deal with file
descriptors. The functions should not be closing file descriptors that they
did not open. The real fix there is to remove where it does close the file
descriptors and move the closing in the error paths of the callers.

I must have gotten lazy and just let the functions do the closing when they
failed, but that is just prone to bugs.

-- Steve


>  lib/trace-cmd/trace-msg.c      |  4 +++-
>  lib/trace-cmd/trace-recorder.c | 19 ++++++++++---------
>  lib/trace-cmd/trace-timesync.c |  1 +
>  tracecmd/trace-record.c        |  2 +-
>  tracecmd/trace-sqlhist.c       |  2 +-
>  tracecmd/trace-tsync.c         |  1 +
>  6 files changed, 17 insertions(+), 12 deletions(-)
> 

