Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3F83770B
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Apr 2025 11:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744890443; cv=none; b=e6inxHfO7hL5imtVTCO2wPSEcYI7SUKqUJAix6X2IM4O+YkKkO92L0OYZTCaVwhQjLGDXdmFugGYS9I68xRW5IsIwasownrfw6NppFVucO+D7FqYYUDgJCYqXkbAvGEXr3GoVJAvlvh/x2/CV3fbwQpfrdqQ0LGjSSN/vn05kp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744890443; c=relaxed/simple;
	bh=lacjLWWjCqDkDimOhdg/Y/o1PubnnWwtPfl6nVvfALQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G38fYp3islnWEnoJHWAFSY3OCKktqbL9alTw0PWQYGpZ2hr0SUldlwy3qzUyBHgtCoEy9j/zbSvZO9+LL1s5Pf5xx0AbEwt1DmX2TE3uCh5vD57iVkOp9MaUdrkyHTmvWcoD1kwrP3a+En9/foKZz+qBGsZ2+5EnleRF8jfLHS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657A8C4CEE4;
	Thu, 17 Apr 2025 11:47:22 +0000 (UTC)
Date: Thu, 17 Apr 2025 07:49:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Malat <oss@malat.biz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent plugins: Add plugin_net to handle bswap
 during print
Message-ID: <20250417074900.15044cc2@gandalf.local.home>
In-Reply-To: <CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
References: <20250409110705.437321-1-oss@malat.biz>
	<20250409225608.12df6ed8@gandalf.local.home>
	<20250414114117.6346acc3@gandalf.local.home>
	<CANMuvJmtk8bbQnT1FgnLzidQ_L1uGrdYypTRoyvLkJhUFVUi=g@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Apr 2025 05:06:44 -0400
Petr Malat <oss@malat.biz> wrote:

> Sorry for the late reply, I tested my patch on mips, arm, arm64 and x86 and
> it works everywhere, but for arm64 I had to add extra functions, because
> it doesn't use the GCC __builin for swapping bytes. I have extended the
> plugin and will send a new version.
> 
> On mips using network order ntohs (and similar) expands to a cast only, so
> the call to swap is not present.

So if you record on x86 and read it on mips (or other big endian machines)
does it produce the correct output? What about recording on mips and then
reading it on x86?

That is, do a "trace-cmd record" on a bigendian or little endian machine,
then copying the trace.dat file to a machine with the opposite endian, and
seeing if it still produces the correct output?

BTW, libtraceevent also provides its own swap functions so if the GCC
builtin is not always available, then it should use that instead.

  See the "tep_data2host*()" fuctions.

But that may need to be updated as "tep_swapbytes*()" and have:

	if (!tep || tep->host_bigendian != tep->file_bigendian)
		return data;

Instead.

-- Steve
