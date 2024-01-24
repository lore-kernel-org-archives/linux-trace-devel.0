Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBFA7E570
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115321; cv=none; b=IAyfjftnttRws7jvfSezc07BQg7dO+hhuklPD2P+YAASI5c6YooVl0qHdnMsWziNNO7vXyK5MtJHpJLbmxhlL1kd++2CF2iLaEy/Ch+DW6HbFuSu6BWSqt4RmJ1EkpN/K6rhmj4WihzJ/QFWMM9/j11V+ujTglwj6RSzxkIGgLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115321; c=relaxed/simple;
	bh=ErOxs4pI8sJC5b7PBrra0VSXmYL7WoldoIEJ9L+vNyo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4djY8dmigGVaOOhgdD357IiHrL3lxXVjwxQ5V8BgGossDAFmaTMv66+jtOILuk/9Lzgom088NQHJXZXlH+lerlulPOPmZi1SvqY3ZoOSmzWiNKutddyWoZ4Ayzj6meZ2c3Ij+ww2cUiEJDejxSy2I88I9iHH0JLU1gOWa3NWvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298E5C433F1;
	Wed, 24 Jan 2024 16:55:19 +0000 (UTC)
Date: Wed, 24 Jan 2024 11:56:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Update the kbuf for previous read in
 trace_mmap_load_subbuf()
Message-ID: <20240124115651.6a00a668@gandalf.local.home>
In-Reply-To: <Za_6Z1uK-KHkU2UV@google.com>
References: <20240123123337.1f785f98@gandalf.local.home>
	<Za_6Z1uK-KHkU2UV@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Jan 2024 17:41:59 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> On Tue, Jan 23, 2024 at 12:33:37PM -0500, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > The trace_mmap() checks if the mmapped data has any previously read data
> > (the reader.read value of the meta page is non-zero), then it will pre-read
> > the kbuf to move its internal reader pointer to the same value.
> > 
> > But when tracefs_cpu_read_buf() calls trace_mmap_load_subbuf(), its
> > kbuf->subbuffer will not be the same as the mapped data and
> > kbuffer_load_subbuffer() is called on it and it is returned. But that means
> > its read pointer has not been updated, and the read data will restart again.
> > 
> > When the kbuf is updated in trace_mmap_load_subbuf() check the tmap->kbuf to
> > see if it already read any of the data, and move the kbuffer forward just
> > like the trace_mmap() does.
> > 
> > Link: https://lore.kernel.org/linux-trace-devel/Za-Md51snPcIoYFn@google.com/
> > 
> > Fixes: 2ed14b59 ("libtracefs: Add ring buffer memory mapping APIs")
> > Reported-by: Vincent Donnefort <vdonnefort@google.com>
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>  
> 
> That fixes fast-forward, event already read are now skipped.

Can I also add your "Tested-by" tag then?

-- Steve
