Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24D82367A9
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jun 2025 15:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877517; cv=none; b=iXL8V3TxkxGn0kV/xb3oeBF/aZkNfFuc+XFv++XX2HxCmOrBG+/e2umsfnGfvhBVtVUxJSYb0yoYoIvoScWqC4SEE1QMrIUP+93024P4tqdsv9uxYAoGl9EWI6YtksWPLopZ7eaCv09UnNEKXWZ7tOJ+8xqppRUBKX5l1XA4r24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877517; c=relaxed/simple;
	bh=0+LDWqkTQ7zRAvgWyGUAz1HnhaRwDxFRXk2BQ/97NF4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IwaFEYPg7/Uot/IDXCbfBKOXNu+22t2N+K8Gq+vF8sWDB+VfEa/2BQek6JPydXCThDiVvzuzs/NnR6dDvLXsMychx3r9RIvPSqGG7SRgVPfQDFGvMxExXy5+LY3wYHUZor5CvQC63QOH5rMFRg3RkkUVy1K9Xa6IxejwTbyGDWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F030C4CEEB;
	Mon,  2 Jun 2025 15:18:35 +0000 (UTC)
Date: Mon, 2 Jun 2025 11:19:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH] libtracecmd: Support changing /proc/kallsyms
Message-ID: <20250602111947.676d43c9@gandalf.local.home>
In-Reply-To: <a6def6ddb25d2fcb1b01abcb83c62b8c@linux.ibm.com>
References: <20250416231325.14113-1-iii@linux.ibm.com>
	<20250530164502.4adf0c06@gandalf.local.home>
	<a6def6ddb25d2fcb1b01abcb83c62b8c@linux.ibm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 02 Jun 2025 17:05:13 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> Thanks for taking a look.
> What you propose should work for me.
> Would you mind if I make do_lseek() non-static for this?
> And maybe rename it to tcmd_do_lseek().
> Touching do_compress/msg_handle/pointer/fd directly feels hackish.

Sure, I thought it was a bit hacky too.

-- Steve
