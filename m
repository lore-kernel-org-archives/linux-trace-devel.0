Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C2A1350E6
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jan 2024 17:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706202626; cv=none; b=IxXQJ6n84iiMD8GfcpHQX/PpPCIvWOv5RtXINCv1wVTX3vClgmoPjgDiuGEKDRZRzw6fQhNnZdyipswB7q4A9QGgvoUYxpHwdNPLayqSDVzDmeQBrUfC/As5praRSddx/nGIaGEDgDqua21bYaEM6xylt0BeelU0PqtkiZHJKNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706202626; c=relaxed/simple;
	bh=u1aXKCZsJ8iM8XxYzBfGVkoD8FB8iuEgMkeziJMYvZM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T5wV6NUop8esN6O1Ju7xOOaTtkGRmKflJl+R5C9ggrL0J4ad2z3TM4x3crEDnrUMp2qbAKi4btjSBawVAzQW/kOcxvdO1Ki8mM/967FYi0zhLyQAwxQ64/e+oGGVxqtojbA4LO09jR28/mc6O7fTpBIOHbFR8ov14p7+B0YNSS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB98CC433C7;
	Thu, 25 Jan 2024 17:10:25 +0000 (UTC)
Date: Thu, 25 Jan 2024 12:10:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 4/5] trace-cmd split: Enable support for buffer
 selection
Message-ID: <20240125121025.208a7012@gandalf.local.home>
In-Reply-To: <20240125115147.51bcce2a@gandalf.local.home>
References: <20240123134215.385415-1-pierre.gondois@arm.com>
	<20240123134215.385415-5-pierre.gondois@arm.com>
	<20240124173740.6d9e2287@gandalf.local.home>
	<1122630e-838e-49fc-9210-55834129088c@arm.com>
	<20240125112834.2de4eedb@gandalf.local.home>
	<20240125115147.51bcce2a@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jan 2024 11:51:47 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> Now if I had had:
> 
>   trace-cmd split -i /work/traces/trace-tast.dat --top  -B tast -o /tmp/trace-tast2.dat
> 
> Then because there was a command "--top" before the -B but it had no -o
> assigned for it, then the input_file would be considered the output file
> and that should act like you described.

Of course then things get confusing if we were to have:

trace-cmd split -i /work/traces/trace-tast.dat  -B foo -o /tmp/trace-foo.dat -B bar

We could specify that each -B will just use the top level by default. So
the above would create:

 /tmp/trace-foo.dat

With the instance "foo"

But the "bar" would be in:

 /work/traces/trace-tast.dat.bar

because the top level didn't specify a -o.

So to make it more specific. Each -B will default to the toplevel output
with ".<instance>" appended to it.

That is:

  split <top-level-commands> -B instance1 <instance1-commands> -B <instance2-commands>

If a -o is specified in the <top-level-commands> it becomes the default top
level output file.  If a -o is not specified in any of the
<instance*-commands> then, it will default to the top level output file
with ".<instance-name>" attached to it unless it has its own -o specified.

For multi-file splits, it will append ".0001", ".0002", etc to that file.

-- Steve


