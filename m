Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246237765D
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jan 2024 17:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706119005; cv=none; b=TH2omTRCtv4VjlGOpQnmDYKSBAlQOfaoc4G9/3C8jx8ObaKism+Zuq1R65H+jtOdPwV+gbNyiMt5uHtxk2uugD6/d1ceP5BLuovdyDtgQsLAmyrpvQYxAkWiFbnywjFvmcXbhyXu3i1z9qWbeOcOBvXUlNrReuDi0WFekPE5U5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706119005; c=relaxed/simple;
	bh=EqZQvAS2ZXZMPyEXJ44cZV7BKPZvosavvkM6hs+MRZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mGfzJshXAXSoY34cNmR4FeNrjrIEiS96sWenSGZi/5Y3X+KUxYM28N1kAz00joFvdjTVjAj9y8crGcoDRYsfQHXksu3LAnhUjtepihHfpfp/cYt0O66UaNZNLeTVXOMVRjVPDUfs1e6VVm6ZqRBLptz5ABDa9yMEckMc4pLN0Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8CCC433F1;
	Wed, 24 Jan 2024 17:56:43 +0000 (UTC)
Date: Wed, 24 Jan 2024 12:58:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Update the kbuf for previous read in
 trace_mmap_load_subbuf()
Message-ID: <20240124125817.70157031@gandalf.local.home>
In-Reply-To: <ZbFOuC0ak6JiOGCJ@google.com>
References: <20240123123337.1f785f98@gandalf.local.home>
	<Za_6Z1uK-KHkU2UV@google.com>
	<20240124115651.6a00a668@gandalf.local.home>
	<ZbFOuC0ak6JiOGCJ@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 Jan 2024 17:54:00 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> > Can I also add your "Tested-by" tag then?
> > 
> > -- Steve  
> 
> Of course, I wasn't sure you were using those tags for libtracefs. Will make it
> more explicit next time!

Thanks.

Yeah, I try to follow the "kernel way" of doing things.

-- Steve
