Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC8D38F83
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 16:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729009873; cv=none; b=jtXToZPmJkneNHxi5VeoPcys2SnaYtheiWqhxJpg08L0AYXulz1Pd+UwWp/u0CjwNVQOrPAigor+628csAO8+kmkDmLHy32eJSIBRP7vlC7iVsPaWSQbNUa5FNx8DjnIM9G0VqNj2Cywz+9oYg3dcqf31RlJLbWOimviCKX9v+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729009873; c=relaxed/simple;
	bh=XXGdw3EVkFTFvzhf1Y7EJ6L6Wq8HbCZlHyA2t+oGDKw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbPifuaJSRiH3Rf+pZYf1G3w9yHHSLLY5dF9no+okMquGN6quHv0K8Z0pEkm9tkuyZmr/2kYaU/pfAZyJn4VcURGrVOJHMSPr493qW718gXLIycsZat+DwV4FunHk+IFG6tn1ec5xiqfYv39fXPwnXzlZN+6D1+u1amdEmPyJWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E504C4CEC6;
	Tue, 15 Oct 2024 16:31:12 +0000 (UTC)
Date: Tue, 15 Oct 2024 12:31:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] trace-cmd reset: Add option to preserve specific
 events
Message-ID: <20241015123131.1f6872d9@gandalf.local.home>
In-Reply-To: <d46e317c-075a-4c08-a6c8-db236130c35a@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
	<20241014175905.03bec85a@gandalf.local.home>
	<d46e317c-075a-4c08-a6c8-db236130c35a@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 15 Oct 2024 14:30:58 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> On 14/10/2024 10:59 pm, Steven Rostedt wrote:
> > On Mon, 14 Oct 2024 13:31:32 +0100
> > Metin Kaya <metin.kaya@arm.com> wrote:
> >  
> >> Changes since v1:
> >> - Update man page for -k command line parameter of "trace-cmd reset".
> >> - Add tab completion support for "trace-cmd reset".  
> >
> > Thanks, I'll go ahead and apply this. But can you do me a favor, and add a
> > test case to utest/tracecmd-utest.c that tests this. It should create a
> > each of the types, start tracing, do the reset, and make sure that the -k
> > keeps what is expected. Doesn't need to be too fancy.  
> 
> I wrote the patch below, but noticed I'm unable to preserve uprobes
> during reset. I verified trace-cmd tries to prevent
> TRACEFS_DYNEVENT_UPROBE from being destroyed, but I cannot see them
> after running "trace-cmd reset -k uprobe" command.
> The same problem exists for uretprobe, too.
> I confirmed utest uses correct trace-cmd executable.
> 
> Any ideas?

Ug, that's because uprobes are defined in dynamic_events with a "p:", just
like kprobes. :-p  And the tracefs dynamic event parser flags uprobes as
kprobes. Thus, if we are deleting kprobes, we will delete uprobes too.

I need to fix that. We can't change the kernel as it's ABI unfortunately,
but there's other ways libtracefs can differentiate the two.

-- Steve
